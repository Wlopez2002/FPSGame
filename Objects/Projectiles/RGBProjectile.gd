extends RigidBody3D

class_name Projectile

@export var direction: Vector3;
@export var speed: float = 20.0;
@export var liveTime: float = 10.0;
@export var activateTimer: float = 1.0;

var needApplyInpulse = true;

func _physics_process(delta: float) -> void:
	if needApplyInpulse:
		apply_central_impulse(direction * speed)
		needApplyInpulse = false;
	liveTime -= delta
	if liveTime <= 0:
		endLiveTime()
	if activateTimer > 0:
		activateTimer -= delta;

func endLiveTime():
	queue_free();

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
		"speed" : speed
	}
	return saveDict
func loadMe(key: StringName, data) -> void:
	match key:
		"speed":
			speed = data;
		"dX":
			direction.x  = data;
		"dY":
			direction.y  = data;
		"dZ":
			direction.z  = data;
