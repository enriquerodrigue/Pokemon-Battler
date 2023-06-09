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

func execute(target: Pokemon, attacker: Pokemon):
	print(str(attacker.res.name, " used ", move_name, "!"))
