extends Node2D

enum CombatState { START, PLAYER_TURN, ENEMY_TURN, WON, LOST }
var current_state: CombatState = CombatState.START

var enemy_hp: int = 100
var enemy_max_hp: int = 100
var player_party_hp: int = 200 
var total_xp: int = 0

var qte_active: bool = false
var required_key: String = ""

@onready var ui_layer = $UI_Layer
@onready var turn_indicator = $UI_Layer/TurnIndicator
@onready var action_menu = $UI_Layer/ActionMenu
@onready var btn_attack = $UI_Layer/ActionMenu/BtnAttack
@onready var btn_block = $UI_Layer/ActionMenu/BtnBlock
@onready var btn_focus = $UI_Layer/ActionMenu/BtnFocus

func _ready():
	# 1. SETUP BACKGROUND (Layer -1 agar di belakang)
	setup_background()
	
	# 2. SETUP MUSUH & 4 ROBOT SQUAD
	setup_combat_entities()

	# 3. KONEKSI TOMBOL
	if btn_attack: btn_attack.pressed.connect(_on_attack_pressed)
	if btn_block: btn_block.pressed.connect(_on_block_pressed)
	if btn_focus: btn_focus.pressed.connect(_on_focus_pressed)
	
	action_menu.hide()
	current_state = CombatState.START
	await get_tree().create_timer(1.5).timeout 
	start_player_turn()

func setup_background():
	var bg_layer = CanvasLayer.new()
	bg_layer.layer = -1
	add_child(bg_layer)
	var bg_texture = TextureRect.new()
	bg_texture.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var bg_image = load("res://Background/Battle Stage.png")
	if bg_image: bg_texture.texture = bg_image
	bg_layer.add_child(bg_texture)

func setup_combat_entities():
	# Memunculkan Musuh
	var enemy_path = "res://Scenes/CorporateDrone.tscn" if GameManager.current_node == 1 else "res://Scenes/TheRecyclerBoss.tscn"
	if ResourceLoader.exists(enemy_path):
		var enemy_inst = load(enemy_path).instantiate()
		enemy_inst.position = Vector2(850, 350)
		add_child(enemy_inst)
		# Jika ada animasi idle
		if enemy_inst.has_node("AnimationPlayer"): enemy_inst.get_node("AnimationPlayer").play("idle")

	# Memunculkan 4 Robot Squad
	for i in range(GameManager.current_party.size()):
		var char_path = "res://Scenes/" + GameManager.current_party[i] + ".tscn"
		if ResourceLoader.exists(char_path):
			var char_inst = load(char_path).instantiate()
			# Posisi robot berbaris: X makin ke kanan, Y tetap di bawah
			char_inst.position = Vector2(150 + (i * 150), 450)
			add_child(char_inst)
			# Memanggil animasi jika tersedia
			if char_inst.has_node("AnimationPlayer"): char_inst.get_node("AnimationPlayer").play("idle")

# --- QTE SYSTEM ---
func start_qte():
	qte_active = true
	var keys = ["W", "A", "S", "D", "Q", "E"]
	required_key = keys.pick_random()
	turn_indicator.text = "OVERCLOCK! Tekan: " + required_key
	await get_tree().create_timer(2.5).timeout
	if qte_active: finish_qte(false)

func _input(event):
	if qte_active and event is InputEventKey and event.pressed:
		finish_qte(OS.get_keycode_string(event.keycode) == required_key)

func finish_qte(success):
	qte_active = false
	if success: 
		turn_indicator.text = "SUCCESS! 125% DMG! (+50 XP)"
		total_xp += 50
	else: 
		turn_indicator.text = "Overclock failed. Base damage."
	await get_tree().create_timer(1.0).timeout
	end_player_turn()

# --- ACTIONS ---
func _on_attack_pressed():
	if current_state != CombatState.PLAYER_TURN: return
	play_click_sound()
	action_menu.hide()
	start_qte() 

func _on_block_pressed():
	play_click_sound(); action_menu.hide()
	total_xp += 10
	turn_indicator.text = "BLOCK: Defleksi Aktif (+10 XP)"
	await get_tree().create_timer(1.2).timeout
	end_player_turn()

func _on_focus_pressed():
	play_click_sound(); action_menu.hide()
	total_xp += 15
	turn_indicator.text = "FOCUS: Sinkronisasi Neural (+15 XP)"
	await get_tree().create_timer(1.2).timeout
	end_player_turn()

# --- GAME LOOP ---
func start_player_turn():
	if current_state >= CombatState.WON: return
	current_state = CombatState.PLAYER_TURN
	turn_indicator.text = "Awaiting Orders..."
	action_menu.show()

func start_enemy_turn():
	current_state = CombatState.ENEMY_TURN
	turn_indicator.text = "Enemy Turn..."
	await get_tree().create_timer(1.0).timeout
	player_party_hp -= 25
	if player_party_hp <= 0: handle_defeat()
	else: start_player_turn()

func end_player_turn(): start_enemy_turn()

func handle_victory():
	if GameManager.current_node == 1:
		GameManager.current_node = 2
		get_tree().change_scene_to_file("res://UI/WorkshopScene.tscn")
	else: get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")

func handle_defeat():
	get_tree().change_scene_to_file("res://Scenes/GameOverScreen.tscn")

func play_click_sound():
	if has_node("AudioStreamPlayer"): $AudioStreamPlayer.play()
