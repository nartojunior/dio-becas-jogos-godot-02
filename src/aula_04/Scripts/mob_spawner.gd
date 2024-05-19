extends Node2D

@export var mobs: Array[PackedScene]
@export var mobs_per_minute: int = 60

@onready var path_follow_2d = %PathFollow2D

var can_spawn: bool = true

var frequence_to_spawn: float
var cooldown_spawn_elapsed: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if (mobs_per_minute <= 0):
		can_spawn = false
	else:
		frequence_to_spawn = mobs_per_minute / 60
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.game_over:
		can_spawn = false
		pass
		
	cooldown_spawn(delta)
	pass

func cooldown_spawn(delta: float):
	if can_spawn:
		if frequence_to_spawn > 0:
			cooldown_spawn_elapsed += delta
			if cooldown_spawn_elapsed >= frequence_to_spawn:
				spawn_mob()
				cooldown_spawn_elapsed = 0
				pass
			pass
		pass
	pass

func spawn_mob():
	var index = randi_range(0, mobs.size() - 1)
	var mob_scene = mobs[index]
	var mob = mob_scene.instantiate()
	mob.global_position = get_point()
	get_parent().add_child(mob)
	pass

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
	pass
