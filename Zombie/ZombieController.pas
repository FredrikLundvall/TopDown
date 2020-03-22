unit ZombieController;

interface
uses
  Graphics,
  PositionRecord,
  Animation,
  AnimationArchive,
  Frame,
  ZombieAction,
  ZombieDirection,
  ZombieCharacter;

type

TZombieController = class
protected
  fAnimationArchive : TAnimationArchive;
  procedure MakeAnimation_stance();
  procedure MakeAnimation_lurch();
  procedure MakeAnimation_slam();
  procedure MakeAnimation_bite();
  procedure MakeAnimation_block();
  procedure MakeAnimation_hitndie();
  procedure MakeAnimation_criticaldeath();
  procedure MakeAnimation_selected();
  procedure MakeAnimation_destination();
public
  constructor Create(aAnimationArchive : TAnimationArchive);
  destructor Destroy();
  function GetAnimationArchive() : TAnimationArchive;
  procedure DrawCharacter(aZombie : TZombieCharacter; aCanvas : TCanvas; aMapPosition : TPositionRecord);
  function PositionCollisionWithCharacter(aZombie : TZombieCharacter; aMapPosition : TPositionRecord; collisionPosition : TPositionRecord) : Boolean;
  function RectangleCollisionWithCharacter(aZombie: TZombieCharacter; aMapPosition, aLeftTopPosition, aRightBottomPosition: TPositionRecord): Boolean;
end;
const
  CHARACTER_WIDTH = 128;
  CHARACTER_HEIGHT = 128;

implementation

procedure TZombieController.MakeAnimation_stance();
var
  animation : TAnimation;
  i : Integer;
