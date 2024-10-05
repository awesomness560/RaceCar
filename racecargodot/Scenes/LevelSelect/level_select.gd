extends Control
class_name LevelSelect

@export_dir var levelResourcesFolder : String
@export var levelButton : PackedScene
@export var levelContainer : HFlowContainer

var levelResources : Array[Level]

func _ready() -> void:
	dir_levels(levelResourcesFolder + "/")
	for level in levelResources:
		var button : LevelButton = levelButton.instantiate() as LevelButton
		button.levelIcon.texture = level.levelImage
		button.levelLabel.text = level.levelName
		
		levelContainer.add_child(button)
		
		#button.pressed.connect()

func dir_levels(path : String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				levelResources.append(load(path + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
