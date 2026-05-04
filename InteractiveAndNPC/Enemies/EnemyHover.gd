extends CharacterBody3D

enum AiModes {WANDER, PERSUE, DASH}

@onready var floorFinder = $FloorFinder;
@onready var dashTimer = $DashTimer;
@onready var attackTimer = $attackTimer;
@onready var enemyAttack = $enemyAttack;

const SPEED = 10.0

@export var hoverDistance = 4.0;
@export var hoverError = 0.5;

var aiMode = AiModes.WANDER;
var player: CharacterBody3D;
var wanderTo: Vector2;

func _ready():
	wanderTo = Vector2(global_position.x, global_position.z);

func _physics_process(_delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("Player");
		return;
	
	## above 1 as the hitbox is inside enemy attack area
	if enemyAttack.get_overlapping_areas().size() > 1 and attackTimer.is_stopped():
		_attack()
	
	match aiMode:
		AiModes.WANDER:
			if Vector2(global_position.x,global_position.z).distance_to(wanderTo) < 0.1:
				wanderTo = Vector2(global_position.x,global_position.z);
				wanderTo += (Vector2(randi_range(-1,1),randi_range(-1,1)).normalized() * 10);
				
			velocity = global_position.direction_to(Vector3(wanderTo.x,global_position.y,wanderTo.y)) * SPEED
			maintainHeight()
		AiModes.PERSUE:
			velocity = global_position.direction_to(player.global_position) * SPEED
			#maintainHeight()
			
			if Vector2(global_position.x,global_position.z).distance_to(Vector2(player.global_position.x,player.global_position.z)) < 5:
				aiMode = AiModes.DASH
		AiModes.DASH:
			if dashTimer.is_stopped():
				velocity = global_position.direction_to(player.global_position) * SPEED * 3
				dashTimer.start(1.0)
	
	move_and_slide()

func maintainHeight():
	var distanceFromFloor = -1;
	if floorFinder.is_colliding():
		distanceFromFloor = global_position.distance_to(floorFinder.get_collision_point())
	if distanceFromFloor < hoverDistance - hoverError:
		## move up
		velocity.y = SPEED;
	elif distanceFromFloor > hoverDistance + hoverError:
		## move down 
		velocity.y = -SPEED;
	else:
		velocity.y = 0;

func _on_dash_timer_timeout() -> void:
	aiMode = AiModes.PERSUE

func _on_player_detect_area_area_entered(_area: Area3D) -> void:
	if aiMode == AiModes.WANDER:
		aiMode = AiModes.PERSUE

func _attack():
	var myHitBox = $HitBox;
	if attackTimer.is_stopped():
		for area in enemyAttack.get_overlapping_areas():
			if area is HitBox and (area != myHitBox):
				var box: HitBox = area;
				box._hit(5)
				attackTimer.start(0.5)
		
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
