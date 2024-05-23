class_name GameOverUI

extends CanvasLayer

@onready var time_survived_content_label = %TimeSurvivedContentLabel
@onready var monsters_defeated_content_label = %MonstersDefeatedContentLabel

@export var restart_delay: float = 5.0

var cooldown_restart: float = 0.0
var time_session: String = "00:00"

# Called when the node enters the scene tree for the first time.
func _ready():
	time_survived_content_label.text = time_session
	monsters_defeated_content_label.text = str(GameManager.mobs_defeated)
	cooldown_restart = restart_delay
	
	pass # Replace with function body.

func setup(time: String = "00:00") -> void:
	time_session = time
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cooldown_restart -= delta
	if cooldown_restart <= 0:
		# restart Scenes 
		reset_game()
	pass
	
func reset_game():
	print("resetando jogo")
	GameManager.reset()
	get_tree().reload_current_scene()
	pass 
