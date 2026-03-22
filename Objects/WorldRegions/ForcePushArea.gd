extends Area3D

@export var acceleration: Vector3;

func _physics_process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is PlayerBody:
			body._applyForce(acceleration)
		elif body is CharacterBody3D:
			body.velocity += acceleration;
