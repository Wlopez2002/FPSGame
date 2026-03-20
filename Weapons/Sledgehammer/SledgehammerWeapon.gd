extends WeaponBase

@onready var rangeArea = $Range;
@onready var wallCast = $WallCast;
@onready var attackSpeedTimer: Timer = $AttackSpeedTimer;
@onready var sledgeMesh = $Model/Sledgehammer;

@onready var audioBigHit = $WeaponSounds/BigHitAudio;
@onready var audioLittleHit = $WeaponSounds/LittleHitPlayer;
@onready var audioMiss = $WeaponSounds/MissPlayer;

func _switchTo():
	pass;

func _switchedFrom():
	pass;

func _attackHeld(body):
	_attack(body)

func _attackReleased(_body):
	pass;

func _attack(body: CharacterBody3D):
	var doBackforce = false;
	var hitSomething = false;
	if canAttack:
		for area in rangeArea.get_overlapping_areas():
			if area is HitBox:
				area._hit(damage);
				hitSomething = true;
				if !body.is_on_floor(): ## allow the player to pogo on enemies
					body.velocity.y = 0;
					doBackforce = true
					audioLittleHit.play()
				else:
					audioLittleHit.play()
		if  rangeArea.get_overlapping_bodies().size() > 0: ## check if hit wall
			doBackforce = true
			hitSomething = true;
			audioBigHit.play()
		if doBackforce:
			var direction = get_global_transform().basis.z
			body._applyForce(direction * 10)
		if !hitSomething:
			audioMiss.play()
		attackSpeedTimer.start(attackSpeed)
		canAttack = false;
		sledgeMesh.get_surface_override_material(1).albedo_color = Color.RED


func _on_attack_speed_timer_timeout() -> void:
	canAttack = true;
	sledgeMesh.get_surface_override_material(1).albedo_color = Color.GRAY
