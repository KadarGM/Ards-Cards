extends Node

const HERO_LIST: Array[HeroDataResource] = [
	preload("res://Assets/Resources/Heroes/hero1.tres")
	]

var hero_data_manager = HERO_LIST[0]
@onready var game_data_manager = GameDataManager

@onready var p1_name_label = $player1UI/MarginContainer/HBoxContainer1/p1NameLabel
@onready var p1_health_label = $player1UI/MarginContainer/HBoxContainer2/p1HealthLabel
@onready var p1_defense_label = $player1UI/MarginContainer/HBoxContainer2/p1DefenseLabel
@onready var p1_attack_label = $player1UI/MarginContainer/HBoxContainer2/p1AttackLabel
@onready var p1_mana_label = $player1UI/MarginContainer/HBoxContainer2/p1ManaLabel

@onready var p2_name_label = $player2UI/MarginContainer/HBoxContainer1/p2NameLabel
@onready var p2_health_label = $player2UI/MarginContainer/HBoxContainer2/p2HealthLabel
@onready var p2_defense_label = $player2UI/MarginContainer/HBoxContainer2/p2DefenseLabel
@onready var p2_attack_label = $player2UI/MarginContainer/HBoxContainer2/p2AttackLabel
@onready var p2_mana_label = $player2UI/MarginContainer/HBoxContainer2/p2ManaLabel


func _ready():
	game_data_manager.p1_hero_name = hero_data_manager.name
	game_data_manager.p1_hero_health = hero_data_manager.health
	game_data_manager.p1_hero_defense = hero_data_manager.defense
	game_data_manager.p1_hero_attack = hero_data_manager.attack
	game_data_manager.p1_hero_mana = hero_data_manager.mana
	
	game_data_manager.p2_hero_name = hero_data_manager.name
	game_data_manager.p2_hero_health = hero_data_manager.health
	game_data_manager.p2_hero_defense = hero_data_manager.defense
	game_data_manager.p2_hero_attack = hero_data_manager.attack
	game_data_manager.p2_hero_mana = hero_data_manager.mana

	
func _process(_delta):
	p1_name_label.text = str(game_data_manager.p1_hero_name)
	p1_health_label.text = str(game_data_manager.p1_hero_health)
	p1_defense_label.text = str(game_data_manager.p1_hero_defense)
	p1_attack_label.text = str(game_data_manager.p1_hero_attack)
	p1_mana_label.text = str(game_data_manager.p1_hero_mana)

	p2_name_label.text = str(game_data_manager.p2_hero_name)
	p2_health_label.text = str(game_data_manager.p2_hero_health)
	p2_defense_label.text = str(game_data_manager.p2_hero_defense)
	p2_attack_label.text = str(game_data_manager.p2_hero_attack)
	p2_mana_label.text = str(game_data_manager.p2_hero_mana)
