extends Node3D

@onready var explodeRange = $ExplodeRange;
@onready var particles = $ExplosionEffect;
@onready var freeTimer = $FreeTimer;
@onready var hitBox = $HitBox;
@onready var CSGC = $CSGCylinder3D;
@onready var audioPlayer = $AudioStreamPlayer3D;

var alreadyHit = false;

func _on_hit_box_hit_signal() -> void:
	if alreadyHit:
		return;
	alreadyHit = true
	hitBox.set_collision_layer_value(6, false);
	explodeRange._explode();
	
	particles.emitting = true;
	audioPlayer.play()
	freeTimer.start(1)
	CSGC.queue_free()

func _on_free_timer_timeout() -> void:
	queue_free();

func save():
	var saveDict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"posX" : position.x,
		"posY" : position.y,
		"posZ" : position.z,
	}
	return saveDict
func loadMe(_key: StringName, _data) -> void:
	pass;
