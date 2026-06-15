extends PanelContainer

signal change_financial_literacy_value(added_value: int, add_money: int)

@onready var v_box_container: VBoxContainer = $MarginContainer/PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer

func _ready() -> void:
	for product in Globals.learned_products:
		if product == "bank_deposit": generate_try_container("Вклад «Копить»", "https://www.gazprombank.ru/personal/increase/deposits/detail/2491/", "res://Assets/UI/bank_deposit_button.png")
		elif product == "life_insurance": generate_try_container("Инвестиционное страхование жизни", "https://www.gazprombank.ru/personal/page/investment-life-insurance/", "res://Assets/UI/life_insurance_button.png")
		elif product == "credit_card": generate_try_container("Кредитная карта c льготным периодом до 120 дней", "https://www.gazprombank.ru/personal/credit-cards/7950641/", "res://Assets/UI/credit_card_button.png")
		elif product == "it_mortgage": generate_try_container("Ипотека для IT-специалистов", "https://www.gazprombank.ru/personal/take_credit/mortgage/6881595/", "res://Assets/UI/it_mortgage_button.png")

func _on_close_button_pressed() -> void:
	queue_free()

func generate_try_container(product_name: String, product_url: String, product_texture: String) -> void:
	var try_container = preload("res://Button Menu/My Briefcase Menu/Try Container/try_container.tscn")
	var try_container_instance = try_container.instantiate()
	try_container_instance.product_name = product_name
	try_container_instance.product_texture = load(product_texture)
	try_container_instance.product_url = product_url
	v_box_container.add_child(try_container_instance)
	try_container_instance.change_financial_literacy_value.connect(_on_change_financial_literacy_value)
	
func _on_change_financial_literacy_value(value: int) -> void:
	change_financial_literacy_value.emit(value, 200)
