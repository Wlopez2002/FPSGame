extends CanvasLayer

@onready var speedLabel: Label = $VBoxContainer/SpeedLabel
@onready var locationLabel: Label = $VBoxContainer/LocationLabel
@onready var heldWeaponLabel = $VBoxContainer/HeldWeaponLabel;
@onready var playerHealth = $HBoxContainer/HealthLabel;
@onready var canDashLabel = $HBoxContainer/CanDashLabel;
@onready var playerKilledColor = $DeadRect;
@onready var swimingRect = $SwimingRect;


@export var playerWeapons: PlayerWeapon;
@export var playerCharBody: PlayerBody;
@export var playerEntity: EntityComponent;

func _process(_delta: float) -> void:
	setLabels()

func setLabels():
	speedLabel.text = str(playerCharBody.velocity.length()) + "\n" + str(playerCharBody.velocity)
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
	swimingRect.visible = false;
	playerKilledColor.visible = true;


func _on_water_detector_head_area_entered(area: Area3D) -> void:
	swimingRect.visible = true;
func _on_water_detector_head_area_exited(area: Area3D) -> void:
	swimingRect.visible = false;
