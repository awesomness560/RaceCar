extends Node2D
class_name FinishLine



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if Global.checkpointNum == 5:
			Global.isFinished = true
			Global.logScore(Global.currentTime)
