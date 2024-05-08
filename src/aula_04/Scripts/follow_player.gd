extends Node

@export var speed = 1.0
@onready var sprite: AnimatedSprite2D

var enemy:CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	var player_position =  GameManager.position
	var direction = (player_position - enemy.position).normalized()
	enemy.velocity  = direction * speed * 100
	
	enemy.move_and_slide()
	
	if direction.x >= 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	pass
