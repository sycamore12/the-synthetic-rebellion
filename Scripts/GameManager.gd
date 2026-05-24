extends Node

# This array will hold the 4 classes you selected in the UI
var current_party: Array = []
var current_node: int = 1

func set_party(party: Array):
	current_party = party
	print("GameManager loaded party: ", current_party)
