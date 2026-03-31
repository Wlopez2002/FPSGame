extends Projectile

@onready var explodeComp = $ExplodeRange;
@onready var freeTimer = $FreeTimer;
@onready var audioPlayer = $AudioStreamPlayer3D;
@onready var gpuPart = $ExplosionEffect;
@onready var mesh = $MeshInstance3D;

var exploded = false;

func detonate():
	if exploded:
		return;
	explodeComp._explode();
	audioPlayer.play()
	mesh.visible = false;
	gpuPart.emitting = true;
	freeTimer.start(1)
	exploded = true;

func areaHit(_area: Area3D) -> void:
	detonate()

func endLiveTime():
	detonate();

func _on_hit_range_area_entered(_area: Area3D) -> void:
	if activateTimer <= 0:
		detonate();

func _on_free_timer_timeout() -> void:
	queue_free()

func _on_hit_box_hit_signal(_dam) -> void:
	detonate();

func save():
	var saveDict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"posX" : position.x,
		"posY" : position.y,
		"posZ" : position.z,
		"dX" : direction.x,
		"dY" : direction.y,
		"dZ" : direction.z,
		"speed" : speed,
	}
	return saveDict
func loadMe(key: StringName, data) -> void:
	match key:
		"speed":
			speed = data;
		"dX":
			direction.x  = data;
		"dY":
			direction.y  = data;
		"dZ":
			direction.z  = data;
