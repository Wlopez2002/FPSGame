extends Area3D

class_name InteractComponent

signal interacted();

@export var interactionName: String;

func interact():
	interacted.emit();
