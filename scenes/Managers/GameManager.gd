extends Node2D
class_name GameManager

const Player = preload("res://scenes/Actors/Player/Player.tscn")
var player: Player
const Room = preload("res://scenes/Map/Rooms/Room.tscn")
var room: Room

# Called when the node enters the scene tree for the first time.
func _ready():
	room = Room.instantiate()
	add_child(room)
	player = Player.instantiate()
	player.position = Vector2(300, 300)
	add_child(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
