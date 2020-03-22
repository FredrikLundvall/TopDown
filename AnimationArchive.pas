unit AnimationArchive;

interface
uses
  SysUtils,
  Math,
  PngFunctions,
  Contnrs,
  Generics.Collections,
  Graphics,
  PositionRecord,
  SizeRecord,
  pngimage,
  Classes,
  Windows,
  Animation,
  Frame;

type
  TAnimationArchive = class
  protected
    fImageArchive: TObjectList;
    fAnimations: TObjectDictionary<string, TAnimation>;
    function AddImagesFromJoinedFile(fileName : string; Columns, Rows: Integer) : Integer;
    function AddImage(fileName : string) : integer;
  public
    constructor Create(fileName : string; Columns, Rows: Integer);
    destructor Destroy();
    procedure DrawImage(canvas : TCanvas; x,y : Integer; imageIndex : integer);
    function AddAnimation(Name : string) : TAnimation;
    function GetAnimation(Name : string) : TAnimation;
    procedure DrawAnimation(Name : string; canvas : TCanvas; x,y : Integer; totalElapsedSeconds : Double);
  end;

implementation

constructor TAnimationArchive.Create(fileName : string; Columns, Rows: Integer);
begin
  fImageArchive := TObjectList.Create(True);
  fAnimations := TObjectDictionary<string, TAnimation>.Create([doOwnsValues]);
  AddImagesFromJoinedFile(fileName,Columns, Rows);
end;

destructor TAnimationArchive.Destroy();
begin
  fImageArchive.Free();
  fAnimations.Free();
end;

function TAnimationArchive.AddAnimation(Name: string): TAnimation;
begin
  fAnimations.Add(Name, TAnimation.Create());
  Result := fAnimations[Name];
end;

function TAnimationArchive.GetAnimation(Name: string): TAnimation;
begin
  Result := fAnimations[Name];
end;

function TAnimationArchive.AddImage(fileName : string) : integer;
var
  image : TPngImage;
begin
  image := TPngImage.Create();
  image.LoadFromFile(fileName);
  fImageArchive.Add(image);
  Result := fImageArchive.Count - 1;
end;

function TAnimationArchive.AddImagesFromJoinedFile(fileName : string; Columns, Rows: Integer) : Integer;
var
  image : TPngImage;
begin
  image := TPngImage.Create();
  image.LoadFromFile(fileName);
  SlicePNG(image,Columns,Rows,fImageArchive);
  Result := fImageArchive.Count - 1;
end;

procedure TAnimationArchive.DrawAnimation(Name: string; canvas: TCanvas; x, y: Integer; totalElapsedSeconds: Double);
var
  frame : TFrame;
  image : TPngImage;
begin
  frame := fAnimations[Name].GetCurrentFrame(totalElapsedSeconds);
  image := fImageArchive[frame.GetImageIndex()] as TPngImage;
  x := x + Frame.GetOffset().X;
  y := y + Frame.GetOffset().Y;
  image.Draw(canvas,Rect(x,y,x + image.Width, y + image.Height));
end;

procedure TAnimationArchive.DrawImage(canvas : TCanvas; x,y : Integer; imageIndex : Integer);
var
  image : TPngImage;
begin
  //if((x > - image.Width) and (x < clientSize.Width)) and ((y > - image.Height) and (y < clientSize.Height)) then
  image := fImageArchive[imageIndex] as TPngImage;
  image.Draw(canvas,Rect(x,y,x + image.Width, y + image.Height));
end;

end.
