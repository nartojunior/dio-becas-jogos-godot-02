extends CharacterBody2D

@export var speed: float = 10
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $WarriorBlue

var is_running: bool = false
var is_attacking: bool = false
var is_attack_1: bool = true
var is_moving_right = true;
var attack_cooldown: float = 2.0

func _ready():
	animation_player.play("idle")
	pass

func _process(delta: float) -> void:
	update_cooldown(delta)		
	pass

func update_cooldown(delta:float)->void:
	attack_cooldown -= delta

	if attack_cooldown <= 0:
		is_attacking = false
		pass		
	pass

func _physics_process(delta: float) -> void:
	read_input(delta)
	
	if is_attacking == false:
		if is_running:
			animation_player.play("run")
		else:
			animation_player.play("idle")

	pass

func read_input(delta:float) -> void:

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
		pass

	if input_vector.x < 0:
		is_moving_right = false
		fix_sprite_direction()
		pass
			
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

	if is_attack_1:
		attack_label = "attack_side_1"
	else:
		attack_label = "attack_side_2"

	animation_player.play(attack_label)
	attack_cooldown = animation_player.get_animation(attack_label).length

	is_attack_1 = !is_attack_1
	is_attacking = true

	pass
