extends Node3D

class_name PlayerWeapon

@onready var playerBody: CharacterBody3D = $"../..";
@onready var head: Node3D = $"..";
@onready var switchTimer = $switchTimer;

@export var weaponsList: Array[WeaponBase];
@export var heldWeapon: int = 0; ## An index for weaponsList

var weaponsEnabled = true;
var canSwitchWeapon = true;

func _ready() -> void:
	setHeld(heldWeapon)

func _input(event: InputEvent) -> void:
	if !weaponsEnabled:
		return;
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if canSwitchWeapon and heldWeapon + 1 < weaponsList.size():
				canSwitchWeapon = false;
				switchTimer.start(0.1);
				setHeld(heldWeapon + 1);
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if canSwitchWeapon and heldWeapon > 0:
				canSwitchWeapon = false;
				switchTimer.start(0.1);
				setHeld(heldWeapon - 1);
	if event is InputEventKey and event.is_pressed():
		match event.get_keycode_with_modifiers():
			KEY_1:
				setHeld(0);
			KEY_2:
				setHeld(1);
			KEY_3:
				setHeld(2);
			KEY_4:
				setHeld(3);
			KEY_5:
				setHeld(4);
			KEY_6:
				setHeld(5);
			KEY_7:
				setHeld(6);
			KEY_8:
				setHeld(7);
			KEY_9:
				setHeld(8);
			KEY_0:
				setHeld(9);
	if event.is_action_pressed("M1"):
		if weaponsList.get(heldWeapon) == null or weaponsList.size() <= heldWeapon:
			print("ERROR: no weapon in weaponsList at heldWeapon = " + str(heldWeapon));
			return;
		weaponsList.get(heldWeapon)._attackHeld(playerBody);
	if event.is_action_released("M1"):
		if weaponsList.get(heldWeapon) == null or weaponsList.size() <= heldWeapon:
			print("ERROR: no weapon in weaponsList at heldWeapon = " + str(heldWeapon));
			return;
		weaponsList.get(heldWeapon)._attackReleased(playerBody);

func setHeld(newIndex: int):
	if newIndex >= weaponsList.size():
		return;
	
	weaponsList.get(heldWeapon).visible = false;
	weaponsList.get(heldWeapon)._switchedFrom();
	heldWeapon = newIndex;
	weaponsList.get(heldWeapon).visible = true;
	weaponsList.get(heldWeapon)._switchTo();

func _addWeapon():
	pass;

func _addAmmo(type: WeaponBase.AMMOTYPE, ammount: int) -> int:
	var remainder = ammount;
	for weapon in weaponsList:
		if weapon.myAmmoType == type:
			remainder = weapon.addAmmo(remainder);
	return remainder;

func _on_switch_timer_timeout() -> void:
	canSwitchWeapon = true;

func _on_entity_component_killed() -> void:
	weaponsEnabled = false;
	visible = false;
	if weaponsList.get(heldWeapon) == null or weaponsList.size() <= heldWeapon:
		print("ERROR: no weapon in weaponsList at heldWeapon = " + str(heldWeapon));
		return;
	weaponsList.get(heldWeapon)._attackReleased(playerBody);

func save():
	var weaponNames: Array
	var curAmmos: Array[int]
	for weapon: WeaponBase in weaponsList:
		weaponNames.push_back(weapon.get_scene_file_path())
		curAmmos.push_back(weapon.curAmmo)
	var saveDict = {
		"heldWeapon" : heldWeapon,
		"weaponsNames" : weaponNames,
		"curAmmos" : curAmmos
	}
	return saveDict
func loadMe(data: Dictionary) -> void:
	heldWeapon = data.get("heldWeapon");
	var weaponNames = data.get("weaponsNames");
	var curAmmos = data.get("curAmmos");
	
	## Remove current weapons if they exist
	for weapon in weaponsList:
		weapon.queue_free();
	weaponsList.clear();
	
	## add weapons from save file
	for index in weaponNames.size():
		var weaponName = weaponNames[index];
		var newWeapon: WeaponBase = load(weaponName).instantiate();
		newWeapon.curAmmo = curAmmos[index];
		newWeapon.visible = false;
		add_child(newWeapon);
		weaponsList.push_back(newWeapon);
	
	weaponsList.get(heldWeapon).visible = true;
