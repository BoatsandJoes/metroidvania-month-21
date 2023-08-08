extends Node
class_name Main

const GameManager = preload("res://scenes/Managers/GameManager.tscn")
var gameManager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready():
	gameManager = GameManager.instantiate()
	add_child(gameManager)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
