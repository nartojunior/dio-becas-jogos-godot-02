class_name Player
extends CharacterBody2D

@export_category("Combat")
@export var attack_damage: int = 2
@export var health_max: int = 100
@export var health: int = 100
@export_range(0.0, 3.0) var time_blink: float = 0.5

@export_category("Movement")
@export var speed: float = 10

@export_category("Prefabs")
@export var death_prefab: PackedScene
@export var ritual_prefab: PackedScene

@export_category("Ritual")
@export var cooldown_ritual: float = 5

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $WarriorBlue
@onready var attack_area: Area2D = $AttackArea
@onready var hitbox_area: Area2D = $HitBoxArea
@onready var progress_bar = $ProgressBar

var is_running: bool = false
var is_attacking: bool = false
var is_attack_1: bool = true
var is_moving_right: bool = true
var can_upate_ritual: bool = true
var can_create_ritual: bool = false

var attack_cooldown: float = 2.0
var ritual_cooldown_elapsed: float = 0.0
var hitbox_cooldown_elapsed: float = 0.0

var attack_direction: Vector2

func _ready():
	animation_player.play("idle")
	attack_direction = Vector2.RIGHT
	hitbox_cooldown_elapsed = 0
	pass
	
func create_ritual() -> void:
	var ritual = ritual_prefab.instantiate()
	ritual.set_player(self)
	add_child(ritual)
	print("Ritual Z: ", ritual)
	pass

func _process(delta: float) -> void:
	GameManager.position = position
	update_cooldown(delta)
	update_hitbox_detection(delta)
	update_ritual(delta)
	update_ui()
	pass

func update_cooldown(delta: float) -> void:
	attack_cooldown -= delta
	
	if attack_cooldown <= 0:
		is_attacking = false
		pass
	pass
	
func update_ritual(delta: float) -> void:
	if can_create_ritual:
		can_create_ritual = false
		create_ritual()		
		pass
			
	if can_upate_ritual:
		ritual_cooldown_elapsed += delta
		
		if (ritual_cooldown_elapsed >= cooldown_ritual):
			ritual_cooldown_elapsed = 0.0
			can_upate_ritual = false
			can_create_ritual = true
			pass
	pass
	
func update_ui() -> void:
	progress_bar.value = health
	progress_bar.max_value = health_max
	pass

func _physics_process(delta: float) -> void:
	read_input(delta)
	
	if is_attacking == false:
		if is_running:
			animation_player.play("run")
		else:
			animation_player.play("idle")

	pass

func read_input(delta: float) -> void:

	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_vector.x == 0 and input_vector.y == 0:
		is_running = false
	else:
		is_running = true
		
	var target_velocity = input_vector * speed * delta * 2000
	
	if is_attacking:
		target_velocity *= 0.05

	velocity = lerp(velocity, target_velocity, 0.5)
	
	if input_vector.x > 0:
		is_moving_right = true
		fix_sprite_direction()
		attack_direction = Vector2.RIGHT
		pass

	if input_vector.x < 0:
		is_moving_right = false
		fix_sprite_direction()
		attack_direction = Vector2.LEFT
		pass

	if input_vector.y > 0:
		attack_direction = Vector2.DOWN

	if input_vector.y < 0:
		attack_direction = Vector2.UP
	
	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		attack()

	pass

func fix_sprite_direction():
	if is_attacking == false:
		sprite.flip_h = !is_moving_right

func attack() -> void:
	if is_attacking:
		return

	# adjust attack animation
	var attack_label: String

	match attack_direction:
		Vector2.UP:
			attack_label = "attack_up_"
		Vector2.DOWN:
			attack_label = "attack_down_"
		_:
			attack_label = "attack_side_"

	if is_attack_1:
		attack_label += "1"
	else:
		attack_label += "2"

	animation_player.play(attack_label)
	attack_cooldown = animation_player.get_animation(attack_label).length
	is_attack_1 = !is_attack_1
	is_attacking = true

	pass

func deal_damage_to_enemies():
	var corpses = attack_area.get_overlapping_bodies()
	for corpse in corpses:
		if corpse.is_in_group("enemies"):
			var enemy: Enemy = corpse
			var direction_to_enemy = (enemy.position - position).normalized()
			'''
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			'''
			var dot_product = direction_to_enemy.dot(attack_direction)

			if dot_product >= 0.3:
				enemy.damage(attack_damage)
				pass
			pass
		pass
	pass

func damage(ammount: int) -> void:
	if health <= 0: return
	
	health -= ammount
		
	blink_damage()
	
	if (health <= 0):
		die()
	pass

func die() -> void:
	GameManager.end_game()
	
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		pass
	queue_free()
	pass

func heal(amount: int) -> void:
	health += amount
	
	if health > health_max:
		health = health_max
		pass
	pass

func blink_damage():
	sprite.modulate = Color.BLUE
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self.sprite, "modulate", Color.WHITE, time_blink)
	pass
	
func update_hitbox_detection(delta: float) -> void:
	hitbox_cooldown_elapsed += delta

	if (hitbox_cooldown_elapsed <= time_blink):
		return
	else:
		hitbox_cooldown_elapsed = 0
	
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			damage(enemy.attack_damage)
		pass
	pass
