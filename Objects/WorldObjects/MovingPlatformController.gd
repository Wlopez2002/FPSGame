extends Node3D

@onready var timer = $PauseTimer;

@export var target: Vector3 = Vector3.ZERO;
@export var startingPos: Vector3;
@export var speed: float = 10.0;
@export var platform: CharacterBody3D
@export var pauseTime = 1
@export var active = true
@export var oneShot = false

var goBack = false;
var paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if active:
		if paused:
			platform.velocity = Vector3.ZERO
			return;
		if goBack:
			platform.velocity = (startingPos - target).normalized() * speed
			if (platform.global_position - startingPos).length() <= speed * delta:
				if !oneShot:
					timer.start(pauseTime);
				goBack = !goBack;
				paused = true;
		else:
			platform.velocity = (target - startingPos).normalized() * speed
			if (platform.global_position - target).length() <= speed * delta:
				if !oneShot:
					timer.start(pauseTime);
				goBack = !goBack;
				paused = true;
	else:
		platform.velocity = Vector3.ZERO

func _on_pause_timer_timeout() -> void:
	paused = false;
	
func toggle():
	print(active)
	active = !active;
	paused = false;
	
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
		"active" : active,
		"pauseTime" : pauseTime,
		"pauseTimeLeft" : timer.time_left,
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
		"tiedBody":
			platform = get_node(data)
			platform.global_position = global_position
