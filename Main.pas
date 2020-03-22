unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls,
  Generics.Collections,
  Generics.Defaults,
  Math,
  StopWatch,
  TimeSpan,
  SizeRecord,
  PositionRecord,
  TileMap,
  AnimationArchive,
  Animation,
  Frame,
  ZombieController,
  ZombieCharacter,
  ZombieDirection, Menus, ActnList, StdCtrls, MPlayer;

type

  TTopDownMainFrm = class(TForm)
    ZombieActionLst: TListBox;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AppIdle(Sender: Tobject; var Done: Boolean);
    procedure FormShow(Sender: TObject);
    procedure ZombieActionLstClick(Sender: TObject);
    procedure ZombieActionLstMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  protected
    fTileMap : TTileMap; //The tilemap used for draw the graphics to the screen
    fZombieController : TZombieController;
    fTileMapOffsetPosition : TPositionRecord; //Position of the tilemaps upper left corner in the screen (can be used for scrolling the graphics)
    fMousePosition : TPositionRecord;
    fMousePositionDestination : TPositionRecord;
    fMousePositionStartDrag : TPositionRecord;
    fZombieList : TObjectList<TZombieCharacter>;
    fLeftMousePressed : Boolean;
    fLeftMouseReleased : Boolean;
    fStopwatchLogic: TStopWatch; //Keeps the time between the updates of input
    fStopwatchGraphics: TStopWatch; //Keeps the time between updates of graphics
    //Can be called many times between frames, elapsedTime is how long time that has passed from last call
    procedure UpdateLogic(elapsedSeconds : double);
    //Called one time every frame, elapsedTime is how long time that has passed from last call
    procedure UpdateGraphics(elapsedSeconds : double);
    procedure GoHereSelected(aStateAtDestination : TZombieState);
  end;

var
  TopDownMainFrm: TTopDownMainFrm;
const
  TILE_SIZE = 128;
  TILE_MAP_WIDTH = 20;
  TILE_MAP_HEIGHT = 12;

  SECONDS_BETWEEN_FRAMES = 0.0055;

implementation

{$R *.dfm}

procedure TTopDownMainFrm.FormCreate(Sender: TObject);
  function MakeRandomMapPosition() : TPositionRecord;
  begin
    Result := TPositionRecord.Create(RandomRange(100,(TILE_SIZE * TILE_MAP_WIDTH) - 100),RandomRange(100,(TILE_SIZE * TILE_MAP_HEIGHT) - 100))
  end;
  function MakeRandomZombieDirection() : TZombieDirection;
  begin
    Result := TZombieDirection(RandomRange(0,8))
  end;
  function MakeRandomZombieState() : TZombieState;
  begin
    Result := TZombieState(RandomRange(0,3))
  end;
var
  i : integer;
begin
  fTileMapOffsetPosition.X := 0;
  fTileMapOffsetPosition.Y := 0;
  fTileMap := TTileMap.Create(TILE_SIZE,TILE_MAP_WIDTH,TILE_MAP_HEIGHT);
  Randomize();
  fTileMap.RandomizeMap();
  fLeftMousePressed := false;
  fLeftMouseReleased := False;
  fStopwatchLogic := TStopwatch.Create();
  fStopwatchGraphics := TStopwatch.Create();
  Application.OnIdle := AppIdle;
  fZombieController := TZombieController.Create(TAnimationArchive.Create('.\Characters\Zombie\zombie_0.png',36,9)); //Snett uppifrån med skugga
  //fZombieController := TZombieController.Create(TAnimationArchive.Create('.\Characters\Zombie\zombie_topdown.png',36,9)); //Rakt uppifrån (större)

  fZombieList := TObjectList<TZombieCharacter>.Create(True);
  for i := 0 to 99 do
    fZombieList.Add(TZombieCharacter.Create(MakeRandomMapPosition(),MakeRandomZombieDirection(),MakeRandomZombieState()));
end;

procedure TTopDownMainFrm.FormPaint(Sender: TObject);
var
  elapsedTimeGraphics : double;
