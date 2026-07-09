class_name InstantiatedTileData extends Node

@export var coords : Vector2i
@export var resources : Array[Constants.resource]
@export var dispensed := false

func has_resource(resource: Constants.resource) -> bool:
	return resources.has(resource)
