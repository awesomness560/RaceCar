extends Area2D
class_name Road

@export var speedIncrease : float = 2600 ##The amount of extra speed that gets applied when you go on the road

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.engine_power += speedIncrease
		body.boostSpeed += 3000
		body.driftSpeedPenalty += 800


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.engine_power -= speedIncrease
		body.boostSpeed -= 3000
		body.driftSpeedPenalty -= 800
