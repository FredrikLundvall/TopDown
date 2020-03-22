unit ZombieAction;

interface
type
{$SCOPEDENUMS ON}
TZombieAction = (Stance = 0, Lurch, Slam, Bite, Block, Hitndie, Criticaldeath);
{$SCOPEDENUMS OFF}

const
  ZombieAnimationAction : array[0..6] of string =
  (
    'stance', 'lurch', 'slam', 'bite',
    'block', 'hitndie', 'criticaldeath'
  ) ;
  ZombieAnimationSelected = 'selected';
  ZombieAnimationDestination = 'destination';

implementation

end.
