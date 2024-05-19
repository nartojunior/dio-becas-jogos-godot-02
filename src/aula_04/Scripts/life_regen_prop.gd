extends Node2D

@export var regen_amount: int = 10
@onready var area_2d: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	
	pass # Replace with function body.

func on_body_entered(body: Node2D):
	print(body)
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regen_amount)
		print("Regen player: ", player.health)
		GameManager.collect_meat.emit()
		queue_free()
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
