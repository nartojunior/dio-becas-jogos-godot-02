class_name Enemy
extends CharacterBody2D

@export var health: int = 10
@export var attack_damage: int = 2
@export_range(0.0, 3.0) var time_blink: float = 0.5

@export var death_prefab: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass


func damage(ammount:int) -> void:
	health -= ammount
	
	blink_damage()	
	
	if (health <=0):
		die()
	pass


func die()->void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		pass

	queue_free()

	pass


func blink_damage():
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, time_blink)
	pass
