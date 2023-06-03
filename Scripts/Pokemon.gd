extends Node

# TODO: Change moves from res to a moves[] on this class


class_name Pokemon

var res: PokemonRes
var level: int
var hp: int
var max_hp:int
var pps = [0, 0, 0, 0]

func _init(res, level):
		self.res = res
		self.level = level
		self.max_hp = floor((res.health * level)/100) + 10
		self.hp = max_hp
		
		for i in range(0, len(self.res.moves)):
			pps[i] = self.res.moves[i].max_pp
