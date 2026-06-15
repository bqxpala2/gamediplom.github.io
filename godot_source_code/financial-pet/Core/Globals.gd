extends Node

var learned_products: Array[String] = []
var tried_products: Array[String] = []
var money: int = 0

var mood: int = 100
var financial_literacy: int = 0
var fullness: int = 20

# ВОТ ЭТУ СТРОЧКУ МЫ ДОБАВИЛИ:
var game_reward_multiplier: int = 1

var game_played_for_the_first_time: bool = true

var link_clicked_counter: int = 0

var is_sound_on: bool = true
var sfx_value: float = 1.0
var music_value: float = 1.0

var owned_skins: Array = [] 
var current_skin: String = "default" 

func buy_skin(skin_name: String, cost: int) -> bool:
	if skin_name in owned_skins:
		print("Скин уже куплен!")
		return true
		
	if money >= cost:
		money -= cost
		owned_skins.append(skin_name)
		current_skin = skin_name
		print("Успешно куплено: ", skin_name)
		return true
	else:
		print("Недостаточно денег для покупки: ", skin_name)
		return false

func equip_skin(skin_name: String) -> bool:
	if skin_name in owned_skins:
		current_skin = skin_name
		print("Экипирован скин: ", skin_name)
		return true
	return false
