extends CharacterBody2D
class_name Player

@onready var _animated_sprite = $AnimatedSprite2D
const gravity: int = 980
var jumpTimer: Timer = Timer.new() # Amount of time that jump can accelarate upwards for
var coyoteTimer: Timer = Timer.new()
const terminalVelocityNormal = 2000
const terminalVelocityRegrab = 2000 #These are the same for now idk if I want to keep it
var wasOnFloor: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	jumpTimer.autostart = false
	jumpTimer.one_shot = true
	jumpTimer.wait_time = 0.2
	add_child(jumpTimer)
	coyoteTimer.autostart = false
	coyoteTimer.one_shot = true
	coyoteTimer.wait_time = 0.1
	add_child(coyoteTimer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var x = velocity.x
	var y = velocity.y
	#gravity
	var terminalVelocity
	if Input.is_action_pressed("jump"):
		terminalVelocity = terminalVelocityRegrab
	else:
		terminalVelocity = terminalVelocityNormal
	y = min(y + 98, terminalVelocity)
	if Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
		if is_on_floor():
			if x > 0:
				x = 0
			x = max(x - 100, -1000)
		else:
			x = max(x - 50, -1000)
	elif Input.is_action_pressed("right") and !Input.is_action_pressed("left"):
		if is_on_floor():
			if x < 0:
				x = 0
			x = min(x + 100, 1000)
		else:
			x = min(x + 50, 1000)
	elif is_on_floor():
		#friction
		x = x * 0.75
		#Friction has easing, but if we're going slow enough, just stop.
		if abs(x) < 80:
			x = 0
	if (Input.is_action_just_pressed("jump") and (is_on_floor() or !coyoteTimer.is_stopped())):
		jumpTimer.start()
		y = -2000
	elif Input.is_action_just_released("jump"):
		jumpTimer.stop()
	if jumpTimer.is_stopped():
		if y < -628:
			y = -628
	set_velocity(Vector2(x, y))
	move_and_slide()
	if is_on_floor():
		jumpTimer.stop()
		wasOnFloor = true
	elif wasOnFloor and !Input.is_action_just_pressed("jump"):
		coyoteTimer.start()
		wasOnFloor = false
