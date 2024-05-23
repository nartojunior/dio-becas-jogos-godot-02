extends Node2D

@export var game_ui: GameUI
@export var game_over_ui_template: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.game_over_handler.connect(trigger_game_over)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func trigger_game_over():
	var time: String
	if game_ui:
		time = game_ui.timer_label.text
		game_ui.queue_free()
		game_ui = null
		pass
	
	if game_over_ui_template:
		var game_over_ui: GameOverUI = game_over_ui_template.instantiate()		
		game_over_ui.setup(time)
		add_child(game_over_ui)
		pass
	pass
