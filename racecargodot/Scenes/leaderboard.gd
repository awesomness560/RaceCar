extends Control
class_name LeaderboardMenu

@export var levelButton : LevelButton

func _ready() -> void:
	Global.levelChanged.connect(whenLeaderboardChanges)

func whenLeaderboardChanges():
	levelButton.levelIcon.texture = Global.currentLevel.levelImage
	levelButton.levelLabel.text = Global.currentLevel.levelName


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(Global.currentLevel.levelScene)
