unit Frame;

interface
uses
  PositionRecord;

type
  TFrame = class
  protected
    fImageIndex : Integer;
    fOffset : TPositionRecord;
    fLengthSeconds : Double;
  public
    constructor Create(aImageIndex : Integer; aOffset : TPositionRecord; aLengthSeconds : Double);
    function GetLengthSeconds() : Double;
    function GetOffset() : TPositionRecord;
    function GetImageIndex() : Integer;
  end;

implementation

constructor TFrame.Create(aImageIndex: Integer; aOffset: TPositionRecord; aLengthSeconds: Double);
begin
  fImageIndex := aImageIndex;
  fOffset := aOffset;
  fLengthSeconds := aLengthSeconds;
end;

function TFrame.GetImageIndex: Integer;
begin
  Result := fImageIndex;
end;

function TFrame.GetLengthSeconds: Double;
begin
  Result := fLengthSeconds;
end;

function TFrame.GetOffset: TPositionRecord;
begin
  Result := fOffset;
end;

end.

