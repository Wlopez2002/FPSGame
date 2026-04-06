extends Node

var currentLevel: Level;

## settings
var MOUSESENSITIVITYBASE = 0.003;
var MOUSESENSITIVITY = 0.003;

func changeLevel(level: PackedScene):
	var playerData = get_tree().get_first_node_in_group("Player").save();
	## clear any level children that may exist
	for child in get_tree().root.get_children():
		if child is Level:
			get_tree().root.remove_child(child);
			child.queue_free();
	var newLevel: Level = level.instantiate()

	get_tree().root.add_child(newLevel)
	var player: PlayerBody = get_tree().get_first_node_in_group("Player")
	for key in playerData:
		player.loadIntoNewLevel(key, playerData[key])
