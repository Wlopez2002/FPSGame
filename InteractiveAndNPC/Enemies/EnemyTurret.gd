extends Node3D

@onready var swiv = $Swiv;
@onready var rayCast = $Swiv/RayCast3D;
@onready var attackTimer = $AttackTimer;

var player: CharacterBody3D;

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player");
	if !player:
		print("ERROR player node not found")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("Player");
		return;
	
	if attackTimer.is_stopped():
		if rayCast.is_colliding():
			if rayCast.get_collider() is PlayerBody:
				attackTimer.start(0.5);
				call_deferred("_attack");
	
	swiv.look_at(player.global_position)

func _attack() -> void:
	var newBullet = load("res://Objects/Projectiles/Bullet.tscn").instantiate()
	GameData.currentLevel.add_child(newBullet);
	newBullet.damage = 1;
	newBullet.direction = -swiv.global_transform.basis.z
	newBullet.global_position = global_position;

func save():
	var Entity: EntityComponent = $EntityComponent;
	var saveDict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"posX" : position.x,
		"posY" : position.y,
		"posZ" : position.z,
		"rotX" : rotation.x,
		"rotY" : rotation.y,
		"rotZ" : rotation.z,
		"curHealth" : Entity.health
	}
	return saveDict
func loadMe(key: StringName, data) -> void:
	var Entity: EntityComponent = $EntityComponent;
	match key:
		"curHealth":
			Entity.health = data;
		"rotX":
			rotation.x = data
		"rotY":
			rotation.y = data
		"rotZ":
			rotation.z = data
