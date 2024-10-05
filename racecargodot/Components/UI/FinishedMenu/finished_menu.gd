extends CanvasLayer


@export var timeLabel : Label
@export var mainMenuScene : PackedScene

func _ready() -> void:
	Global.finished.connect(onFinished)

func _on_visibility_changed() -> void:
	if visible:
		timeLabel.text = setTime()

func setTime() -> String:
	var time : float = Global.currentTime
	
	var mils = fmod(time,1)*100
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60) / 60
	
	var time_passed : String
	
	if mils == 0:
		time_passed = "%02d : %02d : 00" % [mins,secs]
	else:
		time_passed = "%02d : %02d : %02d" % [mins,secs,mils]
	
	if mins < 1:
		time_passed = time_passed.right(-4)
	
	return time_passed

func onFinished():
	show()

func _on_try_again_pressed() -> void:
	get_tree().reload_current_scene()


func _on_back_to_menu_pressed() -> void:
	Global.isFinished = false
	Global.checkpointNum = 0
	get_tree().change_scene_to_packed(mainMenuScene)
