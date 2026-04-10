extends Node

var currentLevel: Level;

## Debug Settings
var debugInfo = false;
var godMode = false;
var noClip = false;

## Settings
var MOUSESENSITIVITYBASE = 0.003;
var MOUSESENSITIVITY = 0.003;

func _ready():
	randomize()

func changeLevel(level: String):
	if GameData.debugInfo:
		print("Debug: loading level " + level)
	var playerData = get_tree().get_first_node_in_group("Player").save();
	## clear any level children that may exist
	for child in get_tree().root.get_children():
		if child is Level:
			get_tree().root.remove_child(child);
			child.queue_free();
	var newLevel: Level = load(level).instantiate()

	get_tree().root.add_child(newLevel)
	var player: PlayerBody = get_tree().get_first_node_in_group("Player")
	for key in playerData:
		player.loadIntoNewLevel(key, playerData[key])
