extends Node3D

@onready var timer = $Timer;

@export var toCopy: Node3D;
@export var spawnLocation: Vector3; ## Global
@export var spawnParent: Node;
@export var time: float = 0.0;
@export var emitterMax = 10;
var emitterCount = 0;

func emit():
	if emitterCount >= emitterMax:
		return;
	
	emitterCount = emitterCount + 1;
	var newScene = toCopy.duplicate()
	newScene.remove_from_group("PersistentNSL")
	if spawnParent != null:
		spawnParent.add_child(newScene)
	else:
		get_parent().add_child(newScene)
	if newScene is Node3D:
		newScene.global_position = spawnLocation
	if time != 0.0:
		timer.start(time)

func _on_timer_timeout() -> void:
	emit();

func save():
	var saveDict = {
		"identifier": get_path(),
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"posX" : position.x,
		"posY" : position.y,
		"posZ" : position.z,
		"emitterMax" : emitterMax,
		"emitterCount" : emitterCount,
		"toCopy" : toCopy.get_path(),
		"spawnParent" : spawnParent.get_path(),
		"time" : time,
		"spawnX" : spawnLocation.x,
		"spawnY" : spawnLocation.y,
		"spawnZ" : spawnLocation.z,
	}
	return saveDict
func loadMe(key: StringName, data) -> void:
	match key:
		"emitterMax":
			emitterMax = data
		"emitterCount":
			emitterCount = data;
		"toCopy":
			toCopy = get_node(data)
		"spawnParent":
			spawnParent = get_node(data)
		"time":
			time = data
		"spawnX": 
			spawnLocation.x = data
		"spawnY": 
			spawnLocation.y = data
		"spawnZ": 
			spawnLocation.z = data
