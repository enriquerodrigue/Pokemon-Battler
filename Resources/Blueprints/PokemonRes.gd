extends Resource

class_name PokemonRes

enum types {
	NONE,
	NORMAL,
	FIRE,
	WATER,
	GRASS
}

@export var name: String
#stats
@export var health: int
@export var attack: int
@export var defense: int
@export var sp_attack: int
@export var sp_defense: int
@export var speed: int

@export var type1 = types.NONE
@export var type2 = types.NONE
#sprite
@export var sprite_front: Texture
@export var sprite_back: Texture
