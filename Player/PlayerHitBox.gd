extends HitBox

@export var playerWeapons: PlayerWeapon;

func collectAmmo(type: WeaponBase.AMMOTYPE, amount: int) -> int:
	return playerWeapons._addAmmo(type, amount);

func collectHealth(amount: int) -> int:
	return tiedEntity.heal(amount)
