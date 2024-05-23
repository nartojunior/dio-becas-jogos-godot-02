extends Node

var position:Vector2

var game_over: bool = false
var meat_amount_collected: int = 0
var mobs_defeated: int = 0

@export var max_mobs_count = 500

signal collect_meat
signal game_over_handler


# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	collect_meat.connect(on_eat_meal)	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_eat_meal():
	meat_amount_collected += 1
	pass

func end_game():
	game_over = true
	print("End Game")
	game_over_handler.emit()
	pass
	
func reset():
	position = Vector2.ZERO
	game_over = false
	meat_amount_collected = 0
		
	for conn in game_over_handler.get_connections():
		game_over_handler.disconnect(conn.callable)
		pass
	pass


