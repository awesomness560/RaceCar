extends Control

func _ready() -> void:
	Menu.menus.append("MainMenu")

func _on_play_button_pressed() -> void:
	GuiTransitions.go_to("LevelSelect")
	Menu.menus.append("LevelSelect")


func _on_settings_pressed() -> void:
	GuiTransitions.go_to("Settings")
	Menu.menus.append("Settings")


func _on_quit_game_pressed() -> void:
	get_tree().quit()
