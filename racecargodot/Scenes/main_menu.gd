extends Control

var menus : Array[String]

func back():
	if menus.size() > 1:
		menus.pop_back()
		GuiTransitions.go_to(menus.back())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("back") and visible:
		back()
