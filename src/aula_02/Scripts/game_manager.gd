extends Node

@export var box_templates: Array[PackedScene]
@export var box_template: PackedScene

func _input(event):
	# Check mouse button left click
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				spawn_box(event.position)
	pass
	
	
func spawn_box(position: Vector2) -> void:
	var index = randi_range(0,1)
	var tmpBox = box_templates[index]
	var newBox = tmpBox.instantiate()
	newBox.position = position
	add_child(newBox)
	pass 
