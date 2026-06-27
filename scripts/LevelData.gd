class_name LevelData extends Node

@export var level_id : int
@export var tiles := [LevelTile]

func _init(_id: int, _tiles:Array):
	level_id = _id
	tiles = _tiles
