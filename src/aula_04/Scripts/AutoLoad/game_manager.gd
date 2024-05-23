extends Node

var position:Vector2
var game_over: bool = false
var meat_amount_collected: int = 0
@export var max_mobs_count = 500

signal collect_meat

# Called when the node enters the scene tree for the first time.
func _ready():
	collect_meat.connect(on_eat_meal)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_eat_meal():
	meat_amount_collected += 1
	pass
	

