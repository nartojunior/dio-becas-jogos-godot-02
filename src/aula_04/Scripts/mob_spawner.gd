class_name MobSpawner

extends Node2D

@export var mobs: Array[PackedScene]
@export var mobs_per_minute: float = 60.0

@onready var path_follow_2d = %PathFollow2D

var can_spawn: bool = true

var mobs_counter: int = 0

var frequence_to_spawn: float
var cooldown_spawn_elapsed: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if (mobs_per_minute <= 0):
		can_spawn = false
	else:
		frequence_to_spawn = 60.0 / mobs_per_minute #ToDo rever cálculo
		print("frequence: ", frequence_to_spawn)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.game_over:
		can_spawn = false
		pass
	else:	
		cooldown_spawn(delta)
	pass

func cooldown_spawn(delta: float):	
	if can_spawn:
		if frequence_to_spawn > 0:
			cooldown_spawn_elapsed += delta
			if cooldown_spawn_elapsed >= frequence_to_spawn:
				if (mobs_counter < GameManager.max_mobs_count):
					spawn_mob()
					cooldown_spawn_elapsed = 0
					pass
				pass
			pass
		pass
	pass

func spawn_mob():
	mobs_counter += 1
	var point = get_valid_point()
	var index = randi_range(0, mobs.size() - 1)
	var mob_scene = mobs[index]
	var mob = mob_scene.instantiate()
	mob.global_position = point
	mob.on_die.connect(mob_decrease)
	get_parent().add_child(mob)
	
	pass

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	var point = path_follow_2d.global_position

	return point

func get_valid_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	var point = path_follow_2d.global_position
	
	while check_valid_point(point):
		path_follow_2d.progress_ratio = randf()
		point = path_follow_2d.global_position
		pass
	
	#print("Spawn point: ", point)
	return point

func check_valid_point(point: Vector2) -> bool:
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1000
	var max_results = 1  
	var result: Array = world_state.intersect_point(parameters, max_results)
	
	return not result.is_empty()
	
func mob_decrease():
	print("Mob die... ", mobs_counter)
	mobs_counter -= 1
	GameManager.mobs_defeated += 1
	pass
