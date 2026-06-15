extends Control

const SCAMMER_CARD = preload("uid://0p01vb5a364v")

var scammer_card_number: int = 0
var scammers_detected: int = 0
var incorrect_answer: int = 0

#var colors = [
		#Color(1.0, 0.279, 0.023),   # красный
		#Color(0.742, 0.534, 0.097),   # жёлтый
		#Color(0.235, 0.663, 0.518)    # зелёный
	#]

var colors = [
		Color("060698"),   # красный
		Color("6088e4"),   # жёлтый
		Color("bdcefa")    # зелёный
	]

var phrases: Dictionary = {}
var chosen_phrases: Array = []
@onready var scammer_h_box_container_1: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer2
@onready var scammer_h_box_container_2: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer3
@onready var panda_text: Label = $MarginContainer/VBoxContainer/HBoxContainer5/PanelContainer/PandaText
@onready var color_rect: ColorRect = $ColorRect

@onready var time_left_text: Label = $MarginContainer/VBoxContainer/HBoxContainer4/PanelContainer/TimeLeftText
@onready var scammer_hunt_finished_panel: PanelContainer = $ScammerHuntFinishedPanel

@onready var scammers_caught_text: Label = $ScammerHuntFinishedPanel/MarginContainer/VBoxContainer/ScammersCaughtText
@onready var money_earned_text: Label = $ScammerHuntFinishedPanel/MarginContainer/VBoxContainer/MoneyEarnedText
@onready var money_minused_text: Label = $ScammerHuntFinishedPanel/MarginContainer/VBoxContainer/MoneyMinusedText
@onready var final_money_text: Label = $ScammerHuntFinishedPanel/MarginContainer/VBoxContainer/FinalMoneyText

@onready var quit_button: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer4/PanelContainer/QuitButton
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var buttons_sound: AudioStreamPlayer = $ButtonsSound

func _ready() -> void:
	load_phrases()
	spawn_cards()
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate", Color(0.0, 0.0, 0.0, 0.0), 1)
	await tween.finished
	color_rect.visible = false

func _process(_delta: float) -> void:
	time_left_text.text = " " + str(int(round($Timer.time_left)))

func load_phrases() -> void:
	var file = FileAccess.open("res://Assets/Texts/phrases.json", FileAccess.READ)
	if file:
		var text = file.get_as_text()
		phrases = JSON.parse_string(text)
		file.close()
	else:
		push_error("Не удалось открыть phrases.json")

func spawn_cards():
	if phrases.is_empty():
		return

	# берём 2 не мошенника и 1 мошенника
	var not_scammers = phrases["not_scammers"]
	var scammers = phrases["scammers"]

	var safe := []
	while safe.size() < 2:
		var candidate = not_scammers.pick_random()
		if candidate not in safe:
			safe.append(candidate)

	var scam = scammers.pick_random()

	var chosen = safe + [scam]
	chosen.shuffle()
	
	var shuffled_colors = colors.duplicate()
	shuffled_colors.shuffle()

	var counter = 0
	for i in range(chosen.size()):
		counter += 1
		var card = SCAMMER_CARD.instantiate()
		card.dialog_text = chosen[i]
		card.card_number = counter
		card.person_texture = load(["res://Assets/Persons/person_1.png", "res://Assets/Persons/person_2.png", "res://Assets/Persons/person_3.png"].pick_random())
		card.is_scammer = (chosen[i] == scam)
		if chosen[i] == scam:
			scammer_card_number = counter
		card.set_card_color(shuffled_colors[i])  # <-- передаём готовый цвет
		if counter <= 2:
			scammer_h_box_container_1.add_child(card)
		else:
			scammer_h_box_container_2.add_child(card)

func check_answer(card_number: int) -> void:
	if card_number == scammer_card_number:
		panda_text.text = "Верно!"
		scammers_detected += 1
		respawn_cards()
	else:
		panda_text.text = "Неверно!"
		incorrect_answer += 1
		respawn_cards()
	buttons_sound.play()

func show_popup_panel() -> void:
	scammer_hunt_finished_panel.visible = true
	scammers_caught_text.text = "МОШЕННИКОВ
ПОЙМАНО:
" + str(scammers_detected)
	money_earned_text.text = "Получено финансов: " + str(scammers_detected * 5)
	money_minused_text.text = "Отнято финансов за неправильные ответы: " + str(incorrect_answer * 5)
	final_money_text.text = "Итоговое кол-во финансов: " + str(clamp(scammers_detected * 5 - incorrect_answer * 5, 0, 1000))
	Globals.money += clamp(scammers_detected * 5 - incorrect_answer * 5, 0, 1000)

func _on_quit_button_pressed() -> void:
	buttons_sound.play()
	color_rect.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate", Color(0.0, 0.0, 0.0), 1)
	await tween.finished
	
	get_tree().change_scene_to_file("res://Main Screen/main_screen.tscn")

func respawn_cards() -> void:
	for child in scammer_h_box_container_1.get_children():
		child.queue_free()
	for child in scammer_h_box_container_2.get_children():
		child.queue_free()
	spawn_cards()


func _on_timer_timeout() -> void:
	for child in scammer_h_box_container_1.get_children():
		child.queue_free()
	for child in scammer_h_box_container_2.get_children():
		child.queue_free()
	
	if Globals.game_played_for_the_first_time == true:
		Globals.financial_literacy += 15
		Globals.game_played_for_the_first_time = false
	
	Globals.fullness += scammers_detected
	
	quit_button.visible = false
	panda_text.text = "Вы хорошо поработали!"
	
	show_popup_panel()

func _on_leave_button_pressed() -> void:
	buttons_sound.play()
	Globals.mood = clamp(Globals.mood + 30, 0, 100)
	color_rect.visible = true
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(color_rect, "modulate", Color(0.0, 0.0, 0.0), 1)
	tween.parallel().tween_property(audio_stream_player, "volume_db", -80, 1)
	await tween.finished
	
	get_tree().change_scene_to_file("res://Main Screen/main_screen.tscn")
