extends HitBox

class_name InteractComponent

signal interacted();

@export var interactionName: String;
@export var hitable = true;
@export var oneShot = false;
var wasInteracted = false;

func interact():
	print("interacted")
	if oneShot:
		if !wasInteracted:
			interacted.emit();
			wasInteracted = true;
	else:
		interacted.emit();

func _hit(damage: int):
	if hitable:
		HitSignal.emit(damage)
		interact();