begin
  elapsedTimeGraphics := fStopwatchGraphics.GetElapsedSecondsWhenRunning();
  if(elapsedTimeGraphics > SECONDS_BETWEEN_FRAMES) then
  begin
    UpdateGraphics(elapsedTimeGraphics);
    fStopwatchGraphics.Stop();
    fStopwatchGraphics.Start();
  end;
end;

procedure TTopDownMainFrm.FormShow(Sender: TObject);
begin
  fStopwatchLogic.Start();
  fStopwatchGraphics.Start();
end;

procedure TTopDownMainFrm.GoHereSelected(aStateAtDestination : TZombieState);
var
  zombie : TZombieCharacter;
  mousePosition : TPositionRecord;
begin
  mousePosition.X := fMousePositionDestination.X - CHARACTER_WIDTH div 2 + fTileMapOffsetPosition.X;
  mousePosition.Y := fMousePositionDestination.Y - CHARACTER_HEIGHT + 33 + fTileMapOffsetPosition.Y;
  for zombie in fZombieList do
  begin
    if(zombie.GetSelected()) then
    begin
      zombie.SetDestination(mousePosition);
      zombie.SetStateAtDestination(aStateAtDestination);
      zombie.SetState(TZombieState.Ordered);
    end;
  end;
end;

procedure TTopDownMainFrm.AppIdle(Sender: Tobject; var Done: Boolean);
begin
  UpdateLogic(fStopwatchLogic.GetElapsedSecondsWhenRunning());
  fStopwatchLogic.Stop();
  fStopwatchLogic.Start();

  if(fStopwatchGraphics.GetElapsedSecondsWhenRunning() > SECONDS_BETWEEN_FRAMES) then
    Self.Invalidate();
  Done := False;
end;

procedure TTopDownMainFrm.UpdateGraphics(elapsedSeconds : double);
var
  clientSize : TSizeRecord;
  zombie : TZombieCharacter;
begin
  clientSize.Width := Self.ClientWidth;
  clientSize.Height := Self.ClientHeight;
  Canvas.Lock();
  fTileMap.Draw(Canvas,fTileMapOffsetPosition,clientSize);
  if(fLeftMousePressed) then
  begin
    Canvas.Brush.Color := clDkGray;
    Canvas.FrameRect(Rect(fMousePositionStartDrag.X, fMousePositionStartDrag.Y, fMousePosition.X, fMousePosition.Y));
  end;

  //Sortera med lägsta y-värde först för att rita de bakomliggande längst bak
  //(för isometriskt perspektiv, annars spelar det ingen roll)
  fZombieList.Sort(TComparer<TZombieCharacter>.Construct(
    function (const L, R: TZombieCharacter): integer
    begin
      Result := CompareValue(L.GetPosition().Y,R.GetPosition().Y);
    end
  ));
  for zombie in fZombieList do
    fZombieController.DrawCharacter(zombie,Canvas,fTileMapOffsetPosition);

  Canvas.UnLock();
end;

procedure TTopDownMainFrm.UpdateLogic(elapsedSeconds : double);
var
  zombie : TZombieCharacter;
  pt : tPoint;
  mousePosition : TPositionRecord;
  someClicked : Boolean;
  someSelected : Boolean;
