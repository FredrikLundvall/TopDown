unit ZombieCharacter;

interface
uses
  SysUtils,
  Math,
  MMsystem,
  PositionRecord,
  ZombieAction,
  ZombieDirection;

type
{$SCOPEDENUMS ON}
TZombieState = (Calm = 0, Alerted, Angry, Ordered);
{$SCOPEDENUMS OFF}

TZombieCharacter = class
protected
  fStateCheckEveryElapsedSeconds : Double;
  fSensesCheckEveryElapsedSeconds : Double;
  fPosition : TPositionRecord;
  fDirection : TZombieDirection;
  fState : TZombieState;
  fAction : TZombieAction;
  fElapsedSeconds : Double;
  fTotalElapsedSeconds : Double;
  fTotalElapsedSecondsLastStateCheck : Double;
  fTotalElapsedSecondsLastSensesCheck : Double;
  fSelected : Boolean;
  fDestination : TPositionRecord;
  fLastDistanceToDestination : Double;
  fStateAtDestination : TZombieState;
public
  constructor Create(aPosition : TPositionRecord; aDirection : TZombieDirection = TZombieDirection.Right; aState : TZombieState = TZombieState.Calm; aStateCheckEveryElapsedSeconds : double = 1.3; aSensesCheckEveryElapsedSeconds : double = 0.1);
  function GetPosition() : TPositionRecord;
  function GetDirection() : TZombieDirection;
  function GetState() : TZombieState;
  function GetAction() : TZombieAction;
  procedure AddElapsedSeconds(aElapsedSeconds : double);
  procedure SensesCheck(); //Kollar reaktioner på syn och hörsel
  procedure StateCheck(); //Styr beteende
  function GetTotalElapsedSeconds() : double;
  function GetSelected() : Boolean;
  procedure SetSelected(aSelected : Boolean);
  function GetDestination() : TPositionRecord;
  procedure SetDestination(aDestination : TPositionRecord);
  procedure SetState(aState : TZombieState);
  procedure SetStateAtDestination(aState : TZombieState);
end;

function RandomRangeF(min, max : double):double;

implementation

function RandomRangeF(min, max : double):double;
var
  float : double;
begin
  float := Random;
  result := min + float * (max-min);
end;

{ TZombieCharacter }

constructor TZombieCharacter.Create(aPosition : TPositionRecord; aDirection : TZombieDirection; aState : TZombieState; aStateCheckEveryElapsedSeconds : double; aSensesCheckEveryElapsedSeconds : double);
begin
  fPosition := aPosition;
  fDirection := aDirection;
  fState := aState;
  fAction := TZombieAction.Stance;
  fElapsedSeconds := 0;
  fTotalElapsedSeconds := 0;
  fTotalElapsedSecondsLastStateCheck := RandomRangeF(0.0,aStateCheckEveryElapsedSeconds);
  fTotalElapsedSecondsLastSensesCheck :=RandomRangeF(0.0,aSensesCheckEveryElapsedSeconds);
  fStateCheckEveryElapsedSeconds := aStateCheckEveryElapsedSeconds;
  fSensesCheckEveryElapsedSeconds := aSensesCheckEveryElapsedSeconds;
  fSelected := False;

  AddElapsedSeconds(RandomRangeF(0.0,aStateCheckEveryElapsedSeconds));
end;

function TZombieCharacter.GetPosition: TPositionRecord;
begin
  Result := fPosition;
end;

function TZombieCharacter.GetAction: TZombieAction;
begin
  Result := fAction;
end;

function TZombieCharacter.GetDestination: TPositionRecord;
begin
  Result := fDestination;
end;

function TZombieCharacter.GetDirection() : TZombieDirection;
begin
  Result := fDirection;
end;

function TZombieCharacter.GetSelected: Boolean;
begin
  Result := fSelected;
end;

function TZombieCharacter.GetState: TZombieState;
begin
  Result := fState;
end;

function TZombieCharacter.GetTotalElapsedSeconds: double;
begin
  Result := fTotalElapsedSeconds;
end;

procedure TZombieCharacter.AddElapsedSeconds(aElapsedSeconds: double);
begin
  fElapsedSeconds := aElapsedSeconds;
  fTotalElapsedSeconds := fTotalElapsedSeconds + aElapsedSeconds;

  if (fTotalElapsedSeconds - fTotalElapsedSecondsLastSensesCheck) >= (fSensesCheckEveryElapsedSeconds + RandomRangeF(0.0,0.3)) then
    SensesCheck();

  if (fTotalElapsedSeconds - fTotalElapsedSecondsLastStateCheck) >= (fStateCheckEveryElapsedSeconds + RandomRangeF(0.0,1.5)) then
    StateCheck();

  if(fAction = TZombieAction.Lurch) then
    fPosition.AddFraction( ZombieVectorDirection[Ord(fDirection)].X * 27.0 * aElapsedSeconds,ZombieVectorDirection[Ord(fDirection)].Y * 27.0 * aElapsedSeconds);
end;

procedure TZombieCharacter.SensesCheck();
var
  sensesNeedStateCheck : Boolean;
