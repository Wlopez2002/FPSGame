extends WeaponBase

@onready var mesh = $MeshInstance3D;
@onready var hitRay = $MeshInstance3D/hitray
@onready var hitRay2 = $MeshInstance3D/hitray2
@onready var hitRay3 = $MeshInstance3D/hitray3
@onready var attackSpeedTimer = $AttackSpeedTimer;

@onready var pistolClickPlayer = $WeaponSounds/PistolClickPlayer;
@onready var pistolFirePlayer = $WeaponSounds/PistolFirePlayer;
@onready var hitScanEffect = $MeshInstance3D/HitScanBulletShot
@onready var hitScanEffect2 = $MeshInstance3D/HitScanBulletShot2
@onready var hitScanEffect3 = $MeshInstance3D/HitScanBulletShot3

const SPREAD = 0.15;
var attacking = false;
var bodyHolding;
var RNG = RandomNumberGenerator.new()

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

func _attack(_body: CharacterBody3D):
	if canAttack and curAmmo > 0:
		applySpread()
		
		if hitRay.get_collider() is HitBox:
			hitRay.get_collider()._hit(damage);
		elif hitRay2.get_collider() is HitBox:
			hitRay2.get_collider()._hit(damage);
		elif hitRay3.get_collider() is HitBox:
			hitRay3.get_collider()._hit(damage);
		
		attackSpeedTimer.start(attackSpeed)
		canAttack = false;
		curAmmo -= 1;
		mesh.mesh.material.albedo_color = Color.RED
		pistolFirePlayer.play()
		
		hitScanEffect.emitting = true;
		hitScanEffect.restart()
		hitScanEffect2.emitting = true;
		hitScanEffect2.restart()
		hitScanEffect3.emitting = true;
		hitScanEffect3.restart()
	elif curAmmo <= 0:
		pistolClickPlayer.play()
		attackSpeedTimer.start(attackSpeed)

func applySpread():
	hitRay.rotation.x = RNG.randf_range(-SPREAD, SPREAD)
	hitRay.rotation.y = RNG.randf_range(-SPREAD, SPREAD)
	hitScanEffect.rotation.x = hitRay.rotation.x
	hitScanEffect.rotation.y = hitRay.rotation.y
	
	hitRay2.rotation.x = RNG.randf_range(-SPREAD, SPREAD)
	hitRay2.rotation.y = RNG.randf_range(-SPREAD, SPREAD)
	hitScanEffect2.rotation.x = hitRay2.rotation.x
	hitScanEffect2.rotation.y = hitRay2.rotation.y
	
	hitRay3.rotation.x = RNG.randf_range(-SPREAD, SPREAD)
	hitRay3.rotation.y = RNG.randf_range(-SPREAD, SPREAD)
	hitScanEffect3.rotation.x = hitRay3.rotation.x
	hitScanEffect3.rotation.y = hitRay3.rotation.y

func _on_attack_speed_timer_timeout() -> void:
	canAttack = true;
	mesh.mesh.material.albedo_color = Color.GRAY
	if attacking:
		_attack(bodyHolding);
