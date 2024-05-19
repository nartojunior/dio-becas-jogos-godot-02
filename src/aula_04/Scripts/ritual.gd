extends Node2D

@export var damage_amount: int  = 4
@export var count_cicles: int = 5
@export var frequence: float = 1.0

@onready var area_2d = $Area2D

var actual_cicle = 0;
var cooldawn_damage_elapsed: float = 0.0

var player: Player

func set_player(player: Player):
	self.player = player
	pass 

func _process(delta:float) -> void:
	if actual_cicle < count_cicles:
		cooldawn_damage_elapsed += delta	
		if cooldawn_damage_elapsed >= frequence:
			actual_cicle += 1
			cooldawn_damage_elapsed = 0.0 
			deal_damage()
	else:
		if player:
			player.can_upate_ritual = true
			queue_free()
		pass
	pass

func deal_damage():
	var bodies = area_2d.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			enemy.damage(damage_amount)
			pass
	pass
