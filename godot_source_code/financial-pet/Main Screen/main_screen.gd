extends Control

@onready var money_label: Label = $Interface/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/MoneyLabel
@onready var mood_progress_bar: TextureProgressBar = $Interface/MarginContainer/Bars/VBoxContainer/HBoxContainer2/MoodProgressBar
@onready var fullness_progress_bar: TextureProgressBar = $Interface/MarginContainer/Bars/VBoxContainer/HBoxContainer/FullnessProgressBar
@onready var financial_progress_bar: TextureProgressBar = $Interface/MarginContainer/Bars/VBoxContainer/HBoxContainer3/FinancialProgressBar
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var buttons_sound: AudioStreamPlayer = $ButtonsSound

@onready var tap_button: Button = $Interface/TapButton
@onready var click_hint_label: Label = $ClickHintLabel
@onready var coin_particles: CPUParticles2D = $CoinParticles

var time: float = 0
var tap_count: int = 0
var original_button_pos: Vector2

func _ready() -> void:
	money_label.text = "Финансы " + str(Globals.money)
	mood_progress_bar.value = Globals.mood
	fullness_progress_bar.value = Globals.fullness
	financial_progress_bar.value = Globals.financial_literacy
	
	if tap_button:
		original_button_pos = tap_button.position
		tap_button.pressed.connect(_on_tap_button_pressed)
	
	update_raccoon_skin()

func _process(_delta: float) -> void:
	update_raccoon_skin()

func _physics_process(delta: float) -> void:
	time += delta
	if time >= 5.0:
		mood_progress_bar.value -= 1
		fullness_progress_bar.value -= 1
		Globals.mood = int(mood_progress_bar.value)
		Globals.fullness = int(fullness_progress_bar.value)
		time = 0.0

func _on_tap_button_pressed() -> void:
	# Рассчитываем множитель клика на основе настроения и сытости
	var fullness_factor: float = fullness_progress_bar.value / 100.0
	var mood_factor: float = mood_progress_bar.value / 100.0
	
	# Формула выдает от 1 до 3 монет за один клик в зависимости от шкал
	var coins_per_tap: int = int(1.0 + ((fullness_factor + mood_factor) / 2.0) * 2.0)
	
	Globals.money += coins_per_tap
	money_label.text = "Финансы " + str(Globals.money)
	buttons_sound.play()
	
	tap_count += 1
	if tap_count >= 3 and click_hint_label and click_hint_label.visible:
		_fade_out_hint()
		
	_spawn_coin_particles()
	_shake_button()

func _spawn_coin_particles() -> void:
	if coin_particles:
		coin_particles.global_position = get_global_mouse_position()
		coin_particles.restart()

func _shake_button() -> void:
	if not tap_button: return
	var tween = create_tween()
	tween.tween_property(tap_button, "position", original_button_pos + Vector2(10, -5), 0.03)
	tween.tween_property(tap_button, "position", original_button_pos + Vector2(-10, 5), 0.03)
	tween.tween_property(tap_button, "position", original_button_pos + Vector2(5, -3), 0.03)
	tween.tween_property(tap_button, "position", original_button_pos + Vector2(-5, 2), 0.03)
	tween.tween_property(tap_button, "position", original_button_pos, 0.03)

func _fade_out_hint() -> void:
	if not click_hint_label: return
	var tween = create_tween()
	tween.tween_property(click_hint_label, "modulate:a", 0.0, 0.3)
	tween.tween_callback(func(): click_hint_label.visible = false)

func _on_learn_button_pressed() -> void:
	for child in $Interface/Menu.get_children():
		child.queue_free()
		
	if tap_button: 
		tap_button.disabled = true
		
	var menu = preload("res://Button Menu/Learn Menu/learn_product_menu.tscn")
	var menu_instance = menu.instantiate()
	$Interface/Menu.add_child(menu_instance)
	menu_instance.change_financial_literacy_value.connect(_on_change_financial_literacy_value)
	menu_instance.add_fullness_value.connect(_on_add_fullness_value)
	buttons_sound.play()