begin
  fTotalElapsedSecondsLastSensesCheck := fTotalElapsedSeconds;
  sensesNeedStateCheck := False;

  if sensesNeedStateCheck then
    fTotalElapsedSecondsLastStateCheck := 0;//Triggers StateCheck
end;

procedure TZombieCharacter.SetDestination(aDestination: TPositionRecord);
begin
  fDestination := aDestination;
end;

procedure TZombieCharacter.SetSelected(aSelected: Boolean);
begin
  fSelected := aSelected;
end;

procedure TZombieCharacter.SetState(aState: TZombieState);
begin
  fState := aState;
end;

procedure TZombieCharacter.SetStateAtDestination(aState: TZombieState);
begin
  fStateAtDestination := aState;
end;

procedure TZombieCharacter.StateCheck();
var
  rand : Integer;
  distance : Double;
begin
  fTotalElapsedSecondsLastStateCheck := fTotalElapsedSeconds;

  if fState = TZombieState.Calm then
  begin
    rand := RandomRange(0,101);
    if rand < 17 then
      fState := TZombieState.Alerted;

    //Action check
    if RandomRange(0,101) < 7 then
    begin
      if(RandomRange(0,2) = 1) then
        fDirection := RotateZombieDirectionClockwise(fDirection)
      else
        fDirection := RotateZombieDirectionAntiClockwise(fDirection);
    end;

    if fAction = TZombieAction.Stance then
    begin
      if RandomRange(0,101) < 7 then
        fAction := TZombieAction.Lurch;
    end
    else if fAction = TZombieAction.Lurch then
    begin
      if RandomRange(0,101) < 85 then
        fAction := TZombieAction.Stance;
    end
    else
    begin
      rand := RandomRange(0,101);
      if rand < 87 then
        fAction := TZombieAction.Stance;
    end;
  end
  else if fState = TZombieState.Alerted then
  begin
    rand := RandomRange(0,101);
    if rand < 17 then
      fState := TZombieState.Calm;
    if rand < 24 then
      fState := TZombieState.Angry;

    //Action check
    if RandomRange(0,101) < 14 then
    begin
      if(RandomRange(0,2) = 1) then
        fDirection := RotateZombieDirectionClockwise(fDirection)
      else
        fDirection := RotateZombieDirectionAntiClockwise(fDirection);
    end;

    if fAction = TZombieAction.Stance then
    begin
      rand := RandomRange(0,101);
      if rand < 14 then
        fAction := TZombieAction.Lurch
      else if rand < 21 then
        fAction := TZombieAction.Block;
    end
    else if fAction = TZombieAction.Lurch then
    begin
      rand := RandomRange(0,101);
      if rand < 67 then
        fAction := TZombieAction.Stance
      else if rand < 87 then
        fAction := TZombieAction.Block;
    end
    else
    begin
      rand := RandomRange(0,101);
      if rand < 67 then
        fAction := TZombieAction.Stance;
    end;
  end
  else if fState = TZombieState.Angry then
  begin
    rand := RandomRange(0,101);
    if rand < 17 then
      fState := TZombieState.Alerted;

    //Action check
    if RandomRange(0,101) < 35 then
    begin
      if(RandomRange(0,2) = 1) then
        fDirection := RotateZombieDirectionClockwise(fDirection)
      else
        fDirection := RotateZombieDirectionAntiClockwise(fDirection);
    end;

    if fAction = TZombieAction.Stance then
    begin
      rand := RandomRange(0,101);
      if rand < 77 then
        fAction := TZombieAction.Block
      else if rand < 90 then
        fAction := TZombieAction.Bite;
    end
    else if fAction = TZombieAction.Bite then
    begin
      rand := RandomRange(0,101);
      if rand < 57 then
        fAction := TZombieAction.Slam
      else if rand < 77 then
        fAction := TZombieAction.Block
      else
      begin
        if rand < 80 then
          if FileExists('.\Characters\Zombie\growl.wav') then
            PlaySound(pchar('.\Characters\Zombie\growl.wav'), 0, SND_ASYNC or SND_FILENAME);
      end;
    end
    else if fAction = TZombieAction.Slam then
    begin
      rand := RandomRange(0,101);
      if rand < 55 then
        fAction := TZombieAction.Stance
      else if rand < 77 then
        fAction := TZombieAction.Lurch
      else
      begin
        if rand < 80 then
          if FileExists('.\Characters\Zombie\growl.wav') then
            PlaySound(pchar('.\Characters\Zombie\growl.wav'), 0, SND_ASYNC or SND_FILENAME);
      end;
    end
    else
    begin
      rand := RandomRange(0,101);
      if rand < 67 then
        fAction := TZombieAction.Stance;
    end;
  end
  else if fState = TZombieState.Ordered then
  begin
    fDirection := RotateZombieDirectionTowardsDestination(fDirection,fPosition,fDestination);
    fAction := TZombieAction.Lurch;
    if (fPosition.DestinationReached(fDestination,55)) then
    begin
      fState := fStateAtDestination;
      if fState = TZombieState.Angry then
        fAction := TZombieAction.Slam
      else
        fAction := TZombieAction.Stance
    end;
  end;

end;
end.
