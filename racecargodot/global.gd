extends Node

signal levelChanged

@export var checkpointNum : int = 0

var currentLevel : Level : set = onLevelChange
var nickname : String = "No name"

func onLevelChange(level : Level):
	currentLevel = level
	levelChanged.emit()

func logScore(score : float):
	var success: bool = await Leaderboards.post_guest_score(currentLevel.leaderboardID, score, nickname, {"level" : currentLevel.levelName})
