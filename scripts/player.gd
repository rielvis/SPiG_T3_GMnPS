extends CharacterBody3D

var horizontalLookSpeed = 0.2
var verticalLookSpeed = 0.2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * horizontalLookSpeed
		%Camera3D.rotation_degrees.x -= event.relative.y * verticalLookSpeed
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -75.00, 75.00)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	const SPEED = 5.5
	var GRAVITY = 20.0 * delta
	
	# Walking
	var input_direction_2D = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var input_direction_3D = Vector3(input_direction_2D.x, 0.0, input_direction_2D.y)
	var direction = transform.basis * input_direction_3D
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	# Gravity
	velocity.y -= GRAVITY
	
	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = 10.0
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0 # jump-cutting feels too sharp, I want to smooth it...
	
	move_and_slide()
	
	
