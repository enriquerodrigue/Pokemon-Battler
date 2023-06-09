extends MovesRes
class_name StatusMoveRes

enum stats{
	ATTACK,
	DEFENSE,
	SPEED
}

enum alter_types{
	INCREASE,
	DECREASE
}

@export var stat_to_alter: stats
@export var boost_percentage: float
@export var alter_type: alter_types

#TODO: Fix having need to put attacker in this function
func execute(target: Pokemon, attacker: Pokemon):
	super(target, attacker)
	if alter_type == alter_types.DECREASE:
		match stat_to_alter:
			stats.ATTACK:
				target.attack -= target.attack * boost_percentage
				print("Decreased pokemon's attack")
			stats.DEFENSE:
				target.defense -= target.defense * boost_percentage
				print("Decreased pokemon's defense")
			#TODO: Add other stats
