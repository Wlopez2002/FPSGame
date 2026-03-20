extends Node

var menuNode: CanvasLayer;

func _ready() -> void:
	if not DirAccess.dir_exists_absolute("user://saves"):
		var dir = DirAccess.open("user://")
		dir.make_dir("saves")

#func saveSettings():
	#var saveFile = FileAccess.open("user://settings", FileAccess.WRITE)
	#var jsonString = JSON.stringify(GameData.save())
	#saveFile.store_line(jsonString)

#func loadSettings():
	#if not FileAccess.file_exists("user://settings"):
		#return
	#
	#var saveFile = FileAccess.open("user://settings", FileAccess.READ)
	#var json = JSON.new()
	#while saveFile.get_position() < saveFile.get_length():
		#var jsonString = saveFile.get_line()
		#
		## Check if there is any error while parsing the JSON string, skip in case of failure.
		#var parsedResults = json.parse(jsonString)
		#if not parsedResults == OK:
			#print("JSON Parse Error: ", json.get_error_message(), " in ", jsonString, " at line ", json.get_error_line())
			#continue
		#
	#var SettingsData: Dictionary = json.data;
	#for key in SettingsData:
		#GameData.loadMe(key, SettingsData[key])

func saveGame():
	var saveFile = FileAccess.open("user://saves//savegame.save", FileAccess.WRITE)
	var nodesToSave = get_tree().get_nodes_in_group("Persistent")
	for node in nodesToSave:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var nodeData = node.call("save")
		
		# construct the gamedata dict
		var saveData = {
		"CurrentLevel" : GameData.currentLevel.get_scene_file_path(),
		"PersistantNodes": nodeData
		}

		# JSON provides a static method to serialized JSON string.
		var jsonString = JSON.stringify(saveData)

		# Store the save dictionary as a new line in the save file.
		saveFile.store_line(jsonString)
		print(nodeData)
	print("saved game")

func loadGame():
	if not FileAccess.file_exists("user://saves//savegame.save"):
		print("Error: failed to load game, file not found")
		return;
	
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var saveFile = FileAccess.open("user://saves//savegame.save", FileAccess.READ)
	var saveData;
	var newObjects: Array;
	var newData: Array;
	
	# Creates the helper class to interact with JSON.
	var json = JSON.new()
	while saveFile.get_position() < saveFile.get_length():
		var jsonString = saveFile.get_line()
		
		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parsedResults = json.parse(jsonString)
		if not parsedResults == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", jsonString, " at line ", json.get_error_line())
			continue
		
		saveData = json.data;
		var nodeData = saveData["PersistantNodes"]
		newData.push_back(nodeData);
		var newObject = load(nodeData["filename"]).instantiate()
		newObjects.push_back(newObject);
	
	# load the level if needed
	if GameData.currentLevel.get_scene_file_path() != saveData["CurrentLevel"]:
		GameData.changeLevel(load(saveData["CurrentLevel"]))
		print("changing Level")
	
	
	loadPNodes(newObjects, newData)
	
	# clean up the load
	menuNode.toggleMenu();
	print("loaded game")

func loadPNodes(newObjects, newData):
	## Remove persistent nodes from the level
	var persistentNodes = get_tree().get_nodes_in_group("Persistent")
	for i in persistentNodes:
		i.queue_free()
	
	for index in range(newObjects.size()):
		var newObject = newObjects[index]
		var nodeData = newData[index]
		
		GameData.currentLevel.get_node(nodeData["parent"]).add_child(newObject)
		newObject.position = Vector3(nodeData["posX"], nodeData["posY"], nodeData["posZ"])
		# Now we set the remaining variables.
		for i in nodeData.keys():
			if i == "filename" or i == "parent":
				continue
			if i == "posX" or i == "posY" or i == "posZ":
				continue
			if newObject.has_method("loadMe"):
				newObject.loadMe(i, nodeData[i])
			else:
				print("Error: object was loaded but did not have loadMe")
