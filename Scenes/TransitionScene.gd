extends CanvasLayer

@onready var color_rect = $ColorRect

func _ready():
	# Sembunyikan layar hitam saat game baru dimulai
	color_rect.hide()

# Fungsi ini akan dipanggil oleh script lain untuk pindah scene
func change_scene(target_scene_path: String):
	color_rect.show()
	
	# Ambil ukuran layar untuk menutupi seluruh area
	var screen_size = get_viewport().get_visible_rect().size
	
	# 1. Atur posisi kotak hitam di luar layar sebelah KANAN
	color_rect.position = Vector2(screen_size.x, 0)
	color_rect.size = screen_size
	
	# 2. Animasikan slide masuk ke tengah (posisi 0, 0) selama 0.5 detik
	var tween_in = create_tween()
	tween_in.tween_property(color_rect, "position", Vector2(0, 0), 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Tunggu sampai animasi slide masuk selesai
	await tween_in.finished
	
	# 3. GANTI SCENE SAAT LAYAR GELAP
	get_tree().change_scene_to_file(target_scene_path)
	
	# 4. Animasikan slide keluar ke arah KIRI (-x)
	var tween_out = create_tween()
	tween_out.tween_property(color_rect, "position", Vector2(-screen_size.x, 0), 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Tunggu sampai animasi slide keluar selesai, lalu sembunyikan kotak hitam
	await tween_out.finished
	color_rect.hide()
