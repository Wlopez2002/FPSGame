extends HitBox

class_name InteractComponent

signal interacted();

@export var interactionName: String;
@export var hitable = true;

func interact():
	print("interacted")
	interacted.emit();

func _hit(damage: int):
	if hitable:
		interact();
