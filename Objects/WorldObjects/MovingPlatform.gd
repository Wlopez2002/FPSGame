extends AnimatableBody3D

@export var target: Vector3 = Vector3.ZERO;
@export var startingPos: Vector3;
@export var speed: float = 10.0;

var goBack = false;

##
## Work in progress, do not use
##

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass;
	#if goBack:
		#global_position += (startingPos - target).normalized() * speed * delta
		#if (global_position - startingPos).length() <= speed * delta:
			#goBack = false
	#else:
	#global_position += (target - startingPos).normalized() * speed  * delta
		#if (global_position - target).length() <= speed * delta:
			#goBack = true

func save():
	var saveDict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"posX" : position.x,
		"posY" : position.y,
		"posZ" : position.z,
		"sposX" : startingPos.x,
		"sposY" : startingPos.y,
		"sposZ" : startingPos.z,
		"tposX" : target.x,
		"tposY" : target.y,
		"tposZ" : target.z,
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
