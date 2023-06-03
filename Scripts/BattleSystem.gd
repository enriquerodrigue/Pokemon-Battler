extends CanvasLayer

var player_pokemon = Pokemon.new(load("res://Resources/Pokemon/Mudkip.tres"),8)
var enemy_pokemon = Pokemon.new(load("res://Resources/Pokemon/Poochyena.tres"),5)

enum states {
	START,
	PLAYER,
	STANDBY,
	ENEMY
}

var state = states.START

func _ready():
	state = states.START
	setup_player_hud()
	setup_enemy_hud()
	setup_action_box()
	$AudioStreamPlayer2D.play(0.3)
	
	
func setup_player_hud():
	$PlayerSprite.texture = player_pokemon.res.sprite_back
	$PlayerBox/PlayerName.text = player_pokemon.res.name
	$PlayerBox/PlayerHealth.text = str(player_pokemon.hp) \
	+ "/" + str(player_pokemon.max_hp) + "HP"
	$PlayerBox/PlayerLevel.text = str("Lv.", player_pokemon.level)
	
func setup_enemy_hud():
	$EnemySprite.texture = enemy_pokemon.res.sprite_front
	$EnemyBox/EnemyName.text = enemy_pokemon.res.name
	$EnemyBox/EnemyHealth.text = str(enemy_pokemon.hp) + \
	"/" + str(enemy_pokemon.max_hp) + "HP"
	$EnemyBox/EnemyLevel.text = str("Lv.", enemy_pokemon.level)
	
func setup_action_box():
	$ActionBox/ActionLabel.text = str("A wild ", enemy_pokemon.res.name, " has appeared!")

func _on_animation_player_animation_finished(anim_name):
	if $ActionBox/ActionButtons.visible == false and state == states.START:
		$ActionBox/Timer.start()
	elif state == states.STANDBY:
		$PlayerSprite/AnimationPlayer.play("Attack")

func _on_timer_timeout():
	state = states.PLAYER
	$ActionBox/ActionLabel.visible_ratio = 0
	$ActionBox/ActionLabel/AnimationPlayer.play("Type")
	$ActionBox/ActionLabel.text = str("What will ", player_pokemon.res.name, " do?")
	$ActionBox/ActionButtons.visible = true


func _on_run_pressed():
	get_tree().quit()

func _on_fight_pressed():
	$ActionBox/ActionButtons.visible = false
	$ActionBox/ActionLabel.visible = false
	$ActionBox/MoveButtons.visible = true
	var move_index = 0
	for button in $ActionBox/MoveButtons/Buttons.get_children():
		if move_index < len(player_pokemon.res.moves):
			button.text = str(player_pokemon.res.moves[move_index].move_name)
		else:
			button.text = "-"
			button.disabled = true
		move_index += 1

func _on_return_pressed():
	$ActionBox/ActionButtons.visible = true
	$ActionBox/ActionLabel.visible = true
	$ActionBox/MoveButtons.visible = false


func _on_move_mouse_entered(extra_arg_0):
	if extra_arg_0 < len(player_pokemon.res.moves):
		$ActionBox/MoveButtons/MoveDetails.visible = true
		$ActionBox/MoveButtons/MoveDetails.text \
		= "Type/" + \
		Global.type.keys()[player_pokemon.res.moves[extra_arg_0].type] \
		+ "\nPP: " + str(player_pokemon.pps[extra_arg_0]) + "/" + \
		str(player_pokemon.res.moves[extra_arg_0].max_pp)


func _on_move_pressed(extra_arg_0):
	state = states.STANDBY
	$ActionBox/ActionLabel.text = player_pokemon.res.name \
	+ " has used " + player_pokemon.res.moves[extra_arg_0].move_name + "!"
	$ActionBox/MoveButtons.visible = false
	$ActionBox/ActionLabel/AnimationPlayer.play("Type")
	$ActionBox/ActionLabel.visible = true
	handle_move(player_pokemon.res.moves[extra_arg_0])
	
	
func _on_player_animation_finished(anim_name):
	if anim_name == "Attack":
		$EnemySprite/AnimationPlayer.play("Hit")
		$PokemonCries.stream = enemy_pokemon.res.sound_cry
		$PokemonCries.play()
		
	elif anim_name == "enter_battle":
		$PokemonCries.stream = player_pokemon.res.sound_cry
		$PokemonCries.play()
	
func _on_enemy_animation_finished(anim_name):
	if anim_name == "Hit":
		$EnemyBox/EnemyHealth.text = str(enemy_pokemon.hp) + \
		"/" + str(enemy_pokemon.max_hp) + "HP"


func handle_move(move):
	if move.category == Global.category.STATUS:
		print("STATUS")
	elif move.category == Global.category.PHYSICAL:
		print("PHYSICAL")
		enemy_pokemon.take_damage(calculate_damage(move))
	elif move.category == Global.category.SPECIAL:
		print("SPECIAL")
		enemy_pokemon.take_damage(calculate_damage(move))

func calculate_damage(move):
	var attack
	var defense
	if move.category == Global.category.PHYSICAL:
		attack = player_pokemon.calculate_attack()
		defense = enemy_pokemon.calculate_defense()
	elif move.category == Global.category.SPECIAL:
		attack = player_pokemon.calculate_sp_attack()
		defense = enemy_pokemon.calculate_sp_defense()
		
	var damage = (move.power * attack/defense)/10
	return damage

