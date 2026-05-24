extends Resource
class_name SecondGenClass

# Basic Information
@export var class_title: String = "Unknown Model"
@export var role_description: String = ""

# Health Pool (Managed individually per the GDD)
@export var max_hp: int = 100
@export var current_hp: int = 100

# Core Stats for Node 2 Workshop upgrades
@export var base_str: int = 10
@export var base_dex: int = 10
@export var base_int: int = 10

# Helper function to heal the robot (used by the Diagnostics class)
func heal(amount: int):
	current_hp += amount
	if current_hp > max_hp:
		current_hp = max_hp

# Helper function to take damage
func take_damage(amount: int):
	current_hp -= amount
	if current_hp < 0:
		current_hp = 0

# Helper function to reset health if the player loses a micro-run
func reset_health():
	current_hp = max_hp
