extends Node3D

@onready var interactRay = $InteractRay
@onready var interactionLabel = $InteractionLabel;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("INTERACT"):
		if interactRay.is_colliding() and interactRay.get_collider() is InteractComponent:
			interactRay.get_collider().interact();

func _process(delta: float) -> void:
	if interactRay.is_colliding() and interactRay.get_collider() is InteractComponent:
		interactionLabel.visible = true;
	else:
		interactionLabel.visible = false;
