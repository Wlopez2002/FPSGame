extends Area3D

@export var damage: int;
@export var force: float;

func _explode():
	for area in get_overlapping_areas():
		if area is HitBox:
			area._hit(damage);
	for body in get_overlapping_bodies():
		if body is PlayerBody:
			var vect = (body.global_position - global_position).normalized() * force;
			body._applyForce(vect)
		elif body is CharacterBody3D:
			body.velocity += (body.global_position - global_position).normalized() * force;
