extends Projectile

@export var damage: int;

func _on_hit_range_area_entered(area: Area3D) -> void:
	if activateTimer <= 0:
		if area is HitBox:
			area._hit(damage)
			queue_free()

func _on_hit_range_body_entered(_body: Node3D) -> void:
	if activateTimer <= 0:
		queue_free()


func save():
	var saveDict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"posX" : position.x,
		"posY" : position.y,
		"posZ" : position.z,
		"dX" : direction.x,
		"dY" : direction.y,
		"dZ" : direction.z,
		"speed" : speed,
		"damage" : damage
	}
	return saveDict
func loadMe(key: StringName, data) -> void:
	match key:
		"speed":
			speed = data;
		"damage":
			damage = data;
		"dX":
			direction.x  = data;
		"dY":
			direction.y  = data;
		"dZ":
			direction.z  = data;
