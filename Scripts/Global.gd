extends Node

enum type {
	NONE,
	NORMAL,
	FIRE,
	WATER,
	GRASS
}

enum category {
	PHYSICAL,
	SPECIAL
}

var type_effectiveness = [
							[1,1,1,1,1], 		#NONE
							[1,1, 1, 1, 1],		#NORMAL
							[1,1,0.5,0.5,2],	#FIRE
							[1,1,2,0.5,0.5],	#WATER
							[1,1,0.5,2,0.5]]	#GRASS
