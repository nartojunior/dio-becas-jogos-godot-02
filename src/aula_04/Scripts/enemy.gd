class_name Enemy
extends CharacterBody2D

@export var health: int = 10
@export var attack_damage: int = 2
@export_range(0.0, 3.0) var time_blink: float = 0.5

@export var death_prefab: PackedScene
@export var damage_digit_prefab: PackedScene

@onready var marker_digit_ui = $MarkerDigitUi

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage_digit_prefab = preload("res://Prefabs/UI/damage_digit_ui.tscn")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass


func damage(amount:int) -> void:
	health -= amount
	
	blink_damage()	
	
	popup_digit(amount)
	
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

func popup_digit(amount: int):
	var damage_digit: DamageDigit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	if marker_digit_ui:
		damage_digit.global_position = marker_digit_ui.global_position
	else:
		damage_digit.global_position = self.global_position
		pass
	get_parent().add_child(damage_digit)
	pass

func blink_damage():
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, time_blink)
	pass
