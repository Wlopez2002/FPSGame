extends CharacterBody3D

class_name MovingPlatformBody

func _physics_process(_delta: float) -> void:
	move_and_slide()
