extends Node

class_name card_data

@export var title : String
@export var description: String
@export var coords : Vector2
@export var resource : Constants.resource
@export var when_receiving_input : Dictionary

func _init(_title: String, _description: String, _coords: Vector2, _resource: Constants.resource, _receiving_input: Dictionary = {}):
	title = _title
	description = _description
	coords = _coords
	resource = _resource
	when_receiving_input = _receiving_input
