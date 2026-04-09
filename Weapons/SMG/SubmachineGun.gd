extends WeaponBase

@onready var mesh = $MeshInstance3D;
@onready var hitRay = $RayCast3D;
@onready var attackSpeedTimer = $AttackSpeedTimer;

@onready var pistolClickPlayer = $WeaponSounds/PistolClickPlayer;
@onready var pistolFirePlayer = $WeaponSounds/PistolFirePlayer;
@onready var hitScanEffect = $HitScanBulletShot

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

func _attack(_body: CharacterBody3D):
	if canAttack and curAmmo > 0:
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

func _on_attack_speed_timer_timeout() -> void:
	canAttack = true;
	mesh.mesh.material.albedo_color = Color.GRAY
	if attacking:
		_attack(bodyHolding);
