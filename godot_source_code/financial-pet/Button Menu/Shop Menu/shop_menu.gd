extends PanelContainer

@onready var fuel_button: Button = $MarginContainer/PanelContainer/VBoxContainer/FuelCouponButton
@onready var plus_button: Button = $MarginContainer/PanelContainer/VBoxContainer/PlusCouponButton
@onready var rocket_button: Button = $MarginContainer/PanelContainer/VBoxContainer/RocketSkin
@onready var kosmo_button: Button = $MarginContainer/PanelContainer/VBoxContainer/Kosmoskin

func _ready() -> void:
	if fuel_button:
		fuel_button.pressed.connect(_on_fuel_button_pressed)
	if plus_button:
		plus_button.pressed.connect(_on_plus_button_pressed)
	if rocket_button:
		rocket_button.pressed.connect(_on_rocket_button_pressed)
	if kosmo_button:
		kosmo_button.pressed.connect(_on_kosmo_button_pressed)
		
	_update_buttons_ui()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if fuel_button and fuel_button.is_visible_in_tree() and not fuel_button.disabled:
			if fuel_button.get_global_rect().has_point(get_global_mouse_position()):
				get_viewport().set_input_as_handled() 
				_on_fuel_button_pressed()
				
		if plus_button and plus_button.is_visible_in_tree() and not plus_button.disabled:
			if plus_button.get_global_rect().has_point(get_global_mouse_position()):
				get_viewport().set_input_as_handled() 
				_on_plus_button_pressed()

		if rocket_button and rocket_button.is_visible_in_tree():
			if rocket_button.get_global_rect().has_point(get_global_mouse_position()):
				get_viewport().set_input_as_handled() 
				_on_rocket_button_pressed()

		if kosmo_button and kosmo_button.is_visible_in_tree():
			if kosmo_button.get_global_rect().has_point(get_global_mouse_position()):
				get_viewport().set_input_as_handled() 
				_on_kosmo_button_pressed()

func _on_fuel_button_pressed() -> void:
	if Globals.money >= 0:
		fuel_button.text = "Код: GAZPROM_FUEL_10"
		fuel_button.disabled = true

func _on_plus_button_pressed() -> void:
	if Globals.money >= 0:
		plus_button.text = "Код: GPB_PLUS_FREE"
		plus_button.disabled = true

func _on_rocket_button_pressed() -> void:
	if not Globals or not ("owned_skins" in Globals): return
	
	if "rocket" in Globals.owned_skins:
		Globals.current_skin = "default" if Globals.current_skin == "rocket" else "rocket"
	elif Globals.money >= 0: 
		Globals.money -= 0
		Globals.owned_skins.append("rocket")
		Globals.current_skin = "rocket"
		
	_update_buttons_ui()
	_update_panda_visuals()

func _on_kosmo_button_pressed() -> void:
	if not Globals or not ("owned_skins" in Globals): return
	
	if "kosmo" in Globals.owned_skins:
		Globals.current_skin = "default" if Globals.current_skin == "kosmo" else "kosmo"
	elif Globals.money >= 0: 
		Globals.money -= 0
		Globals.owned_skins.append("kosmo")
		Globals.current_skin = "kosmo"
		
	_update_buttons_ui()
	_update_panda_visuals()

func _update_buttons_ui() -> void:
	if not Globals or not ("owned_skins" in Globals) or not ("current_skin" in Globals):
		return

	if rocket_button:
		if "rocket" in Globals.owned_skins:
			rocket_button.text = "Снять" if Globals.current_skin == "rocket" else "Применить"
		else:
			rocket_button.text = "Скин \"РАКЕТА\" (0 монет)"

	if kosmo_button:
		if "kosmo" in Globals.owned_skins:
			kosmo_button.text = "Снять" if Globals.current_skin == "kosmo" else "Применить"
		else:
			kosmo_button.text = "Скин \"КОСМО\" (0 монет)"

func _update_panda_visuals() -> void:
	var main_scene = get_tree().current_scene
	if main_scene and main_scene.has_node("RedPanda"):
		var panda_node = main_scene.get_node("RedPanda")
		if panda_node.has_method("update_skin"):
			panda_node.update_skin()

func _on_close_button_pressed() -> void:
	queue_free()
