class_name Card
extends Node2D

# tile set
@export var tile_set:TileSet = load("res://scenes/machine_tileset.tres")

# coords of tile within tileset
@export var tile_coords:Vector2i = Vector2i(1,1)

# tile description
@export var tile_type:String = 'This is the description of the card type.'

# constructor
func _init(
	# placeholder values
	p_tile_set_path = "res://scenes/machine_tileset.tres"
	, p_tile_coords = Vector2i(1,1)
	, p_tile_type = 'This is the description of the card type.'
	):
		# assign passed-in values to this object
		tile_set = load(p_tile_set_path)
		tile_coords = p_tile_coords
		tile_type = p_tile_type
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# init with no parameters uses the placeholder values
	_init()
	pass # Replace with function body.

func set_tile_coords(new_coords:Vector2i):
	tile_coords = new_coords

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event) -> void:
	pass

# connected to the Area2D child of the card
func _on_card_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# viewport and shape_idx are parameters from collisionobject2d and may not be needed
	# if any mouse button was pressed...
	if event is InputEventMouseButton && event.is_pressed():
		print('card was pressed')
