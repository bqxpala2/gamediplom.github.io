extends PanelContainer

var dialog_text: String
var is_scammer: bool
var card_number: int
var person_texture: Texture2D

@onready var d_text: Label = $VBoxContainer/MarginContainer/PanelContainer/MarginContainer/DText

func _ready() -> void:
	d_text.text = dialog_text
	var styleBox: StyleBoxTexture = $VBoxContainer/PersonPanel.get_theme_stylebox("panel").duplicate()
	styleBox.set("texture", person_texture)
	$VBoxContainer/PersonPanel.add_theme_stylebox_override("panel", styleBox)

func set_random_color():
	var colors = [
		Color(1.0, 0.279, 0.023),   # красный
		Color(0.742, 0.534, 0.097),   # жёлтый
		Color(0.235, 0.663, 0.518)    # зелёный
	]
	
	var styleBox: StyleBoxTexture = get_theme_stylebox("panel").duplicate()
	styleBox.set("modulate_color", colors.pick_random())
	add_theme_stylebox_override("panel", styleBox)

func set_card_color(color: Color):
	var styleBox: StyleBoxTexture = get_theme_stylebox("panel").duplicate()
	styleBox.set("modulate_color", color)
	add_theme_stylebox_override("panel", styleBox)


func _on_texture_button_pressed() -> void:
	get_tree().root.get_node("HuntForScammers").check_answer(card_number)
