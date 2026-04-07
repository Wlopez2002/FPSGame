extends HitBox

@export var playerWeapons: PlayerWeapon;
@export var playerEntity: EntityComponent;

func collectAmmo(type: WeaponBase.AMMOTYPE, amount: int) -> int:
	return playerWeapons._addAmmo(type, amount);

func collectHealth(amount: int) -> int:
	return playerEntity.heal(amount)

func _on_crush_detector_body_entered(body: Node3D) -> void:
	playerEntity.killMe();
