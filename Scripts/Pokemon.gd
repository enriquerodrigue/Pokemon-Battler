extends Node

# TODO: Change moves from res to a moves[] on this class
class_name Pokemon

var res: PokemonRes
var level: int
var hp: int
var max_hp:	int
var pps = [0, 0, 0, 0]
var attack: int
var defense: int
var sp_attack: int
var sp_defense: int

func _init(res, level):
		self.res = res
		self.level = level
		self.max_hp = floor((res.health * level)/100) + 10
		self.hp = max_hp
		
		for i in range(0, len(self.res.moves)):
			pps[i] = self.res.moves[i].max_pp

func calculate_attack():
	attack = floor((res.attack*level)/100) + 5
	return attack
	
func calculate_defense():
	defense = floor((res.defense*level)/100) + 5
	return defense

func calculate_sp_attack():
	sp_attack = floor((res.sp_attack*level)/100) + 5
	return sp_attack

func calculate_sp_defense():
	sp_defense = floor((res.sp_defense*level)/100) + 5
	return sp_defense

func take_damage(damage):
	hp -= damage
	if hp < 0:
		hp = 0
		
