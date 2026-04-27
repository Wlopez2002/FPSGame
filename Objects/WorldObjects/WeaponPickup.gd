extends Pickup

@export var weaponPath: String

func _on_area_entered(area: Area3D) -> void:
	if area is HitBox:
		area._addWeapon(weaponPath);
	queue_free()

func save():
	var saveDict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"posX" : position.x,
		"posY" : position.y,
		"posZ" : position.z,
		"weaponPath" : weaponPath
	}
	return saveDict
func loadMe(key: StringName, data) -> void:
	match key:
		"weaponPath":
			weaponPath = data;
