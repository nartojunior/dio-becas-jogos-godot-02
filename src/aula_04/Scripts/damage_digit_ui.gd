class_name DamageDigit

extends Node2D

var value: int = 0

@onready var label: Label = %Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = str(value)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
