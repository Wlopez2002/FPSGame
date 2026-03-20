extends WeaponBase

@onready var attackSpeedTimer = $AttackSpeedTimer;
@onready var mesh = $MeshInstance3D;
@onready var pistolClickPlayer = $WeaponSounds/clickPlayer;
@onready var pistolFirePlayer = $WeaponSounds/firePlayer;

var attacking = false;
var bodyHolding;

func _switchTo():
	pass;

func _switchedFrom():
	attacking = false;

func _attackHeld(body: CharacterBody3D):
	attacking = true;
	bodyHolding = body;
	_attack(body);

func _attackReleased(_body: CharacterBody3D):
	attacking = false;

func _attack(body: CharacterBody3D):
	if canAttack and curAmmo > 0:
		attackSpeedTimer.start(attackSpeed)
		canAttack = false;
		curAmmo -= 1;
		createGrenade(body.velocity);
		mesh.mesh.material.albedo_color = Color.RED
		pistolFirePlayer.play()
	elif curAmmo <= 0:
		pistolClickPlayer.play()
		attackSpeedTimer.start(attackSpeed)

var GlGrenadeScene = preload("res://Objects/Projectiles/GLGrenade.tscn");
func createGrenade(velocity: Vector3):
	var newGrenade: Projectile = GlGrenadeScene.instantiate();
	GameData.currentLevel.add_child(newGrenade);
	
	## add the forward velocity
	var forwardVector = -global_transform.basis.z
	newGrenade.linear_velocity = velocity.project(forwardVector);
	
	newGrenade.direction = forwardVector
	newGrenade.global_position = global_position + forwardVector/4;

func _on_attack_speed_timer_timeout() -> void:
	canAttack = true;
	mesh.mesh.material.albedo_color = Color.GRAY
	if attacking:
		_attack(bodyHolding);
