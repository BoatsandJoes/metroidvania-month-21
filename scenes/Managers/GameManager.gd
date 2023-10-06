extends Node2D
class_name GameManager

const Player = preload("res://scenes/Actors/Player/Player.tscn")
var player: Player
const Room = preload("res://scenes/Map/Rooms/Room.tscn")
var room: Room

# Called when the node enters the scene tree for the first time.
func _ready():
	player = Player.instantiate()
	player.position = Vector2(300, 300)
	add_child(player)
	room = Room.instantiate()
	loadRoom(room)

func loadRoom(room):
	if self.room != null:
		remove_child(self.room)
	self.room = room
	add_child(room)
	setCameraParameters()
	#todo update player.position

func setCameraParameters():
	player.setCameraParameters(room)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
