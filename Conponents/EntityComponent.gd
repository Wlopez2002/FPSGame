extends Node3D

class_name EntityComponent

signal killed();
signal hit();

@export var health: int = 10;
@export var maxHealth: int = 10;
@export var nodeToFreeOnKill: Node;

func _damage(num: int):
	if health <= 0:
		return;
	health -= num;
	hit.emit();
	if health <= 0:
		killMe();

func heal(num: int) -> int:
	health += num;
	if health > maxHealth:
		var remain = health - maxHealth;
		health = maxHealth;
		return remain;
	else:
		return 0;

func killMe():
	if GameData.debugInfo:
		if nodeToFreeOnKill == null:
			print("Debug: Entity killed")
		else:
			print("Debug: Entity killed, freeing " + str(nodeToFreeOnKill))
	
	health = 0;
	killed.emit();
	if nodeToFreeOnKill != null:
		nodeToFreeOnKill.call_deferred("queue_free")
