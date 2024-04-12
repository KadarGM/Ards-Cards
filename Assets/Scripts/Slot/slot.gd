extends Node2D

var game_data_manager = GameDataManager

@export var id_slot: int
@export var is_empty: int = 1
@export var slot: String

@onready var card_count = $CardCount

func _ready():
	card_count.visible = false


func _on_color_rect_mouse_entered():
	if slot == "grave":
		game_data_manager.show_grave("player1")


func _on_color_rect_mouse_exited():
	if slot == "grave":
		print("no")