begin
  for i := 0 to 7 do
  begin
    animation := fAnimationArchive.AddAnimation(ZombieAnimationAction[Ord(TZombieAction.Stance)] + ZombieAnimationDirection[i]);
    animation.AddFrame(TFrame.Create(0 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(1 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(2 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(3 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(2 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(1 + i *36,TPositionRecord.Create(0,0),0.11));
  end;
end;

procedure TZombieController.MakeAnimation_lurch();
var
  animation : TAnimation;
  i : Integer;
begin
  for i := 0 to 7 do
  begin
    animation := fAnimationArchive.AddAnimation(ZombieAnimationAction[Ord(TZombieAction.Lurch)] + ZombieAnimationDirection[i]);
    animation.AddFrame(TFrame.Create(4 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(5 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(6 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(7 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(8 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(9 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(10 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(11 + i *36,TPositionRecord.Create(0,0),0.11));
  end;
end;

procedure TZombieController.MakeAnimation_slam();
var
  animation : TAnimation;
  i : Integer;
begin
  for i := 0 to 7 do
  begin
    animation := fAnimationArchive.AddAnimation(ZombieAnimationAction[Ord(TZombieAction.Slam)] + ZombieAnimationDirection[i]);
    animation.AddFrame(TFrame.Create(12 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(13 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(14 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(15 + i *36,TPositionRecord.Create(0,0),0.11));
  end;
end;

procedure TZombieController.MakeAnimation_bite();
var
  animation : TAnimation;
  i : Integer;
begin
  for i := 0 to 7 do
  begin
    animation := fAnimationArchive.AddAnimation(ZombieAnimationAction[Ord(TZombieAction.Bite)] + ZombieAnimationDirection[i]);
    animation.AddFrame(TFrame.Create(16 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(17 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(18 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(19 + i *36,TPositionRecord.Create(0,0),0.11));
  end;
end;

procedure TZombieController.MakeAnimation_block();
var
  animation : TAnimation;
  i : Integer;
begin
  for i := 0 to 7 do
  begin
    animation := fAnimationArchive.AddAnimation(ZombieAnimationAction[Ord(TZombieAction.Block)] + ZombieAnimationDirection[i]);
    animation.AddFrame(TFrame.Create(20 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(20 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(20 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(21 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(21 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(21 + i *36,TPositionRecord.Create(0,0),0.11));
  end;
end;

procedure TZombieController.MakeAnimation_hitndie();
var
  animation : TAnimation;
  i : Integer;
begin
  for i := 0 to 7 do
  begin
    animation := fAnimationArchive.AddAnimation(ZombieAnimationAction[Ord(TZombieAction.Hitndie)] + ZombieAnimationDirection[i]);
    animation.AddFrame(TFrame.Create(22 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(23 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(24 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(25 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(26 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(27 + i *36,TPositionRecord.Create(0,0),0.11));
  end;
end;

procedure TZombieController.MakeAnimation_criticaldeath();
var
  animation : TAnimation;
  i : Integer;
begin
  for i := 0 to 7 do
  begin
    animation := fAnimationArchive.AddAnimation(ZombieAnimationAction[Ord(TZombieAction.Criticaldeath)] + ZombieAnimationDirection[i]);
    animation.AddFrame(TFrame.Create(28 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(29 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(30 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(31 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(32 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(33 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(34 + i *36,TPositionRecord.Create(0,0),0.11));
    animation.AddFrame(TFrame.Create(35 + i *36,TPositionRecord.Create(0,0),0.11));
  end;
end;

procedure TZombieController.MakeAnimation_selected();
var
  animation : TAnimation;
begin
  animation := fAnimationArchive.AddAnimation(ZombieAnimationSelected);
  animation.AddFrame(TFrame.Create(36 + 7 * 36,TPositionRecord.Create(0,0),0.11));
end;

procedure TZombieController.MakeAnimation_destination();
var
  animation : TAnimation;
begin
  animation := fAnimationArchive.AddAnimation(ZombieAnimationDestination);
  animation.AddFrame(TFrame.Create(37 + 7 * 36,TPositionRecord.Create(0,0),0.11));
end;

function TZombieController.PositionCollisionWithCharacter(aZombie: TZombieCharacter; aMapPosition, collisionPosition: TPositionRecord): Boolean;
var
  x,y : Integer;
begin
  x := aZombie.GetPosition().X - aMapPosition.X + (CHARACTER_WIDTH div 2);
  y := aZombie.GetPosition().Y - aMapPosition.Y + (CHARACTER_HEIGHT div 2);
  Result := (x - 20 < collisionPosition.X) and (collisionPosition.X < x + 20) and (y - 50 < collisionPosition.Y) and (collisionPosition.Y < y + 50);
end;

function TZombieController.RectangleCollisionWithCharacter(aZombie: TZombieCharacter; aMapPosition, aLeftTopPosition, aRightBottomPosition: TPositionRecord): Boolean;
var
  swap : Integer;
  x,y : Integer;
begin
  //Assure the corner positions are correct
  if(aLeftTopPosition.X > aRightBottomPosition.X) then
  begin
    swap := aLeftTopPosition.X;
    aLeftTopPosition.X := aRightBottomPosition.X;
    aRightBottomPosition.X := swap;
  end;
  if(aLeftTopPosition.Y > aRightBottomPosition.Y) then
  begin
    swap := aLeftTopPosition.Y;
    aLeftTopPosition.Y := aRightBottomPosition.Y;
    aRightBottomPosition.Y := swap;
  end;

  x := aZombie.GetPosition().X - aMapPosition.X + (CHARACTER_WIDTH div 2);
  y := aZombie.GetPosition().Y - aMapPosition.Y + (CHARACTER_HEIGHT div 2);
  Result := (x > aLeftTopPosition.X - 20) and ( x < aRightBottomPosition.X + 20) and (y > aLeftTopPosition.Y - 20) and ( y < aRightBottomPosition.Y + 20);
end;

constructor TZombieController.Create(aAnimationArchive: TAnimationArchive);
begin
  fAnimationArchive := aAnimationArchive;
  MakeAnimation_stance();
  MakeAnimation_lurch();
  MakeAnimation_slam();
  MakeAnimation_bite();
  MakeAnimation_block();
  MakeAnimation_hitndie();
  MakeAnimation_criticaldeath();
  MakeAnimation_selected();
  MakeAnimation_destination();
end;

destructor TZombieController.Destroy;
begin
  fAnimationArchive.Free();
end;

procedure TZombieController.DrawCharacter(aZombie: TZombieCharacter; aCanvas: TCanvas; aMapPosition: TPositionRecord);
var
  animationName : string;
  x,y : Integer;
begin
  animationName := ZombieAnimationAction[Ord(aZombie.GetAction())] + ZombieAnimationDirection[Ord(aZombie.GetDirection())];
  x := aZombie.GetPosition().X - aMapPosition.X;
  y := aZombie.GetPosition().Y - aMapPosition.Y;
  if(aZombie.GetSelected())then
  begin
    if(aZombie.GetState() = TZombieState.Ordered) then
      fAnimationArchive.DrawAnimation(ZombieAnimationDestination,aCanvas,aZombie.GetDestination().X - aMapPosition.X,aZombie.GetDestination().Y - aMapPosition.Y, aZombie.GetTotalElapsedSeconds());

    fAnimationArchive.DrawAnimation(ZombieAnimationSelected,aCanvas,x,y, aZombie.GetTotalElapsedSeconds());
  end;
  fAnimationArchive.DrawAnimation(animationName,aCanvas,x,y, aZombie.GetTotalElapsedSeconds());
end;

function TZombieController.GetAnimationArchive: TAnimationArchive;
begin
  Result := fAnimationArchive;
end;

end.
