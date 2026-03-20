extends Node3D

class_name Level

@export var LevelName: String;
@export var LevelID: String;

func _ready() -> void:
	GameData.currentLevel = self
