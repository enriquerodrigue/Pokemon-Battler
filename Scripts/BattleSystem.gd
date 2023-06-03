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
	setup_player_hud()
	setup_enemy_hud()
	setup_action_box()
	
	
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
	state = states.PLAYER
	if $ActionBox/ActionButtons.visible == false and not $ActionBox/ActionLabel.text == str("What will ", player_pokemon.res.name, " do?"):
		$ActionBox/Timer.start()


func _on_timer_timeout():
	$ActionBox/ActionLabel.text = str("What will ", player_pokemon.res.name, " do?")
	$ActionBox/ActionLabel/AnimationPlayer.play("Type")
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
