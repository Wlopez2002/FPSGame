extends CanvasLayer

@onready var speedLabel: Label = $VBoxContainer/SpeedLabel
@onready var locationLabel: Label = $VBoxContainer/LocationLabel
@onready var heldWeaponLabel = $VBoxContainer/HeldWeaponLabel;
@onready var playerHealth = $HBoxContainer/HealthLabel;
@onready var canDashLabel = $HBoxContainer/CanDashLabel;
@onready var playerKilledColor = $ColorRect;

@export var playerWeapons: PlayerWeapon;
@export var playerCharBody: CharacterBody3D;
@export var playerEntity: EntityComponent;

func _process(_delta: float) -> void:
	setLabels()

func setLabels():
	speedLabel.text = str(playerCharBody.velocity.length()) + "\n" + str(playerCharBody.velocity.normalized())
	locationLabel.text = str(playerCharBody.global_position)
	
	var curWeapon: WeaponBase = playerWeapons.weaponsList.get(playerWeapons.heldWeapon);
	heldWeaponLabel.text = curWeapon.weaponName + "\n";
	heldWeaponLabel.text += str(curWeapon.curAmmo) + "/" + str(curWeapon.maxAmmo) + " Ammo"
	playerHealth.text = "Health " + str(playerEntity.health) + "|" + str(playerEntity.maxHealth)
	if playerCharBody.canDash == true:
		canDashLabel.text = "Dash Ready";
	else:
		canDashLabel.text = "";

func _playerKilled():
	playerKilledColor.visible = true;
