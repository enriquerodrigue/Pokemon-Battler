extends Node

class_name Pokemon

@export var res: PokemonRes
@export var level: int

func _init(res, level):
		self.res = res
		self.level = level
