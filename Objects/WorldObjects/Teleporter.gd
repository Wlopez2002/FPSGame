extends Node3D

class_name Teleporter

@onready var teleArea = $Area3D;
@onready var teleportPlayer: AudioStreamPlayer3D = $TeleportPlayer;

## A teleporter may have a destination teleporter that
## has a different destination
@export var dest: Teleporter;
@export var movingTeleporter = false;
var teleportedTo = false;
var assumedVelocity: Vector3 = Vector3.ZERO;
var lastPosition: Vector3;

func _on_area_3d_body_entered(body: Node3D) -> void:
	if teleportedTo or !(body is PlayerBody):
		return;
	var player: PlayerBody = body;
	var newPos = (player.global_position - global_position) + dest.global_position;
	player._smoothTeleport(newPos, transform.basis.z, dest.transform.basis.z, assumedVelocity);
	dest.teleportedTo = true;
	dest.teleportPlayer.play();

func _ready() -> void:
	lastPosition = global_position;

func _physics_process(delta: float) -> void:
	if movingTeleporter:
		assumedVelocity = global_position - lastPosition;
		lastPosition = global_position
		assumedVelocity = assumedVelocity/delta
		
	if teleportedTo == true:
		var player: PlayerBody = get_tree().get_first_node_in_group("Player");
		if player.global_position.distance_to(global_position) > 1.75:
			teleportedTo = false;
