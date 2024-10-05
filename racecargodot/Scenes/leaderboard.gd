extends Control
class_name LeaderboardMenu

@export var levelButton : LevelButton

func _ready() -> void:
	Global.levelChanged.connect(whenLeaderboardChanges)

func whenLeaderboardChanges():
	levelButton.levelIcon.texture = Global.currentLevel.levelImage
	levelButton.levelLabel.text = Global.currentLevel.levelName


func _on_start_button_pressed() -> void:
	Global.nickname = "Dumb"
	Global.logScore(23.3)
