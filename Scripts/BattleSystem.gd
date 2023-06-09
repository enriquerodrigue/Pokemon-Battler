extends CanvasLayer

var player_pokemon = Pokemon.new(load("res://Resources/Pokemon/Mudkip.tres"),1)
var enemy_pokemon = Pokemon.new(load("res://Resources/Pokemon/Poochyena.tres"),10)

enum states {
	START,
	PLAYER,
	STANDBY,
	ENEMY,
	END
}

enum turns {
	PLAYER,
	ENEMY
}

var state = states.START
var turn
var loser_anim_player
var player_move
var moves_executed = [false, false]

func _ready():
	state = states.START
	setup_player_hud()
	setup_enemy_hud()
	setup_action_box()
	$BGMPlayer.play(0.3)
	
func setup_player_hud():
	$PlayerSprite.texture = player_pokemon.res.sprite_back
	$PlayerBox/PlayerName.text = player_pokemon.res.name
	update_ui_hp($PlayerBox/PlayerHealth, player_pokemon)
	$PlayerBox/PlayerLevel.text = str("Lv.", player_pokemon.level)
	
func setup_enemy_hud():
	$EnemySprite.texture = enemy_pokemon.res.sprite_front
	$EnemyBox/EnemyName.text = enemy_pokemon.res.name
	update_ui_hp($EnemyBox/EnemyHealth, enemy_pokemon)
	$EnemyBox/EnemyLevel.text = str("Lv.", enemy_pokemon.level)
	
func setup_action_box():
	type_on_action_label(str("A wild ", enemy_pokemon.res.name, " has appeared!"))

func _on_timer_timeout():
	handle_player_turn()

func handle_player_turn():
	state = states.PLAYER
	type_on_action_label(str("What will ", player_pokemon.res.name, " do?"))
	$ActionBox/ActionButtons.visible = true

func _on_run_pressed():
	get_tree().quit()

func _on_fight_pressed():
	setup_action_box_menus(false)
	var move_index = 0
	for button in $ActionBox/PlayerMoves/Buttons.get_children():
		if move_index < len(player_pokemon.res.moves):
			button.text = str(player_pokemon.res.moves[move_index].move_name)
		else:
			button.text = "-"
			button.disabled = true
		move_index += 1

func _on_return_pressed():
	setup_action_box_menus(false)

func _on_move_mouse_entered(extra_arg_0):
	if extra_arg_0 < len(player_pokemon.res.moves):
		$ActionBox/PlayerMoves/MoveDetails.visible = true
		$ActionBox/PlayerMoves/MoveDetails.text \
		= "Type/" + \
		Global.type.keys()[player_pokemon.res.moves[extra_arg_0].type] \
		+ "\nPP: " + str(player_pokemon.pps[extra_arg_0]) + "/" + \
		str(player_pokemon.res.moves[extra_arg_0].max_pp)


func _on_move_pressed(extra_arg_0):
	moves_executed = [false, false]
	player_move = player_pokemon.res.moves[extra_arg_0]
	handle_speed(player_pokemon, enemy_pokemon)
	
	
func _on_player_animation_finished(anim_name):
	if anim_name == "Attack":
		$EnemySprite/AnimationPlayer.play("Hit")
		$PokemonCries.stream = enemy_pokemon.res.sound_cry
		$PokemonCries.play()
		
	elif anim_name == "enter_battle":
		$PokemonCries.stream = player_pokemon.res.sound_cry
		$PokemonCries.play()
		
	elif anim_name == "Hit":
		update_ui_hp($PlayerBox/PlayerHealth, player_pokemon)
		check_if_pokemon_died(player_pokemon)
	
func _on_enemy_animation_finished(anim_name):
	if anim_name == "Hit":
		update_ui_hp($EnemyBox/EnemyHealth, enemy_pokemon)
		check_if_pokemon_died(enemy_pokemon)
	elif anim_name == "Attack":
		$PlayerSprite/AnimationPlayer.play("Hit")
		$PokemonCries.stream = player_pokemon.res.sound_cry
		$PokemonCries.play()

func handle_speed(player, enemy):
	state = states.STANDBY
	if player.calculate_speed() > enemy.calculate_speed():
		turn = turns.PLAYER
		moves_executed[0] = true
		change_ui_on_move(player_move, player_pokemon)
		handle_move(player_move, player, enemy)
	elif player.calculate_speed() < enemy.calculate_speed():
		handle_enemy_turn()
	else:
		if randf() > 0.5:
			handle_move(player_move, player, enemy)
		else:
			handle_enemy_turn()

#TODO: FIND BETTER WAY!!
func handle_move(move, attacker, defender):
	state = states.STANDBY
	if move.target == move.targets.PLAYER:
		move.execute(attacker, attacker)
	elif move.target == move.targets.ENEMY:
		move.execute(defender, attacker)
	

func handle_enemy_turn():
	state = states.ENEMY
	turn = turns.ENEMY
	moves_executed[1] = true
	var moves = enemy_pokemon.res.moves
	var move = moves[randi() % moves.size()]
	handle_move(move, enemy_pokemon, player_pokemon)
	change_ui_on_move(move, enemy_pokemon)
	
func change_ui_on_move(move, attacker):
	$ActionBox/PlayerMoves.visible = false
	type_on_action_label(attacker.res.name \
	+ " has used " + move.move_name + "!")
	$ActionBox/ActionLabel.visible = true
	
func check_if_pokemon_died(pokemon):
	if pokemon.hp <= 0:
		state = states.END
		type_on_action_label(str(pokemon.res.name, " has fainted!"))
		if pokemon == player_pokemon:
			loser_anim_player = $PlayerSprite/AnimationPlayer
		else:
			loser_anim_player = $EnemySprite/AnimationPlayer
	else:
		if turn == turns.PLAYER and moves_executed[1] == false:
			handle_enemy_turn()
		else:
			if moves_executed == [true,true]:
				handle_player_turn()
			else:
				handle_move(player_move, player_pokemon, enemy_pokemon)
				change_ui_on_move(player_move, player_pokemon)
				turn = turns.PLAYER
				moves_executed[0] = true

func _on_typing_animation_finished(anim_name):
	if $ActionBox/ActionButtons.visible == false and state == states.START:
		$ActionBox/Timer.start()
	elif state == states.STANDBY:
		if turn == turns.PLAYER:
			$PlayerSprite/AnimationPlayer.play("Attack")
		else:
			$EnemySprite/AnimationPlayer.play("Attack")
	elif state == states.END:
		loser_anim_player.play("Faint")
		
		
# UI 
func update_ui_hp(label, pokemon):
	label.text = str(pokemon.hp) \
	+ "/" + str(pokemon.max_hp) + "HP"
	
func type_on_action_label(text):
	$ActionBox/ActionLabel.visible_ratio = 0
	$ActionBox/ActionLabel/AnimationPlayer.play("Type")
	$ActionBox/ActionLabel.text = text
	
func setup_action_box_menus(boolVal):
	$ActionBox/ActionButtons.visible = boolVal
	$ActionBox/ActionLabel.visible = boolVal
	$ActionBox/PlayerMoves.visible = not boolVal
