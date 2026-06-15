extends Control

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	update_skin()

func update_skin() -> void:
	var skin = Globals.current_skin
	if skin == "default":
		animated_sprite.play("Idle")
	elif animated_sprite.sprite_frames.has_animation(skin):
		animated_sprite.play(skin)
