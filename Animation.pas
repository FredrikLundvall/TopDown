unit Animation;

interface
uses
  Frame,
  Contnrs,
  PositionRecord;

type
  TAnimation = class
    fFramesTotalSeconds : Double;
    fFrames : TObjectList;
    constructor Create();
    destructor Destroy();
    procedure AddFrame(aFrame : TFrame);
    function GetCurrentFrame(totalElapsedSeconds : double) : TFrame;
  end;

implementation

procedure TAnimation.AddFrame(aFrame: TFrame);
begin
  fFrames.Add(aFrame);
  fFramesTotalSeconds := fFramesTotalSeconds + aFrame.GetLengthSeconds();
end;

constructor TAnimation.Create;
begin
  fFrames := TObjectList.Create();
  fFramesTotalSeconds := 0;
end;

destructor TAnimation.Destroy;
begin
  fFrames.Free();
end;

function TAnimation.GetCurrentFrame(totalElapsedSeconds : double): TFrame;
var
  i : Integer;
  sumFrameSecondsStart : Double;
  sumFrameSecondsEnd : Double;
  modElapsedSeconds : Double;
  function Modulus(x,y : double) : Double;
  begin
    result := x - int(x/y) * y;
  end;
begin
//  if fElapsedSeconds > fFramesTotalSeconds then
//    fElapsedSeconds := fElapsedSeconds - fFramesTotalSeconds;
  modElapsedSeconds := Modulus(totalElapsedSeconds, fFramesTotalSeconds);
  sumFrameSecondsStart := 0;
  sumFrameSecondsEnd := 0;
  for i := 0 to Pred(fFrames.Count) do
  begin
    sumFrameSecondsStart := sumFrameSecondsEnd;
    sumFrameSecondsEnd := sumFrameSecondsEnd + (fFrames[i] as TFrame).GetLengthSeconds();
    if(modElapsedSeconds >= sumFrameSecondsStart) and (modElapsedSeconds < sumFrameSecondsEnd) then
    begin
      Result := fFrames[i] as TFrame;
      Break;
    end;
  end;
end;

end.