func _on_my_briefcase_pressed() -> void:
	for child in $Interface/Menu.get_children():
		child.queue_free()
		
	if tap_button: 
		tap_button.disabled = true
		
	var my_briefcase_menu = preload("res://Button Menu/My Briefcase Menu/my_brief_case_menu.tscn")
	var my_briefcase_menu_instance = my_briefcase_menu.instantiate()
	$Interface/Menu.add_child(my_briefcase_menu_instance)
	my_briefcase_menu_instance.change_financial_literacy_value.connect(_on_change_financial_literacy_value)
	buttons_sound.play()

func _on_play_button_pressed() -> void:
	buttons_sound.play()
	
	var fullness_factor: float = fullness_progress_bar.value / 100.0
	var mood_factor: float = mood_progress_bar.value / 100.0
	
	Globals.game_reward_multiplier = int(1.0 + ((fullness_factor + mood_factor) / 2.0) * 1.5)

	var black_box: ColorRect = ColorRect.new()
	black_box.color = Color(0.0, 0.0, 0.0)
	black_box.set_anchors_preset(Control.PRESET_FULL_RECT)
	black_box.z_index = 1
	black_box.modulate = Color(1.0, 1.0, 1.0, 0.0)
	$Interface.add_child(black_box)
	
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(black_box, "modulate", Color(1.0, 1.0, 1.0), 1)
	tween.parallel().tween_property(audio_stream_player, "volume_db", -80, 1)
	await tween.finished
	
	get_tree().change_scene_to_file("res://Games/Hunt For Scammers/hunt_for_scammers.tscn")

func _on_shop_button_pressed() -> void:
	add_close_menu("res://Button Menu/Shop Menu/shop_menu.tscn")

func _on_change_financial_literacy_value(_added_value: int, add_money: int) -> void:
	# Прибавляем ровно 25% к визуальной шкале при каждом обучении
	financial_progress_bar.value += 25
	# Сохраняем актуальное значение в глобальные переменные
	Globals.financial_literacy = int(financial_progress_bar.value)
	
	Globals.money += add_money
	money_label.text = "Финансы " + str(Globals.money)

func _on_add_fullness_value(added_value: int) -> void:
	fullness_progress_bar.value += added_value
	Globals.fullness += added_value

func _on_daily_bonus_button_pressed() -> void:
	add_close_menu("res://Button Menu/Daily Box Menu/daily_bonus_menu.tscn")

func _on_setting_button_pressed() -> void:
	add_close_menu("res://Button Menu/Settings Menu/settings_menu.tscn")

func add_close_menu(menu_path: String) -> void:
	for child in $Interface/Menu.get_children():
		child.queue_free()
		
	if tap_button: 
		tap_button.disabled = true
		
	var menu = load(menu_path)
	var menu_instance = menu.instantiate()
	$Interface/Menu.add_child(menu_instance)
	buttons_sound.play()

func _on_menu_child_exiting_tree(_node: Node) -> void:
	if tap_button: 
		tap_button.disabled = false
	buttons_sound.play()
	update_raccoon_skin()

func update_raccoon_skin() -> void:
	if not tap_button or not Globals or not ("current_skin" in Globals): return
	
	var texture_path: String = "res://Assets/Red Panda/red_panda_main_character_shadow.png" 
	
	if Globals.current_skin == "rocket":
		texture_path = "res://Assets/Red Panda/roket2 (1).png"
	elif Globals.current_skin == "kosmo":
		texture_path = "res://Assets/Red Panda/Kosmo1.png"
		
	var new_texture = load(texture_path)
	if not new_texture: return
	
	var new_style = StyleBoxTexture.new()
	new_style.texture = new_texture
	
	tap_button.add_theme_stylebox_override("normal", new_style)
	tap_button.add_theme_stylebox_override("pressed", new_style)
	tap_button.add_theme_stylebox_override("hover", new_style)
	tap_button.add_theme_stylebox_override("disabled", new_style)
	tap_button.add_theme_stylebox_override("focus", new_style)
	
	tap_button.queue_redraw()
