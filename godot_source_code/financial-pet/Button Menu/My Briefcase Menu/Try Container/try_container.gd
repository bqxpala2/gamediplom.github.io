extends PanelContainer

signal change_financial_literacy_value(added_value)

var product_url: String
var product_name: String
var product_texture: Texture2D

@onready var product_icon: Panel = $VBoxContainer/HBoxContainer/ProductIcon
@onready var buttons_sound: AudioStreamPlayer = $ButtonsSound

func _ready() -> void:
	$VBoxContainer/HBoxContainer/ProductName.text = product_name
	var style_box_texture : StyleBoxTexture = StyleBoxTexture.new()
	style_box_texture.texture = product_texture
	product_icon.add_theme_stylebox_override("panel", style_box_texture)

func add_tried_product(tried_product: String) -> void:
	var array: Array[String] = Globals.tried_products
	if tried_product not in array:
		array.append(tried_product)
		Globals.financial_literacy += 10
		change_financial_literacy_value.emit(10)

func _on_try_button_pressed() -> void:
	add_tried_product(name)
	OS.shell_open(product_url)
	$ButtonsSound.play()
	Globals.link_clicked_counter += 1
	
