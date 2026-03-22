extends CharacterBody3D

class_name PlayerBody

@onready var headNode = $Head;
@onready var bodyCol = $Body;
@onready var uncrouchRay = $Uncrouch;

## only use this to check if the floor is something special
## do not use it to check if the player is grounded
@onready var floorDetector = $FloorDetect;

@onready var dashTimer = $DashTimer;
@onready var dashGraceTimer = $DashGraceTimer;

@export var maxDoubleJumps = 0;

const MAXGROUNDSPEED = 10.0;
const MAXCROUCHSPEED = 5.0;
const MAXAIRSPEED = 1.0;
const MAXACCELERATION = MAXGROUNDSPEED * 10;

var movementEnabled = true;

var wasInAir = false;
var gravity = 15.0;
var friction = 4.0;
var jumpImpulse = 8.0;
var crouching = false;
var tryUncrouch = false; 
var doubleJumps = 0;
var dashCoolDown = 1.5;
var dashGrace = 0.5;
var canDash = true;
var dashing = false; ## controls friction if on floor.

var naturalVelocity = Vector3.ZERO;
var floorVelocity = Vector3.ZERO


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * GameData.MOUSESENSITIVITY)
		headNode.rotate_x(-event.relative.y * GameData.MOUSESENSITIVITY)
		headNode.rotation.x = clamp(headNode.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	
	if !movementEnabled: ## anything past is controlled by movementEnabled
		return;
	if event.is_action_pressed("MoveJump"):
		if is_on_floor():
			_applyForce(Vector3(0,jumpImpulse,0))
		else:
			if doubleJumps > 0:
				velocity.y = 0;
				_applyForce(Vector3(0,jumpImpulse,0))
				doubleJumps -= 1;
	if event.is_action_pressed("MoveCrouch"):
		bodyCol.shape.height = 1.0;
		crouching = true;
		tryUncrouch = false;
	if event.is_action_released("MoveCrouch"):
		tryUncrouch = true;
	if event.is_action_pressed("MoveDash") and canDash:
		var input_dir := Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward");
		var dashWeight = 10;
		if input_dir:
			var wishDir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();
			_applyForce(wishDir * dashWeight);
		else:
			_applyForce(global_transform.basis.z * -dashWeight);
		canDash = false;
		dashing = true;
		dashTimer.start(dashCoolDown)
		dashGraceTimer.start(dashGrace);

func _physics_process(delta: float) -> void:
	if crouching and tryUncrouch:
		if !uncrouchRay.is_colliding():
			crouching = false;
			tryUncrouch = false
			bodyCol.shape.height = 2.0;
	
	_updateVelocity(delta)
	
	if is_on_floor():
		doubleJumps = maxDoubleJumps;
		wasInAir = false
	else:
		wasInAir = true;
	move_and_slide()

func _updateVelocity(delta: float):
	var input_dir := Vector2.ZERO
	if movementEnabled:
		input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward");
	var wishDir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();
	
	if is_on_floor() and !dashing:
		naturalVelocity = _applyFriction(naturalVelocity, delta)
		
		if crouching:
			_accelerate(wishDir, MAXCROUCHSPEED, delta);
		else:
			_accelerate(wishDir, MAXGROUNDSPEED, delta);
	else:
		naturalVelocity.y -= gravity * delta
		_accelerate(wishDir, MAXAIRSPEED, delta);
	
	## if the player is on a moving platform we need to add it's velocity
	if is_on_floor():
		if floorDetector.get_collider() is MovingPlatformBody:
			floorVelocity = floorDetector.get_collider().velocity;
		else:
			floorVelocity = Vector3.ZERO
	velocity = naturalVelocity + floorVelocity;

func _applyFriction(vel: Vector3, delta) -> Vector3:
	if vel.length() != 0: ## the player is moving
		var control = max(1.5,vel.length())
		var drop;
		
		if crouching and vel.length() > 10: ## do a slide
			drop = control * (friction/4) * delta;
		else:
			drop = control * friction * delta
			
		vel *= max(vel.length() - drop, 0) / vel.length()
	return vel;

func _accelerate(wishDir: Vector3, maxVelocity: float, delta: float):
	var curSpeed = naturalVelocity.dot(wishDir);
	var speedToAdd = clamp(maxVelocity - curSpeed, 0, MAXACCELERATION * delta);
	naturalVelocity += speedToAdd * wishDir;

func _applyForce(force: Vector3):
	if movementEnabled:
		naturalVelocity += force;

## Teleport the player and change their velocity to reflect the new position
## This lacks a transformation of velocity and rotation on the y axis
func _smoothTeleport(newPos: Vector3, oldForward: Vector3, newForward: Vector3, teleporterVelocity, destVelocity):
	## set player position
	global_position = newPos;
	var playerForward = transform.basis.z;

	var vDir = naturalVelocity.normalized();
	var rotations = Vector2(oldForward.x,oldForward.z).angle_to(Vector2(vDir.x,vDir.z)) - PI
	var newxz = Vector2(newForward.x,newForward.z).rotated(rotations)
	var vNew = Vector3(newxz.x, vDir.y, newxz.y) * naturalVelocity.length()
	naturalVelocity = vNew;
	
	velocity =  naturalVelocity + floorVelocity;
	
	
	## set the player's rotation
	var relativeRot = Vector2(oldForward.x,oldForward.z).angle_to(Vector2(playerForward.x,playerForward.z))
	var relativeForward = Vector2(newForward.x,newForward.z).rotated(relativeRot)
	look_at(global_position + Vector3(relativeForward.x,0,relativeForward.y))

func _on_dash_timer_timeout() -> void:
	canDash = true;
func _on_dash_grace_timer_timeout() -> void:
	dashing = false;

func _on_entity_component_killed() -> void:
	movementEnabled = false;
	bodyCol.shape.height = 1.0;
	crouching = true



## This has nothing to do with movement, but as this is the head script of the player
## it needs to handle save and load;
func save():
	var Entity: EntityComponent = $EntityComponent;
	var playerWeapons: PlayerWeapon = $Head/Weapons;
	var PlayerWeaponsSave = playerWeapons.save();
	var saveDict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"posX" : position.x,
		"posY" : position.y,
		"posZ" : position.z,
		"rotationX" : headNode.rotation.x,
		"rotationY" : rotation.y,
		"vX" : velocity.x,
		"vY" : velocity.y,
		"vZ" : velocity.z,
		"crouching" : crouching,
		"tryUncrouch" : tryUncrouch,
		"curHealth" : Entity.health,
		"weapons" : PlayerWeaponsSave
	}
	return saveDict
func loadMe(key: StringName, data) -> void:
	var Entity: EntityComponent = $EntityComponent;
	var playerWeapons: PlayerWeapon = $Head/Weapons;
	match key:
		"rotationX":
			headNode.rotation.x = data;
		"rotationY":
			rotation.y = data;
		"vX":
			velocity.x = data;
		"vY":
			velocity.y = data;
		"vZ":
			velocity.z = data;
		"crouching":
			crouching = data;
			if crouching:
				bodyCol.shape.height = 1.0;
		"tryUncrouch":
			tryUncrouch = data;
		"curHealth":
			Entity.health = data;
		"weapons":
			playerWeapons.loadMe(data)
func loadIntoNewLevel(key: StringName, data) -> void:
	var Entity: EntityComponent = $EntityComponent;
	var playerWeapons: PlayerWeapon = $Head/Weapons;
	match key:
		"crouching":
			crouching = data;
			if crouching:
				bodyCol.shape.height = 1.0;
		"tryUncrouch":
			tryUncrouch = data;
		"curHealth":
			Entity.health = data;
		"weapons":
			playerWeapons.loadMe(data)
