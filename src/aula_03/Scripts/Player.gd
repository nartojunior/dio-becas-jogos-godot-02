extends CharacterBody2D

@export var speed = 3.0
@export var move_degrees = 30
@export_range(0, 1) var lerp_factor_move = 0.1
@export_range(0, 1) var lerp_factor_rotation = 0.1

@onready var ship_green_manned = %ShipGreenManned


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	'''
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	'''

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#velocity.x = direction * speed * delta
	var target_velocity = direction * speed * 100
	velocity = lerp(velocity, target_velocity, lerp_factor_move)
	
	move_and_slide()
	
	var target_rotation = direction.x * move_degrees
	ship_green_manned.rotation_degrees = lerp(ship_green_manned.rotation_degrees, target_rotation, lerp_factor_rotation)
