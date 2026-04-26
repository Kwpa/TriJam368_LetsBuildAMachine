extends Node

class_name card_data

@export var title : String
@export var description: String
@export var coords : Vector2
@export var resource : Constants.resource

func _init(_title: String, _description: String, _coords: Vector2, _resource: Constants.resource):
	title = _title
	description = _description
	coords = _coords
	resource = _resource
	
