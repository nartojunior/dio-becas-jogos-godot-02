class_name GameUI

extends CanvasLayer

@onready var timer_label: Label = $TimerLabel
@onready var gold_label: Label = $Panel/GoldLabel
@onready var meat_label: Label = $Panel/MeatLabel

var time_elapsed: float = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.collect_meat.connect(update_meat_amount)
	update_meat_amount()
	print("vish")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !GameManager.game_over:
		time_elapsed += delta
		var in_seconds = int(time_elapsed) % 60
		var in_minutes = int(time_elapsed / 60)
		timer_label.text = "%02d:%02d" % [in_minutes, in_seconds]
	pass

func update_meat_amount():
	meat_label.text = str(GameManager.meat_amount_collected)
	pass
