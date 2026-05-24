extends Node2D

@onready var electricity_resource_icon = $control/hbox/electricity_resource
@onready var water_resource_icon = $control/hbox/water_resource
@onready var nutrient_resource_icon = $control/hbox/nutrient_resource
@onready var light_resource_icon = $control/hbox/light_resource
 
var coords : Vector2i = Vector2i.ZERO

func custom_init(coordinates : Vector2i):
	coords = coordinates
	

func update_resource_icons(icon_resources : Array[Constants.resource]):
	electricity_resource_icon.visible = false
	water_resource_icon.visible = false
	nutrient_resource_icon.visible = false
	light_resource_icon.visible = false
	for resource in icon_resources:
		match resource:
			Constants.resource.electricity:
				electricity_resource_icon.visible = true
			Constants.resource.water: 
				water_resource_icon.visible = true
			Constants.resource.nutrients:
				nutrient_resource_icon.visible = true
			Constants.resource.light: 
				light_resource_icon.visible = true
