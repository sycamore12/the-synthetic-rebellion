extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	# Find the button node. We assume it is named exactly "Button" 
	# and is a direct child of the StartScreen node.
	var begin_button = $Button
	
	# Check if the button exists to prevent crashes, then connect the click signal.
	if begin_button:
		begin_button.pressed.connect(_on_begin_rebellion_pressed)
	else:
		print("Error: Could not find the 'Begin Rebellion' button. Check your node names.")

# This function runs when the button is clicked.
func _on_begin_rebellion_pressed():
	print("Rebellion Begun! Loading Party Formation...")
	
	# Transition to the Party Formation scene.
	get_tree().change_scene_to_file("res://UI/PartyFormation.tscn")
