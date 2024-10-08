extends CharacterBody2D
class_name Player

#TODO: Need to add a bar that will stop you from boosting when you run out of boost

var wheel_base = 70
@export var steering_angle = 15
@export var engine_power = 800 ##The speed at which you move forward
@export var friction = -0.9
var drag = -0.001
@export var braking = -450 ##The speed at which you move backward
@export var max_speed_reversed = 250 ##The speed limiter/penalty for moving backward
@export_group("Drift Settings")
@export var slip_speed = 400 ##The speed we need to be going for us to start sliding
@export var traction_fast = 0.1 ##The traction we have at high speeds
@export var traction_slow = 0.7
@export var whenDrifting = 0.01 ##The amount of traction we have while holding down the drift button
@export var driftSpeedPenalty : float = 200

@export_group("Boost Settings")
@export var boostSteeringAngle = 5 ##The limited steering angle when boosting
@export var boostSpeed = 2000 ##The amount of power that is applied when you accelerate while boosting
@export var boostZoom = 0.4
@export_subgroup("Nitro")
@export var maxNitro = 100 ##The max amount of nitro you can hold
@export var nitroGainRate : float = 10
@export var nitroLoseRate : float = 15

@export_group("References")
@export var driftParticles : GPUParticles2D
@export var boostParticles : GPUParticles2D
@export var camera : Camera2D
@export var nitroBar : NitroBar
@export var hud : CanvasLayer

var acceleration = Vector2.ZERO
var steer_direction
var currentNitro : float = 100

var currentSpeedPenalty : float = 0

var originalCameraZoom : Vector2
var cameraTween : Tween

var isDrifting : bool = false
var isBoosting : bool = false
var canBoost : bool = true

func _ready() -> void:
	originalCameraZoom = camera.zoom
	nitroBar.initNitro(maxNitro)
	Global.finished.connect(onFinish)

func _physics_process(delta : float) -> void:
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	toggleEffects(delta)
	velocity += acceleration * delta
	move_and_slide()

func get_input():
	canBoost = nitroBar.nitro > 0
	
	isBoosting = Input.is_action_pressed("boost") and canBoost
	
	var turn = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
	steer_direction = turn * deg_to_rad(steering_angle)
	if isBoosting:
		steer_direction = turn * deg_to_rad(boostSteeringAngle)
	
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * (engine_power - currentSpeedPenalty)
		
		if isBoosting:
			acceleration = transform.x * boostSpeed
	if Input.is_action_pressed("reverse"):
		acceleration = transform.x * braking
	
	isDrifting = Input.is_action_pressed("drift")

func toggleEffects(delta : float):
	driftParticles.emitting = isDrifting
	boostParticles.emitting = isBoosting
	
	if isDrifting and not isBoosting:
		nitroBar.nitro += delta * nitroGainRate
	
	if isBoosting:
		setCameraZoom(boostZoom)
		nitroBar.nitro -= delta * nitroLoseRate
	elif not isBoosting and camera.zoom != originalCameraZoom:
		setCameraZoom(originalCameraZoom.x)

func setCameraZoom(zoom : float) -> void:
	if cameraTween:
		cameraTween.kill()
	
	cameraTween = create_tween()
	cameraTween.tween_property(camera, "zoom", Vector2(zoom, zoom), 0.2)

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	
	if velocity.length() > slip_speed:
		traction = traction_fast
	if isDrifting:
		traction = whenDrifting
		currentSpeedPenalty = driftSpeedPenalty
	else:
		currentSpeedPenalty = 0
	
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.lerp(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reversed)
	rotation = new_heading.angle()
	
func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force

func onFinish():
	hud.hide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("road"):
		engine_power = 1600
		boostSpeed = 4000
		braking = -900
		max_speed_reversed = 500
		
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("road"):
		engine_power = 800
		boostSpeed = 2500
		braking = -450
		max_speed_reversed = 250
