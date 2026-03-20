extends Area3D

class_name LevelGate

@export var toLevel: PackedScene;

func _on_area_entered(_area: Area3D) -> void:
	GameData.call_deferred("changeLevel", toLevel)
	#GameData.changeLevel(toLevel)
