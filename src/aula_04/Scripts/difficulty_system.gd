extends Node

@export var mob_spawner:MobSpawner
@export var initial_spawn_rate: float = 60.0
@export var spawn_rate_per_minutes: float = 30.0
@export var wave_duration: float = 20.0
@export var break_intensity: float = 0.5

var time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.game_over: return
	
	time += delta
	# dificuldade linear
	var spawn_rate = initial_spawn_rate + spawn_rate_per_minutes * (time / 60.0)
	
	# sistema de ondas
	var sin_wave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sin_wave, -1.0, 1.0, break_intensity, 1.0)
	spawn_rate *= wave_factor
	mob_spawner.mobs_per_minute = spawn_rate
	pass
