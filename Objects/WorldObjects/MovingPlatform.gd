extends Node3D

@export var target: Vector3 = Vector3.ZERO;
@export var startingPos: Vector3;
@export var speed: float = 10.0;
@export var platform: AnimatableBody3D

var goBack = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if goBack:
		platform.global_position += (startingPos - target).normalized() * speed * delta
		global_position += (startingPos - target).normalized() * speed * delta
		if (global_position - startingPos).length() <= speed * delta:
			goBack = false
	else:
		platform.global_position += (target - startingPos).normalized() * speed  * delta
		global_position += (target - startingPos).normalized() * speed  * delta
		if (global_position - target).length() <= speed * delta:
			goBack = true

func save():
	var saveDict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"posX" : platform.global_position.x,
		"posY" : platform.global_position.y,
		"posZ" : platform.global_position.z,
		"sposX" : startingPos.x,
		"sposY" : startingPos.y,
		"sposZ" : startingPos.z,
		"tposX" : target.x,
		"tposY" : target.y,
		"tposZ" : target.z,
		"goBack" : goBack,
		"tiedBody" : platform.get_path()
	}
	return saveDict
func loadMe(key: StringName, data) -> void:
	match key:
		"sposX": 
			startingPos.x = data
		"sposY":
			startingPos.y = data
		"sposZ":
			startingPos.z = data
		"tposX":
			target.x = data
		"tposY":
			target.y = data
		"tposZ":
			target.z = data
		"goBack" :
			goBack = data;
		"tiedBody":
			platform = get_node(data)
			platform.global_position = global_position
