extends Control

# Array to store the selected classes
var selected_party = []
const MAX_PARTY_SIZE = 4

# Node references
@onready var class_grid = $MainLayout/ClassGrid
@onready var party_slots = $MainLayout/PartySlots
@onready var start_run_button = $MainLayout/StartRunButton

func _ready():
	# Disable the start button initially
	start_run_button.disabled = true
	
	# Connect the start button
	start_run_button.pressed.connect(_on_start_run_pressed)
	
	# Dynamically connect all 6 class buttons in the GridContainer
	for button in class_grid.get_children():
		if button is Button:
			# Bind the button's text (the class name) to the function
			button.pressed.connect(_on_class_button_pressed.bind(button.text))

func _on_class_button_pressed(chosen_class: String):
	# Add class to party if there is room
	if selected_party.size() < MAX_PARTY_SIZE:
		selected_party.append(chosen_class)
		update_ui()

func update_ui():
	# Update the 4 slot labels based on the selected_party array
	var slots = party_slots.get_children()
	
	for i in range(MAX_PARTY_SIZE):
		if i < selected_party.size():
			slots[i].text = "[ " + selected_party[i] + " ]"
		else:
			slots[i].text = "[ Empty ]"
			
	# Enable the Start Run button only if the party is full
	if selected_party.size() == MAX_PARTY_SIZE:
		start_run_button.disabled = false
	else:
		start_run_button.disabled = true

# Optional: Allow players to click a filled slot to remove a character
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		if selected_party.size() > 0:
			selected_party.pop_back()
			update_ui()

func _on_start_run_pressed():
	print("Party formed: ", selected_party)
	print("Entering Node 1...")
	# Here we will eventually change the scene to Node 1 Combat
	# get_tree().change_scene_to_file("res://Scenes/Node1_Combat.tscn")
