extends WeaponBase

@onready var mesh = $MeshInstance3D;
@onready var attackSpeedTimer = $AttackSpeedTimer;
@onready var hitArea = $hitArea;

@onready var weaponClick = $WeaponSounds/PistolClickPlayer
@onready var weaponFire = $WeaponSounds/PistolFirePlayer;

@onready var weaponEffects = $WeaponEffects;

var RNG = RandomNumberGenerator.new()

var attacking = false;
var bodyHolding: PlayerBody;

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
		doEffects();
		if !body.is_on_floor():
			body._applyForce(get_global_transform().basis.z * 10)
		for area in hitArea.get_overlapping_areas():
			if area is HitBox:
				area._hit(damage)
		attackSpeedTimer.start(attackSpeed)
		canAttack = false;
		curAmmo -= 1;
		mesh.mesh.material.albedo_color = Color.RED
		weaponFire.play()
	elif curAmmo <= 0:
		weaponClick.play()
		attackSpeedTimer.start(attackSpeed)

func doEffects():
	var SPREAD = 0.1;
	for effect: GPUParticles3D in weaponEffects.get_children():
		effect.rotation.x = RNG.randf_range(-SPREAD, SPREAD)
		effect.rotation.y = RNG.randf_range(-SPREAD, SPREAD)
		effect.emitting = true
		effect.restart()

func _on_attack_speed_timer_timeout() -> void:
	canAttack = true;
	mesh.mesh.material.albedo_color = Color.GRAY
	if attacking:
			_attack(bodyHolding);
