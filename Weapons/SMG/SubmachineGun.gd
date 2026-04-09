extends WeaponBase

@onready var mesh = $MeshInstance3D;
@onready var hitRay = $MeshInstance3D/hitray
@onready var attackSpeedTimer = $AttackSpeedTimer;

@onready var pistolClickPlayer = $WeaponSounds/PistolClickPlayer;
@onready var pistolFirePlayer = $WeaponSounds/PistolFirePlayer;
@onready var hitScanEffect = $MeshInstance3D/HitScanBulletShot

const SPREAD = 0.1;
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
		var hit = hitRay.get_collider();
		if hit is HitBox:
			hit._hit(damage);
		attackSpeedTimer.start(attackSpeed)
		canAttack = false;
		curAmmo -= 1;
		mesh.mesh.material.albedo_color = Color.RED
		pistolFirePlayer.play()
		hitScanEffect.emitting = true;
		hitScanEffect.restart()
	elif curAmmo <= 0:
		pistolClickPlayer.play()
		attackSpeedTimer.start(attackSpeed)

func applySpread():
	hitRay.rotation.x = RNG.randf_range(-SPREAD, SPREAD)
	hitRay.rotation.y = RNG.randf_range(-SPREAD, SPREAD)
	hitScanEffect.rotation.x = hitRay.rotation.x
	hitScanEffect.rotation.y = hitRay.rotation.y

func _on_attack_speed_timer_timeout() -> void:
	canAttack = true;
	mesh.mesh.material.albedo_color = Color.GRAY
	if attacking:
		_attack(bodyHolding);
