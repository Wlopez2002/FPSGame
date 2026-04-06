extends Pickip

@export var amount: int = 10;

func _on_area_entered(area: Area3D) -> void:
	amount = area.collectHealth(amount);
	if amount == 0:
		queue_free();

func save():
	var saveDict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"posX" : position.x,
		"posY" : position.y,
		"posZ" : position.z,
		"amount" : amount
	}
	return saveDict
func loadMe(key: StringName, data) -> void:
	match key:
		"amount":
			amount = data;
