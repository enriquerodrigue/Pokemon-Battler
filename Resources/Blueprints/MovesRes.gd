extends Resource

class_name MovesRes

enum targets {
	PLAYER,
	ENEMY
}

@export var move_name: String

@export var type: Global.type
@export var max_pp: int
@export_multiline var description: String
@export var accuracy: int
@export var target: targets
var move_effectiveness

func execute(target: Pokemon, attacker: Pokemon):
	print(str(attacker.res.name, " used ", move_name, "!"))
	
func determine_effectiveness_string():
	if self is StatusMoveRes:
		return ""
	
	if move_effectiveness > 1:
		return "It's super effective!"
	elif move_effectiveness == 1: 
		return ""
	else:
		return "It's not very effective!"
	

