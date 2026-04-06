extends Node3D

@export var scene: PackedScene;
@export var spawnLocation: Vector3; ## Global
@export var parent: Node;

func emit():
	var newScene = scene.instantiate();
	if parent != null:
		parent.add_child(newScene)
	else:
		get_parent().add_child(newScene)
	if newScene is Node3D:
		newScene.global_position = spawnLocation
