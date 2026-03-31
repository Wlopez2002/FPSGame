extends CharacterBody3D

class_name MovingPlatform

@onready var timer = $PauseTimer;

@export var target: Vector3 = Vector3.ZERO;
@export var startingPos: Vector3;
@export var speed: float = 10.0;
@export var pauseTime = 1
@export var active = true
@export var oneShot = false

var goBack = false;
var paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if active:
		if paused:
			velocity = Vector3.ZERO
			return;
		if goBack:
			velocity = global_position.direction_to(startingPos).normalized() * speed
			if global_position.distance_to(startingPos) <= speed * delta:
				if !oneShot:
					timer.start(pauseTime);
					paused = true;
				else:
					active = false
				goBack = !goBack;
				
		else:
			velocity = global_position.direction_to(target).normalized() * speed
			if global_position.distance_to(target) <= speed * delta:
				if !oneShot:
					timer.start(pauseTime);
					paused = true;
				else:
					active = false
				goBack = !goBack;
	else:
		velocity = Vector3.ZERO
	move_and_slide()


func _on_pause_timer_timeout() -> void:
	paused = false;
	
func toggle():
	active = !active;
	paused = false;
	
func save():
	var saveDict = {
		"identifier": get_path(),
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"posX" : global_position.x,
		"posY" : global_position.y,
		"posZ" : global_position.z,
		"sposX" : startingPos.x,
		"sposY" : startingPos.y,
		"sposZ" : startingPos.z,
		"tposX" : target.x,
		"tposY" : target.y,
		"tposZ" : target.z,
		"goBack" : goBack,
		"active" : active,
		"pauseTime" : pauseTime,
		"pauseTimeLeft" : timer.time_left,
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
		"goBack":
			goBack = data;
		"active":
			active = data;
		"pauseTime":
			pauseTime = data;
		"pauseTimeLeft":
			if data > 0.0:
				timer.start(data);
				paused = true
