extends Node3D

class_name WeaponBase

enum WEAPONTYPE {MELEE, HITSCAN, PROJECTILE}
enum AMMOTYPE {NONE, PISTOL, SMG, GRENADE}

@export var weaponName: String
@export var myAmmoType: AMMOTYPE;
@export var type: WEAPONTYPE;
@export var prefWeaponSlot: int = -1; ## Uses this to order weapons when picked up
@export var damage: int;
@export var attackSpeed: float;
@export var maxAmmo: int = 0;

var canAttack = true;
var curAmmo: int = maxAmmo;

func _switchTo(): ## This weapon is being switched to.
	pass;

func _switchedFrom(): ## This weapon was held but was switched to another
	pass;

func _attackHeld(_body: CharacterBody3D):
	pass;

func _attackReleased(_body: CharacterBody3D):
	pass;

func _attack(_body: CharacterBody3D):
	pass;

func addAmmo(amount: int) -> int:
	curAmmo += amount;
	if curAmmo > maxAmmo:
		var remain = curAmmo - maxAmmo;
		curAmmo = maxAmmo;
		return remain;
	else:
		return 0;
