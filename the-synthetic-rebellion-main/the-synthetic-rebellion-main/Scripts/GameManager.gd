extends Node

# Array untuk menampung 4 kelas yang dipilih di UI
var current_party: Array = []

# Penanda progress game (1: Drone, 2: Workshop, 3: Boss)
var current_node: int = 1

# Poin stat yang didapat setelah menang melawan drone untuk dipakai di Workshop
var stat_points: int = 0

func set_party(party: Array):
	current_party = party
	print("GameManager loaded party: ", current_party)

# Fungsi untuk mereset data kalau pemain kalah (Scrap Heap) dan harus mengulang dari awal
func reset_game():
	current_party = []
	current_node = 1
	stat_points = 0
	print("GameManager: Data telah di-reset ke awal.")
