extends PanelContainer

var icon: Texture2D
var description_text: String
var product_name_text: String
@onready var description: Label = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/ScrollContainer/MarginContainer/Description
@onready var product_icon: Panel = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/ProductIcon
@onready var product_name: Label = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/ProductName


func _ready() -> void:
  product_name.text = product_name_text
  description.text = description_text
  var style_box_texture : StyleBoxTexture = StyleBoxTexture.new()
  style_box_texture.texture = icon
  product_icon.add_theme_stylebox_override("panel", style_box_texture)


func _on_close_button_pressed() -> void:
  queue_free()
