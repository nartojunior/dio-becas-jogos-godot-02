extends Sprite2D

'''
@export serializa a variável para o Inspector
'''
@export var speed:float = 10.0


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Godot!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position.x = position.x + input.x * speed * delta
	position.y = position.y + input.y * speed * delta
	
	print()
	pass
