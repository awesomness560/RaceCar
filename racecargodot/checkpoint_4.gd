extends Area2D

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if Global.checkpointNum == 3:
			Global.checkpointNum += 1
			print(Global.checkpointNum)
