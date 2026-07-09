extends Node

signal reset_resource_inputs_on_plant(plant_id: int)
signal add_resource_input_to_plant(plant_id: int, input_name:String, action_type: String) 
signal spend_action() # not used?
signal enter_remove_mode()
signal enter_rotate_mode()
signal enter_hand_mode()
signal enter_place_mode(atlas_coords, alt_id)
signal rotate_preview_tile(atlas_coords, alt_id)
signal use_card()
signal propogate_resources() # check the game board for what tiles have resources
signal set_plant_id(plant_id: int) # not currently useful, but is used and could be implemented better
signal end_turn() # inform the plant and hand that a turn has ended
signal grow_plant(plant_id: int) # grow the plant
signal end_game(win: bool) # ends the game, win or lose
signal count_action(spend: int) # sends a signal to the action count ui label
signal non_hand_action(spend: int) # informs the hand that an action has been spent or gained elsewhere
signal update_dispenser_layer(add_array : Array[InstantiatedTileData])
signal restart_level(level: int)
