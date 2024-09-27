extends Control

@export_category("References")
@export var buttonsMenu : VBoxContainer
@export var settingsMenu : Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		#Kind of messy code but should get the job done for now
		if visible and buttonsMenu.visible:
			setPauseState(false)
		elif visible and buttonsMenu.visible == false:
			settingsMenu.hide()
			buttonsMenu.show()
		else:
			setPauseState(true)

func setPauseState(pause : bool):
	if not pause: #If we are unpausing
		#Reset menus back to default state
		settingsMenu.hide()
		buttonsMenu.show()
	
	get_tree().paused = pause
	visible = pause

func _on_resume_pressed() -> void:
	setPauseState(false)


func _on_settings_pressed() -> void:
	settingsMenu.show()
	buttonsMenu.hide()
