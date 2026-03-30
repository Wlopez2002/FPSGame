extends Area3D

class_name HitBox

signal HitSignal(dam: int);

func _hit(damage: int):
	HitSignal.emit(damage);