begin
  if(GetKeyState(VK_RIGHT) < 0) then
    fTileMapOffsetPosition.X := fTileMapOffsetPosition.X + Trunc(500.0 * elapsedSeconds);
  if(GetKeyState(VK_LEFT) < 0) then
    fTileMapOffsetPosition.X := fTileMapOffsetPosition.X - Trunc(500.0 * elapsedSeconds);
  if(GetKeyState(VK_DOWN) < 0) then
    fTileMapOffsetPosition.Y := fTileMapOffsetPosition.Y + Trunc(500.0 * elapsedSeconds);
  if(GetKeyState(VK_UP) < 0) then
    fTileMapOffsetPosition.Y := fTileMapOffsetPosition.Y - Trunc(500.0 * elapsedSeconds);

  if( fTileMapOffsetPosition.X < 0) then
    fTileMapOffsetPosition.X := 0;
  if( fTileMapOffsetPosition.Y < 0) then
    fTileMapOffsetPosition.Y := 0;
  if( fTileMapOffsetPosition.X > (TILE_MAP_WIDTH * TILE_SIZE) - Self.ClientWidth) then
    fTileMapOffsetPosition.X := (TILE_MAP_WIDTH * TILE_SIZE) - Self.ClientWidth;
  if( fTileMapOffsetPosition.Y > (TILE_MAP_HEIGHT * TILE_SIZE) - Self.ClientHeight) then
    fTileMapOffsetPosition.Y := (TILE_MAP_HEIGHT * TILE_SIZE) - Self.ClientHeight;

  //Add time for animation and state and sense check (AI routines)
  for zombie in fZombieList do
    zombie.AddElapsedSeconds(elapsedSeconds);

  pt := Mouse.CursorPos; //Mouse position in screen
  pt := ScreenToClient(pt); //Form position
  fMousePosition := TPositionRecord.Create(pt.X,pt.Y); //Change to different type of position

  //Some logic to toggle the mousebutton down or up (you have to release the button before you can select again)
  if(GetAsyncKeyState(VK_LBUTTON) < 0) then
  begin
    if not fLeftMousePressed then
    begin
      fMousePositionStartDrag := fMousePosition;
    end;
    fLeftMousePressed := True;
  end
  else
  begin
    if(fLeftMousePressed) then
      fLeftMouseReleased := True
    else
      fLeftMouseReleased := False;

    fLeftMousePressed := False;
  end;

  if fLeftMouseReleased then
  begin
    //Check if this was the end of a mouse-drag
    if(fMousePositionStartDrag.X <> fMousePosition.X) and (fMousePositionStartDrag.Y <> fMousePosition.Y) then
    begin
      for zombie in fZombieList do
      begin
        //Select or deselects when click
        if fZombieController.RectangleCollisionWithCharacter(zombie,fTileMapOffsetPosition,fMousePositionStartDrag,fMousePosition) then
        begin
          zombie.SetSelected( true );
        end;
      end;
    end
    else
    begin
      someClicked := False;
      someSelected := False;
      for zombie in fZombieList do
      begin
        //Select or deselects when click
        if fZombieController.PositionCollisionWithCharacter(zombie,fTileMapOffsetPosition,fMousePosition) then
        begin
          zombie.SetSelected( not zombie.GetSelected() );
          someClicked := True;
        end;
        if( zombie.GetSelected() ) then
          someSelected := True;
      end;

      if(not someClicked) then
      begin
        //Shows or hides action-menu
        if(not ZombieActionLst.Visible) and (someSelected) then
        begin
          fMousePositionDestination := fMousePosition;
          ZombieActionLst.Left := fMousePosition.X - ZombieActionLst.Width div 2;
          ZombieActionLst.Top := fMousePosition.Y;
          ZombieActionLst.Visible := True;
          ZombieActionLst.ItemIndex := 0;
          ZombieActionLst.SetFocus();
        end
        else
        begin
          ZombieActionLst.Visible := False;
        end;
      end;
    end;
  end;

  //Right mousebutton deselects everyone
  if(GetAsyncKeyState(VK_RBUTTON) < 0) then
  begin
    ZombieActionLst.Visible := False;
    for zombie in fZombieList do
    begin
      zombie.SetSelected(false);
    end;
  end;

end;

procedure TTopDownMainFrm.ZombieActionLstClick(Sender: TObject);
begin
  if (ZombieActionLst.ItemIndex = 0) then
    GoHereSelected(TZombieState.Calm)
  else if (ZombieActionLst.ItemIndex = 1) then
    GoHereSelected(TZombieState.Angry);

  ZombieActionLst.Visible := False;
  fLeftMouseReleased := False;
  fLeftMousePressed := False;
end;

procedure TTopDownMainFrm.ZombieActionLstMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  p:TPoint;
begin
  p.x:=x;
  p.y:=y;
  ZombieActionLst.ItemIndex := ZombieActionLst.ItemAtPos(P,True);
end;

end.


//  //Check if not inside the action-menu when clicking (or the action-menu is not visible)
//  if (not PtInRect(ZombieActionLst.ClientRect, pt) or not ZombieActionLst.Visible) then

