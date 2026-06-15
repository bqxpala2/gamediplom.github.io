extends PanelContainer

@onready var sound_check_box: CheckBox = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/SoundCheckBox
@onready var h_slider_music: HSlider = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HSliderMusic
@onready var h_slider_sfx: HSlider = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/HSliderSFX



func _ready() -> void:
	sound_check_box.button_pressed = Globals.is_sound_on
	
	h_slider_music.value = Globals.music_value
	h_slider_sfx.value = Globals.sfx_value
	
	print(h_slider_music.value)
	print(h_slider_sfx.value)

func _on_close_button_pressed() -> void:
	queue_free()

func _on_sound_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		AudioServer.set_bus_volume_db(0,0)
	else:
		AudioServer.set_bus_volume_db(0,-80)
	Globals.is_sound_on = toggled_on


func _on_h_slider_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	Globals.music_value = value


func _on_h_slider_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	Globals.sfx_value = value
