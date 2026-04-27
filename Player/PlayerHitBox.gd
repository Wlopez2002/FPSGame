extends HitBox

@export var playerWeapons: PlayerWeapon;
@export var playerEntity: EntityComponent;

func collectAmmo(type: WeaponBase.AMMOTYPE, amount: int) -> int:
	return playerWeapons._addAmmo(type, amount);

func collectHealth(amount: int) -> int:
	return playerEntity.heal(amount)

func _hit(damage: int):
	if !GameData.godMode:
		HitSignal.emit(damage);

func _on_crush_detector_body_entered(_body: Node3D) -> void:
	if !GameData.godMode:
		playerEntity.killMe();

func _addWeapon(path: String):
	playerWeapons._addWeapon(path);
