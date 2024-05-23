class_name Enemy
extends CharacterBody2D

@export_category("Status")
@export var health: int = 10
@export var attack_damage: int = 2
@export_range(0.0, 3.0) var time_blink: float = 0.5

@export_category("Drops")
@export var drop_chance: float = 1.0
@export var loot_table: Array[PackedScene]
@export var loot_chances: Array[float]

@export_category("Prefabs")
@export var death_prefab: PackedScene
@export var damage_digit_prefab: PackedScene

@onready var marker_digit_ui = $MarkerDigitUi

signal on_die

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage_digit_prefab = preload("res://Prefabs/UI/damage_digit_ui.tscn")
	self.z_index = -1
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
	
	loot()
	on_die.emit()
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
	
func loot() -> void:
	#verificr loot
	var chance = randf()
	print("Looting... ", chance)
	if chance <= drop_chance:
		var drop_item = loot_table[0].instantiate()
		drop_item.position = position
		get_parent().add_child(drop_item)
		pass
		
	var loot_item = get_random_loot_item().instantiate()	
	loot_item.position = position
	get_parent().add_child(loot_item)
	pass
	
func get_random_loot_item() -> PackedScene:
	if loot_table.size() == 1:
		return loot_table[0]
		
	# Cálculo de chance máxima
	var max_chance: float = 0.0
	for loot_chance in loot_chances:
		max_chance += loot_chance
		pass
		
	var random_value = randf() * max_chance
	
	var needle: float = 0.0
	
	for i in loot_table.size():
		var drop_item = loot_table[i]
		var drop_chance = loot_chances[i] if i < loot_chances.size() else 1
		
		if random_value <= drop_chance + needle:
			return loot_table[i]
		
		needle += drop_chance
		
			
	return loot_table[0]
