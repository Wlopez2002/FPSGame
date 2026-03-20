extends CharacterBody3D

@onready var bodyMesh = $MeshInstance3D;
@onready var enemyAttack = $EnemyAttack;
@onready var attackTimer = $AttackTimer;
@onready var attackPlayer = $AttackPlayer;

const SPEED = 7.5
var gravity = 15.0;
var jumpImpulse = 10;
var redTimer = 0.0;
var canAttack = true;

var player: CharacterBody3D;

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player");
	bodyMesh.mesh.material.albedo_color = Color.GRAY
	if !player:
		print("ERROR player node not found")

func _physics_process(delta: float) -> void:
	if enemyAttack.get_overlapping_areas().size() > 0 and canAttack:
		_attack()
	
	if player == null:
		player = get_tree().get_first_node_in_group("Player");
		return;
	
	look_at(player.global_position)
	rotation.x = 0; rotation.z = 0;
	if redTimer > 0:
		redTimer -= delta;
		if redTimer <= 0:
			bodyMesh.mesh.material.albedo_color = Color.GRAY
	
	if !is_on_floor():
		velocity.y -= gravity * delta
	else:
		var hcomponent = (global_position - player.global_position)
		hcomponent.y = 0;
		if global_position.y + 1 < player.global_position.y and hcomponent.length() < 10:
			velocity.y += jumpImpulse;
			
	var direction = SPEED * global_position.direction_to(player.global_position);
	direction.y = 0;
	
	velocity.x = direction.x;
	velocity.z = direction.z;
	move_and_slide();

func _attack():
	attackPlayer.play()
	canAttack = false
	for area in enemyAttack.get_overlapping_areas():
		if area is HitBox:
			var box: HitBox = area;
			box._hit(1)
			attackTimer.start(0.5)

func _on_entity_component_hit() -> void:
	redTimer = 0.2;
	bodyMesh.mesh.material.albedo_color = Color.RED

func _on_attack_timer_timeout() -> void:
	canAttack = true

func save():
	var Entity: EntityComponent = $EntityComponent;
	var saveDict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"posX" : position.x,
		"posY" : position.y,
		"posZ" : position.z,
		"curHealth" : Entity.health
	}
	return saveDict
func loadMe(key: StringName, data) -> void:
	var Entity: EntityComponent = $EntityComponent;
	match key:
		"curHealth":
			Entity.health = data;
