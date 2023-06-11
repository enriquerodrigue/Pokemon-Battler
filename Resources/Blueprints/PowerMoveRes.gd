extends MovesRes

class_name PowerMoveRes

enum categories{
	PHYSICAL,
	SPECIAL
}

@export var power: int
@export var category: categories


func execute(target: Pokemon, attacker: Pokemon):
	super(target, attacker)
	var damage = calculate_damage(target, attacker)
	target.take_damage(calculate_damage(target, attacker))
	
	
func calculate_damage(target: Pokemon, attacker: Pokemon):
	var attack
	var defense
	if category == categories.PHYSICAL:
		attack = attacker.calculate_attack()
		defense = target.calculate_defense()
	elif category == categories.SPECIAL:
		attack = attacker.calculate_sp_attack()
		defense = target.calculate_sp_defense()
	move_effectiveness = calculate_type_effectiveness(target)
	var damage = ((power * attack/defense)/10) * move_effectiveness
	return damage
	
func calculate_type_effectiveness(target: Pokemon):
	return Global.type_effectiveness[type][target.res.type1] * \
		Global.type_effectiveness[type][target.res.type2]
		

