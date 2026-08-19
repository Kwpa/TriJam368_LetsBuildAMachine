extends Sprite2D

func _ready():
	SignalBus.connect("show_place_halo", show_halo)
	SignalBus.connect("hide_place_halo", hide_halo)
	

func show_halo():
	self.visible = true
	

func hide_halo():
	self.visible = false
