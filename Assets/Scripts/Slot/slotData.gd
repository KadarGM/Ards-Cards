extends Node2D

var game_data_manager = GameDataManager

@export var id_slot: int
@export var is_empty: int = 1
@export var slot: String

@onready var card_count = $CardCount
@onready var color_rect = $ColorRect

func _ready():
	card_count.visible = false
	color_rect.visible = false

func _process(_delta):
	if is_empty == 0:
		color_rect.color = Color(1, 0.38, 0.38, 0.196)
	if is_empty == 1:
		color_rect.color = Color(0.392, 1, 0.38, 0.196)
