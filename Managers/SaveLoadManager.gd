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
	var nodesToSaveNRI = get_tree().get_nodes_in_group("PersistentNRI")
	var nodeData: Array[Dictionary];
	var nodeDataNRI: Array[Dictionary];
	
	## drop PersistentNSL nodes
	for node in nodesToSave:
		if node.is_in_group("PersistentNSL"):
			nodesToSave.remove_at(nodesToSave.find(node))
	for node in nodesToSaveNRI:
		if node.is_in_group("PersistentNSL"):
			nodesToSaveNRI.remove_at(nodesToSaveNRI.find(node))
	
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
		nodeData.push_back(node.call("save"))
	
	# do the same for NRI nodes
	for node in nodesToSaveNRI:
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		nodeDataNRI.push_back(node.call("save"))
	
	# construct the gamedata dict
	var saveData = {
	"CurrentLevel" : GameData.currentLevel.get_scene_file_path(),
	"PersistantNodes": nodeData,
	"PersistantNodesNRI" : nodeDataNRI
	}

	# JSON provides a static method to serialized JSON string.
	var jsonString = JSON.stringify(saveData)

	# Store the save dictionary as a new line in the save file.
	saveFile.store_line(jsonString)

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
		for data in nodeData:
			newData.push_back(data);
			var newObject = load(data["filename"]).instantiate()
			newObjects.push_back(newObject);
	
	# load the level if needed
	if GameData.currentLevel.get_scene_file_path() != saveData["CurrentLevel"]:
		GameData.changeLevel(load(saveData["CurrentLevel"]))
		print("changing Level")
	
	loadPNodes(newObjects, newData)
	loadPNRINodes(saveData["PersistantNodesNRI"])
	
	# clean up the load
	menuNode.toggleMenu();
	print("loaded game")

## NRI nodes must be edited from existing nodes in the level
## as they have children or signals that are disrupted by removing
## and instancing new versions as loadPNodes does.
func loadPNRINodes(newData):
	var persistentNodes = get_tree().get_nodes_in_group("PersistentNRI")
	for node in persistentNodes: ## Not good performance
		for data in newData:
			if str(node.get_path()) == data["identifier"]:
				node.position = Vector3(data["posX"], data["posY"], data["posZ"])
				for i in data.keys():
					if i == "filename" or i == "parent":
						continue
					if i == "posX" or i == "posY" or i == "posZ":
						continue
					if node.has_method("loadMe"):
						node.loadMe(i, data[i])
					else:
						print("Error: object was loaded but did not have loadMe")


func loadPNodes(newObjects, newData):
	## Remove persistent nodes from the level
	var persistentNodes = get_tree().get_nodes_in_group("Persistent")
	for i in persistentNodes:
		if !i.is_in_group("PersistentNSL"):
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
