extends Node2D

enum CombatState { START, PLAYER_TURN, ENEMY_TURN, WON, LOST }
var current_state: CombatState = CombatState.START

# UI References
@onready var turn_indicator = $UI_Layer/TurnIndicator
@onready var action_menu = $UI_Layer/ActionMenu
@onready var btn_attack = $UI_Layer/ActionMenu/BtnAttack
@onready var btn_block = $UI_Layer/ActionMenu/BtnBlock
@onready var btn_focus = $UI_Layer/ActionMenu/BtnFocus

func _ready():
	print("Initiating Node 1 Combat...")
	if GameManager.current_party.size() > 0:
		print("Deploying Squad: ", GameManager.current_party)
	else:
		print("Warning: No squad detected (testing mode).")
		
	# Connect UI buttons
	btn_attack.pressed.connect(_on_attack_pressed)
	btn_block.pressed.connect(_on_block_pressed)
	btn_focus.pressed.connect(_on_focus_pressed)
	
	# Hide buttons initially
	action_menu.hide()
	
	# Start the combat loop
	current_state = CombatState.START
	start_player_turn()

func start_player_turn():
	current_state = CombatState.PLAYER_TURN
	turn_indicator.text = "Awaiting Orders..."
	action_menu.show()

# --- Player Actions ---
func _on_attack_pressed():
	if current_state != CombatState.PLAYER_TURN: return
	action_menu.hide()
	turn_indicator.text = "Second-Gen Attacked!"
	# TODO: Implement damage calculation here
	
	end_player_turn()

func _on_block_pressed():
	if current_state != CombatState.PLAYER_TURN: return
	action_menu.hide()
	turn_indicator.text = "Shields Raised!"
	# TODO: Implement damage mitigation here
	
	end_player_turn()

func _on_focus_pressed():
	if current_state != CombatState.PLAYER_TURN: return
	action_menu.hide()
	turn_indicator.text = "Energy Focused!"
	# TODO: Implement energy regeneration here
	
	end_player_turn()

func end_player_turn():
	# Small delay using Godot 4's await syntax for game feel
	await get_tree().create_timer(1.0).timeout
	start_enemy_turn()

# --- Enemy AI ---
func start_enemy_turn():
	current_state = CombatState.ENEMY_TURN
	turn_indicator.text = "Corporate Drone's Turn"
	
	await get_tree().create_timer(1.0).timeout
	
	turn_indicator.text = "Drone Fires Laser!"
	# TODO: Implement enemy damage to player here
	
	await get_tree().create_timer(1.5).timeout
	
	# Loop back to player
	start_player_turn()
