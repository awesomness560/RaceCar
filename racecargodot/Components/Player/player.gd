extends CharacterBody2D


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

var acceleration = Vector2.ZERO
var steer_direction 
var isDrifting : bool = false

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()

func get_input():
	var turn = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
	steer_direction = turn * deg_to_rad(steering_angle)
	
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("reverse"):
		acceleration = transform.x * braking
	
	isDrifting = Input.is_action_pressed("drift")

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
