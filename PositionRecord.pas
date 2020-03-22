unit PositionRecord;

interface

type
  TPositionRecord = record
  private
    fFractionalX : double;
    fFractionalY : double;

  public
    X : integer;
    Y : integer;
    procedure ClearFraction();
    procedure AddFraction(aX : double; aY : double);
    class function Create(aX : Integer; aY : Integer) : TPositionRecord; static;
    function Distance(destination : TPositionRecord) : Double;
    function DestinationReached(destination : TPositionRecord; limit : Integer = 25) : Boolean;
  end;

implementation

{ TPositionRecord }

procedure TPositionRecord.ClearFraction;
begin
  fFractionalX := 0;
  fFractionalY := 0;
end;

class function TPositionRecord.Create(aX, aY: Integer): TPositionRecord;
begin
  Result.X := aX;
  Result.Y := aY;
  Result.fFractionalX := 0;
  Result.fFractionalY := 0;
end;

function TPositionRecord.DestinationReached(destination: TPositionRecord; limit : Integer): Boolean;
begin
  Result := (Distance(destination) < limit);
end;

function TPositionRecord.Distance(destination: TPositionRecord): Double;
begin
  Result := Sqrt( Sqr(destination.X - X) + Sqr(destination.Y - Y));
end;

procedure TPositionRecord.AddFraction(aX : double; aY : double);
var
  truncX : integer;
  truncY : integer;
begin
  fFractionalX := fFractionalX + aX;
  truncX := Trunc(fFractionalX);
  X := X + truncX;
  fFractionalX := fFractionalX - truncX;

  fFractionalY := fFractionalY + aY;
  truncY := Trunc(fFractionalY);
  Y := Y + truncY;
  fFractionalY := fFractionalY - truncY;
end;

end.
