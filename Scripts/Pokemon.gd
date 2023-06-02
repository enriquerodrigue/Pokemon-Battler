extends Node

class_name Pokemon

@export var res: PokemonRes
@export var level: int
@export var hp: int
@export var max_hp:int

func _init(res, level):
		self.res = res
		self.level = level
		self.max_hp = floor((res.health * level)/100) + 10
		self.hp = max_hp
