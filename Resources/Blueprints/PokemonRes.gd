extends Resource

class_name PokemonRes


@export var name: String
#stats
@export var health: int
@export var attack: int
@export var defense: int
@export var sp_attack: int
@export var sp_defense: int
@export var speed: int

@export var moves = []

@export var type1: Global.type
@export var type2: Global.type
#sprite
@export var sprite_front: Texture
@export var sprite_back: Texture
