class_name LevelData extends Node

@export var level_id : int
@export var title : String
@export var tiles := [LevelTile]

func _init(_id: int, _title: String, _tiles:Array):
	level_id = _id
	title = _title
	tiles = _tiles
