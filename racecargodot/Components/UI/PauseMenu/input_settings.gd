extends PanelContainer

@export var inputButtonScene : PackedScene
@export var actionList : VBoxContainer

var isRemapping : bool = false
var actionToRemap = null
var remappingButton = null

var inputActions = { #TODO: This is where the keybindings for the keybinding menu is (Add new input actions here)
	"pause" : "Pause Game",
	"steer_left" : "Steer Left",
	"steer_right" : "Steer Right",
	"accelerate" : "Accelerate",
	"reverse" : "Brake/Reverse",
	"drift" : "Drift",
	"boost" : "Boost"
}

func _ready():
	createActionList()

func createActionList():
	InputMap.load_from_project_settings()
	for item in actionList.get_children():
		item.queue_free()
	
	for action in inputActions:
		var button : Button = inputButtonScene.instantiate()
		var actionLabel : Label = button.find_child("ActionLabel")
		var labelInput : Label = button.find_child("LabelInput")
		
		actionLabel.text = inputActions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			labelInput.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			labelInput.text = ""
		
		actionList.add_child(button)
		button.pressed.connect(onInputButtonPressed.bind(button, action))

func onInputButtonPressed(button, action):
	if not isRemapping:
		isRemapping = true
		actionToRemap = action
		remappingButton = button
		button.find_child("LabelInput").text = "Press key to bind..."

func _input(event):
	if isRemapping:
		if (
			event is InputEventKey or 
			(event is InputEventMouseButton and event.pressed)
		):
			#Turn Double Click to Single Click
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			
			InputMap.action_erase_events(actionToRemap)
			InputMap.action_add_event(actionToRemap, event)
			updateActionList(remappingButton, event)
			
			isRemapping = false
			actionToRemap = null
			remappingButton = null
			
			ControllerIcons.input_type_changed.emit(ControllerIcons.InputType.KEYBOARD_MOUSE)
			accept_event()

func updateActionList(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")

func _on_reset_button_pressed():
	createActionList()
