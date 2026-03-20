extends Area3D

class_name HitBox

signal HitSignal();

@export var tiedEntity:EntityComponent;

func _hit(damage: int):
	HitSignal.emit();
	if tiedEntity != null:
		tiedEntity._damage(damage);
