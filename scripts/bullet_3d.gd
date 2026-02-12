extends Area3D

const SPEED = 30.0
const RANGE = 40.0

var travelled_distance = 0.0

func _physics_process(delta):
	# bullet currently passes through CSGBox platforms, would like them to queue_free when they collide
	
	var deltaSPEED = SPEED * delta
	
	position += -transform.basis.z * deltaSPEED
	travelled_distance += deltaSPEED
	if travelled_distance > RANGE:
		queue_free()
