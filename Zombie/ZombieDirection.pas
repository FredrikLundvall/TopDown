unit ZombieDirection;

interface
uses
  Math,
  PositionRecord;

type
TVectorRecord = record
  X : Double;
  Y : Double;
  procedure Normalize();
  function Distance(destination : TVectorRecord) : Double;
end;

{$SCOPEDENUMS ON}
TZombieDirection = (DownLeft = 0, Left, UpLeft, Up, UpRight, Right, DownRight, Down);
{$SCOPEDENUMS OFF}

function RotateZombieDirectionClockwise(direction : TZombieDirection; step : Integer = 1) : TZombieDirection;
function RotateZombieDirectionAntiClockwise(direction : TZombieDirection; step : Integer = 1) : TZombieDirection;
function RotateZombieDirectionTowardsDestination(direction : TZombieDirection; position : TPositionRecord; destination : TPositionRecord) : TZombieDirection;
function CountZombieDirectionClockwiseSteps(direction : TZombieDirection; destination : TZombieDirection) : Integer;
function CountZombieDirectionAntiClockwiseSteps(direction : TZombieDirection; destination : TZombieDirection) : Integer;

const
  ZombieAnimationDirection : array[0..7] of string =
  (
    '_down_left', '_left', '_up_left', '_up','_up_right', '_right', '_down_right', '_down'
  ) ;

const
  ZombieVectorDirection : array[0..7] of TVectorRecord =
  (
    (X : -0.70710678118654752440084436210485; Y : 0.70710678118654752440084436210485),(X : -1; Y : 0),(X : -0.70710678118654752440084436210485; Y : -0.70710678118654752440084436210485),(X : 0; Y : -1),
    (X : 0.70710678118654752440084436210485; Y : -0.70710678118654752440084436210485),(X : 1; Y : 0),(X : 0.70710678118654752440084436210485; Y : 0.70710678118654752440084436210485),(X : 0; Y : 1)
  ) ;
implementation

function RotateZombieDirectionClockwise(direction : TZombieDirection; step : Integer = 1) : TZombieDirection;
var
  directionInt : Integer;
begin
  directionInt := Ord(direction);
  directionInt := directionInt + step;
  if directionInt > 7 then
    directionInt := directionInt - 8;
  result := TZombieDirection(directionInt);
end;

function RotateZombieDirectionAntiClockwise(direction : TZombieDirection; step : Integer = 1) : TZombieDirection;
var
  directionInt : Integer;
begin
  directionInt := Ord(direction);
  directionInt := directionInt - step;
  if directionInt < 0 then
    directionInt := directionInt + 8;
  result := TZombieDirection(directionInt);
end;

function RotateZombieDirectionTowardsDestination(direction : TZombieDirection; position, destination : TPositionRecord) : TZombieDirection;
var
  wantedDirectionVect : TVectorRecord;
  i : Integer;
  lowestDistance, curDistance : Double;
  bestDirection : TZombieDirection;
  countClockwise, countAntiClockwise : Integer;
begin
  wantedDirectionVect.X := destination.X - position.X;
  wantedDirectionVect.Y := destination.Y - position.Y;
  //Normalize (length recalculated to 1)
  wantedDirectionVect.Normalize();

  //Compare to the existing directions
  lowestDistance := 3;
  bestDirection := direction;
  for i := 0 to 7 do
  begin
    curDistance := ZombieVectorDirection[i].Distance(wantedDirectionVect);
    if curDistance < lowestDistance then
    begin
      lowestDistance := curDistance;
      bestDirection := TZombieDirection(i);
    end;
  end;

  if bestDirection = direction then
  begin
    Result := bestDirection;
    Exit;
  end;

  //Turn clockwise or anticlockwise?
  countClockwise := CountZombieDirectionClockwiseSteps(direction,bestDirection);
  countAntiClockwise := CountZombieDirectionAntiClockwiseSteps(direction,bestDirection);
  if(countClockwise < countAntiClockwise) then
    result := RotateZombieDirectionClockwise(direction)
  else if(countAntiClockwise < countClockwise) then
    result := RotateZombieDirectionAntiClockwise(direction)
  else
  begin
    if(RandomRange(0,2) = 1) then
      result := RotateZombieDirectionClockwise(direction)
    else
      result := RotateZombieDirectionAntiClockwise(direction);
  end;

end;

function CountZombieDirectionClockwiseSteps(direction : TZombieDirection; destination : TZombieDirection) : Integer;
var
  directionInt, destinationInt : Integer;
begin
  if(destinationInt >= directionInt) then
    Result := destinationInt - directionInt
  else
    Result := 8 + destinationInt - directionInt;
end;

function CountZombieDirectionAntiClockwiseSteps(direction : TZombieDirection; destination : TZombieDirection) : Integer;
var
  directionInt, destinationInt : Integer;
begin
  if(destinationInt <= directionInt) then
    Result := directionInt - destinationInt
  else
    Result := 8 + directionInt - destinationInt;
end;

{ TVectorRecord }

function TVectorRecord.Distance(destination: TVectorRecord): Double;
begin
  Result := Sqrt( Sqr(destination.X - X) + Sqr(destination.Y - Y));
end;

procedure TVectorRecord.Normalize;
var
  vectLength : Double;
begin
  vectLength := Sqrt( Sqr(X) + Sqr(Y));
  if vectLength <> 0 then
  begin
    X := X / vectLength;
    Y := Y / vectLength;
  end;
end;

end.
