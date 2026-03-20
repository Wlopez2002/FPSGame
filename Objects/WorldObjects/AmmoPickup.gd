extends Area3D

@export var type: WeaponBase.AMMOTYPE;
@export var amount: int = 10;

func _on_area_entered(area: Area3D) -> void:
	amount = area.collectAmmo(type, amount);
	if amount == 0:
		queue_free();

func save():
	var saveDict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"posX" : position.x,
		"posY" : position.y,
		"posZ" : position.z,
		"type" : type,
		"amount" : amount
	}
	return saveDict
func loadMe(key: StringName, data) -> void:
	match key:
		"type":
			type = data;
		"amount":
			amount = data;
