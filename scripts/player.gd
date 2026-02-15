extends CharacterBody3D

# Look Variables
var horizontalLookSpeed = 0.2
var verticalLookSpeed = 0.2

# Jump Variables
var jump_power = 10.0
var jump_divisor = 2.0
var double_jump

# Movement Variables
var moveSpeed = 5.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * horizontalLookSpeed
		%Camera3D.rotation_degrees.x -= event.relative.y * verticalLookSpeed
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -75.00, 75.00)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# would rather make esc just end the game directly for now

func _physics_process(delta):
	var GRAVITY = 20.0 * delta
	
	# Walking
	var input_direction_2D = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var input_direction_3D = Vector3(input_direction_2D.x, 0.0, input_direction_2D.y)
	var direction = transform.basis * input_direction_3D
	
	velocity.x = direction.x * moveSpeed
	velocity.z = direction.z * moveSpeed
	
	# Sprinting
	if Input.is_action_just_pressed("sprint") and is_on_floor():
		moveSpeed = 10.0
		print("Sprinting!")
	elif !Input.is_action_pressed("sprint") and is_on_floor():
		moveSpeed = 5.0
	#elif Input.is_action_just_released("sprint"):
		#moveSpeed = 5.0
		#print("walking...")
	
	# Gravity
	velocity.y -= GRAVITY
	
	# Grounding
	if is_on_floor():
		double_jump = true
	
	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	elif Input.is_action_just_pressed("jump") and double_jump == true:
		jump()
		double_jump = false
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = velocity.y / jump_divisor
	
	# Move Function Called
	move_and_slide()
	
	# Shooting
	if Input.is_action_pressed("shoot") and %Timer.is_stopped():
		shoot_bullet()
	
func shoot_bullet():
	const BULLET_3D = preload("res://scenes/bullet_3d.tscn")
	var new_bullet = BULLET_3D.instantiate()
	%Marker3D.add_child(new_bullet)
	
	new_bullet.global_transform = %Marker3D.global_transform
	
	%Timer.start()

func jump():
	velocity.y = jump_power
	
	
	
	
