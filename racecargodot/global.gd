extends Node

signal levelChanged
signal finished

@export var checkpointNum : int = 0

var currentTime : float
var isFinished : bool = false : set = onFinished

var currentLevel : Level : set = onLevelChange
var nickname : String = "No name"

func onFinished(data : bool):
	isFinished = data
	finished.emit()

func onLevelChange(level : Level):
	currentLevel = level
	levelChanged.emit()

func logScore(score : float):
	var success: bool = await Leaderboards.post_guest_score(currentLevel.leaderboardID, score, nickname)
