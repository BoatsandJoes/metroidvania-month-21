extends CharacterBody2D
class_name Player

@onready var _animated_sprite = $AnimatedSprite2D
const gravity: int = 980
var jumpTimer: Timer = Timer.new() # Amount of time that jump can accelarate upwards for
var coyoteTimer: Timer = Timer.new()
const terminalVelocityNormal = 1500
const terminalVelocityRegrab = 1500 #These are the same for now idk if I want to keep it
var wasOnFloor: bool = false
var facingRight: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	face(true)
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

func setCameraParameters(room):
	$Camera2D.limit_bottom = room.cameraHeight
	$Camera2D.limit_right = room.cameraWidth

#Returns true if direction changed
func face(right: bool) -> bool:
	var result: bool = facingRight != right
	facingRight = right
	if facingRight:
		$AnimatedSprite2D.scale = Vector2(abs($AnimatedSprite2D.scale.x), $AnimatedSprite2D.scale.y)
		$FrontWallCheck.position = Vector2i($collisionBox.shape.get_rect().size.x / 2
		+ $FrontWallCheck/CollisionShape2D.shape.get_rect().size.x / 2 + 2, 0)
		$BackWallCheck.position = Vector2i(0 - $collisionBox.shape.get_rect().size.x / 2
		- $BackWallCheck/CollisionShape2D.shape.get_rect().size.x / 2 - 2, 0)
	else:
		$AnimatedSprite2D.scale = Vector2(0 - abs($AnimatedSprite2D.scale.x), $AnimatedSprite2D.scale.y)
		$FrontWallCheck.position = Vector2i(0 - $collisionBox.shape.get_rect().size.x / 2
		- $FrontWallCheck/CollisionShape2D.shape.get_rect().size.x / 2 - 2, 0)
		$BackWallCheck.position = Vector2i($collisionBox.shape.get_rect().size.x / 2
		+ $BackWallCheck/CollisionShape2D.shape.get_rect().size.x / 2 + 2, 0)
	return result

func _physics_process(delta):
	#todo going into the corner sometimes initiates a slow fall
	#todo running off the side you can't really turn around. Feels awkward
	var x = velocity.x
	var y = velocity.y
	var changedFacing: bool = false
	#gravity
	var terminalVelocity
	if Input.is_action_pressed("jump"):
		terminalVelocity = terminalVelocityRegrab
	else:
		terminalVelocity = terminalVelocityNormal
	y = min(y + 98, terminalVelocity)
	if Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
		if face(false):
			changedFacing = true
		if is_on_floor():
			if x > 0:
				x = 0
			x = max(x - 100, -1000)
		else:
			x = max(x - 25, -1000)
	elif Input.is_action_pressed("right") and !Input.is_action_pressed("left"):
		if face(true):
			changedFacing = true
		if is_on_floor():
			if x < 0:
				x = 0
			x = min(x + 100, 1000)
		else:
			x = min(x + 25, 1000)
	elif is_on_floor():
		#friction
		x = x * 0.6
		#Friction has easing, but if we're going slow enough, just stop.
		if abs(x) < 80:
			x = 0
	if (Input.is_action_just_pressed("jump") and (is_on_floor() or !coyoteTimer.is_stopped())):
		jumpTimer.start()
		y = -2000
	elif (Input.is_action_just_pressed("jump") && ($BackWallCheck.get_overlapping_bodies().size() > 0
	|| $FrontWallCheck.get_overlapping_bodies().size() > 0)):
		if (changedFacing ||
		(!Input.is_action_pressed("left") && !Input.is_action_pressed("right"))):
			#neutral
			jumpTimer.start()
			y = -2000
			if (($BackWallCheck.get_overlapping_bodies().size() > 0 && facingRight)
			|| ($FrontWallCheck.get_overlapping_bodies().size() > 0 && !facingRight)):
				x = 500
			else:
				x = -500
		elif $BackWallCheck.get_overlapping_bodies().size() > 0:
			#back
			jumpTimer.start()
			x = 0
			y = -2000
		else:
			#front
			jumpTimer.start()
			y = -1000
			if facingRight:
				x = -1300
			else:
				x = 1300
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
