extends Node2D

var game_data_manager = GameDataManager

@export var id_slot: int
@export var is_empty: int = 1
@export var slot: String

@onready var card_count = $CardCount

func _ready():
	card_count.visible = false
