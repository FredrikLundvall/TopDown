unit TileMap;

interface
uses
  SysUtils,
  Math,
  PNGImage,
  PNGImageList,
  Graphics,
  PositionRecord,
  SizeRecord;

type
  TTileMap = class
  protected
    fTileLst: TPNGImageList;
    fColumns : integer;
    fRows : integer;
    fTileMapArray : array of array of Integer;
    fTileSize : integer;
    function getTileName(tileName : string) : string;
    function createPngImageFromFile(tileName : string) : TPNGImage;
  public
    constructor Create(aTileSize : integer; aColumns : Integer; aRows : integer);
    destructor Destroy();
    procedure RandomizeMap();
    procedure Draw(canvas : TCanvas; OffsetPosition : TPositionRecord; clientSize : TSizeRecord);
  end;

implementation

uses
  ImgList;

constructor TTileMap.Create(aTileSize : integer; aColumns : Integer; aRows : integer);
begin
  fColumns := aColumns;
  fRows := aRows;
  SetLength(fTileMapArray, fColumns, fRows);
  fTileSize := aTileSize;
  fTileLst := TPNGImageList.Create(nil);
  fTileLst.ColorDepth := cd32Bit;
  fTileLst.Height := fTileSize;
  fTileLst.Width := fTileSize;
  fTileLst.AddPng(createPngImageFromFile('grass'));
  fTileLst.AddPng(createPngImageFromFile('grass2'));
  fTileLst.AddPng(createPngImageFromFile('grass_with_sand'));
  fTileLst.AddPng(createPngImageFromFile('grass_around_sand'));
  fTileLst.AddPng(createPngImageFromFile('grass_around_sand2'));
  fTileLst.AddPng(createPngImageFromFile('sand_left_grass'));
  fTileLst.AddPng(createPngImageFromFile('sand'));
  //fTileLst.AddPng(createPngImageFromFile('sand_left_trans'));
end;

destructor TTileMap.Destroy();
begin
  fTileLst.Free();
end;

procedure TTileMap.RandomizeMap();
var
  col : Integer;
  row : Integer;
  tileIndex : Integer;
begin
  for row := 0 to fRows - 1 do
  begin
    for col := 0 to fColumns - 1 do
    begin
      if(col < 3) and (row < 3) then
        tileIndex := RandomRange(0,2)
      else if(col < 5) and (row < 5) then
        tileIndex := RandomRange(0,3)
      else if(col < 7) and (row < 7) then
        tileIndex := RandomRange(1,3)
      else
        tileIndex := RandomRange(1,5);

      fTileMapArray[col][row] := tileIndex;
    end;
  end;
end;

function TTileMap.createPngImageFromFile(tileName : string) : TPNGImage;
var
  image : TPNGImage;
begin
  image := TPNGImage.Create();
  image.LoadFromFile(getTileName(tileName));
  Result := image;
end;

function TTileMap.getTileName(tileName : string) : string;
begin
  Result := Format('.\Tiles%d\%s.png',[fTileSize,tileName]);
end;

procedure TTileMap.Draw(canvas : TCanvas; OffsetPosition : TPositionRecord; clientSize : TSizeRecord);
var
  col,x : Integer;
  row,y : Integer;
begin
  if( OffsetPosition.X < 0) then
    OffsetPosition.X := 0;
  if( OffsetPosition.Y < 0) then
    OffsetPosition.Y := 0;
  if( OffsetPosition.X > (fColumns * fTileSize) - clientSize.Width) then
    OffsetPosition.X := (fColumns * fTileSize) - clientSize.Width;
  if( OffsetPosition.Y > (fRows * fTileSize) - clientSize.Height) then
    OffsetPosition.Y := (fRows * fTileSize) - clientSize.Height;

  for row := 0 to fRows - 1 do
  begin
    for col := 0 to fColumns - 1 do
    begin
      x := col * fTileSize - OffsetPosition.X;
      y := row * fTileSize  - OffsetPosition.Y;
      if((x > -fTileSize) and (x < clientSize.Width)) and ((y > - fTileSize) and (y < clientSize.Height)) then
        fTileLst.Draw(canvas,x,y,fTileMapArray[col][row],True);
    end;
  end;
end;

end.
