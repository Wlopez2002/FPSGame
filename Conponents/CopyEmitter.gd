extends Node3D

@onready var timer = $Timer;

@export var toCopy: Node3D;
@export var spawnLocation: Vector3; ## Global
@export var parent: Node;
@export var time: float = 0.0;
@export var emitterMax = 10;
var emitterCount = 0;

func emit():
	if emitterCount >= emitterMax:
		return;
	
	emitterCount = emitterCount + 1;
	var newScene = toCopy.duplicate()
	print(newScene)
	if parent != null:
		parent.add_child(newScene)
	else:
		get_parent().add_child(newScene)
	if newScene is Node3D:
		newScene.global_position = spawnLocation
	if time != 0.0:
		timer.start(time)
	print(emitterCount)


func _on_timer_timeout() -> void:
	emit();
