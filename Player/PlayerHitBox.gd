extends HitBox

@export var playerWeapons: PlayerWeapon;
@export var playerEntity: EntityComponent;

func collectAmmo(type: WeaponBase.AMMOTYPE, amount: int) -> int:
	return playerWeapons._addAmmo(type, amount);

func collectHealth(amount: int) -> int:
	return playerEntity.heal(amount)
