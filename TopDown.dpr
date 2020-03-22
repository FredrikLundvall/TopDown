program TopDown;

uses
  Forms,
  Main in 'Main.pas' {TopDownMainFrm},
  PositionRecord in 'PositionRecord.pas',
  TileMap in 'TileMap.pas',
  SizeRecord in 'SizeRecord.pas',
  AnimationArchive in 'AnimationArchive.pas',
  Animation in 'Animation.pas',
  Frame in 'Frame.pas',
  PngFunctions in 'Utils\PngFunctions.pas',
  PngImageList in 'Utils\PngImageList.pas',
  StopWatch in 'Utils\StopWatch.pas',
  ZombieAction in 'Zombie\ZombieAction.pas',
  ZombieCharacter in 'Zombie\ZombieCharacter.pas',
  ZombieController in 'Zombie\ZombieController.pas',
  ZombieDirection in 'Zombie\ZombieDirection.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTopDownMainFrm, TopDownMainFrm);
  Application.Run;
end.
