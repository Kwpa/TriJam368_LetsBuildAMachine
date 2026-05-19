extends Node

signal reset_resource_inputs_on_plant(plant_id)
signal add_resource_input_to_plant(plant_id) 
signal spend_action()
signal enter_remove_mode()
signal enter_rotate_mode()
signal enter_hand_mode()
signal enter_place_mode(atlas_coords, alt_id)
signal rotate_preview_tile(atlas_coords, alt_id)
signal use_card()
