extends CanvasLayer

@export var player_pokemon = Pokemon.new(load("res://Resources/Pokemon/Mudkip.tres"),10)
@export var enemy_pokemon = Pokemon.new(load("res://Resources/Pokemon/Poochyena.tres"),10)

func _ready():
	#player
	$PlayerSprite.texture = player_pokemon.res.sprite_back
	$PlayerBox/PlayerName.text = player_pokemon.res.name
	$PlayerBox/PlayerHealth.text = str(player_pokemon.hp) \
	+ "/" + str(player_pokemon.max_hp) + "HP"
	
	#enemy
	$EnemySprite.texture = enemy_pokemon.res.sprite_front
	$EnemyBox/EnemyName.text = enemy_pokemon.res.name
	$EnemyBox/EnemyHealth.text = str(enemy_pokemon.hp) + \
	"/" + str(enemy_pokemon.max_hp) + "HP"
	
	#actionbox
	$ActionBox/ActionLabel.text = str("A wild ", enemy_pokemon.res.name, " has appeared!")
	
func _on_animation_player_animation_finished(anim_name):
	if $ActionBox/ActionButtons.visible == false:
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
		if not player_pokemon.res.moves[move_index] == null:
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
	if not player_pokemon.res.moves[extra_arg_0] == null:
		$ActionBox/MoveButtons/MoveDetails.text \
		= "Type/" + Global.type.keys()[player_pokemon.res.moves[extra_arg_0].type]
