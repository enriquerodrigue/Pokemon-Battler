extends CanvasLayer

@export var player_pokemon = Pokemon.new(load("res://Resources/Pokemon/Mudkip.tres"),10)
@export var enemy_pokemon = Pokemon.new(load("res://Resources/Pokemon/Poochyena.tres"),10)

func _ready():
	$PlayerSprite.texture = player_pokemon.res.sprite_back
	$EnemySprite.texture = enemy_pokemon.res.sprite_front
	$EnemyBox/EnemyName.text = enemy_pokemon.res.name
	$PlayerBox/PlayerName.text = player_pokemon.res.name
