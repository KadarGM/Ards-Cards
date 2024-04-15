extends Node2D

var max_card_scale = 2.2
var min_card_scale = 1

var game_data_manager = GameDataManager

const PLAYER_CARDS: Array[CardDataResource] = [
	preload("res://Assets/Resources/Cards/Creature/testCard1.tres"),
	preload("res://Assets/Resources/Cards/Creature/testCard2.tres"),
	preload("res://Assets/Resources/Cards/Creature/testCard3.tres"),
	preload("res://Assets/Resources/Cards/Creature/testCard4.tres"),
	]

const TYPE_ARRAY = ["AttackC", "DefendC", "Artefact", "Action", "Spell", "AttackE", "DefendE", "Hero"] 
const RACE_ARRAY = ["Forest", "Rusty", "Black", "Termite", "Yellow", "White"]

const RACE_COLOR : Dictionary = {
	0 : Color(0.11, 0.69, 0.09), #Forest
	1 : Color(0.871, 0.541, 0.114), #Rusty
	2 : Color(0.114, 0.149, 0.149), #Black
	3 : Color(0.702, 0.74, 0.562), #Termite
	4 : Color(0.82, 0.74, 0.221), #Yellow
	5 : Color(1, 1, 1), #White
}

@export var id: int
@export var id_in_slot: int
@export var slot_type: String
@export var type: int

@onready var play_menu = $cardTrans/PlayMenu
@onready var put_button = $cardTrans/PlayMenu/HBoxContainer/VBoxContainer
@onready var put_button_1 = $cardTrans/PlayMenu/HBoxContainer/VBoxContainer2
@onready var active_card = $ActiveCard

@onready var card_trans = $cardTrans
@onready var name_label = $cardTrans/CardFG/NameLabel

@onready var card_stats = $cardTrans/CardStats
@onready var fg = $cardTrans/CardFG/FG
@onready var bg = $CardBG/BG

@onready var mana_label = $cardTrans/CardStats/LeftContainer/GridContainer/ManaRect/ManaSprite/ManaLabel
@onready var health_label = $cardTrans/CardStats/LeftContainer/GridContainer/HealthRect/HealthSprite/HealthLabel
@onready var deffense_label = $cardTrans/CardStats/LeftContainer/GridContainer/DeffenseRect/DeffenseSprite/DeffenseLabel
@onready var attack_label = $cardTrans/CardStats/LeftContainer/GridContainer/AttackRect/AttackSprite/AttackLabel

@onready var deffense_rect = $cardTrans/CardStats/LeftContainer/GridContainer/DeffenseRect


@onready var card_bg = $CardBG
@onready var type_label = $cardTrans/TypeLabel
@onready var race_label = $cardTrans/RaceLabel



func _ready():
	set_stats_value()
	set_stats_visible(false)
	set_play_menu(false)
	set_colors()
	put_button_1.visible = false
	card_trans.visible = false
	active_card.visible = false
	card_bg.visible = true

func set_colors():
	fg.modulate = RACE_COLOR[PLAYER_CARDS[id].race]

func _process(_delta):
	if game_data_manager.is_starting == false:
		if Input.is_action_just_pressed("right click"):
			if game_data_manager.is_detailed == true:
				release_detail_card()
				game_data_manager.is_searching = true
				active_card.button_pressed = false
				release_searching_hand()
			if game_data_manager.p1_graveyard.size() > 0:
				game_data_manager.reorganize_showed_grave("player1")
		if Input.is_action_just_pressed("left click"):
			if game_data_manager.is_detailed == true:
				release_detail_card()
				game_data_manager.is_searching = true
				active_card.button_pressed = false
				release_searching_hand()
			if game_data_manager.p1_graveyard.size() > 0:
				game_data_manager.reorganize_showed_grave("player1")

func set_stats_value():
	race_label.text = str(RACE_ARRAY[PLAYER_CARDS[id].race])
	type_label.text = str(TYPE_ARRAY[PLAYER_CARDS[id].type])
	name_label.text = str(PLAYER_CARDS[id].name)
	mana_label.text = str(PLAYER_CARDS[id].mana_cost)
	health_label.text = str(PLAYER_CARDS[id].health)
	deffense_label.text = str(PLAYER_CARDS[id].defense)
	attack_label.text = str(PLAYER_CARDS[id].attack)

func set_stats_visible(cond):
	if PLAYER_CARDS[id].defense == 0:
		deffense_rect.visible = false
	else:
		deffense_rect.visible = true
	card_stats.visible = cond
	name_label.visible = cond
	type_label.visible = cond
	race_label.visible = cond

func set_play_menu(cond):
	play_menu.visible = cond

func detail_card():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(card_trans, "scale", Vector2(max_card_scale,max_card_scale), .3)
	if game_data_manager.is_in_grave == false:
		set_play_menu(true)
	active_card.visible = false
	top_level = true
	set_stats_visible(true)
	card_stats.visible = true
	card_stats.scale = Vector2(1,1)
	await get_tree().create_timer(.1).timeout

func release_detail_card():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(card_trans, "scale", Vector2(min_card_scale,min_card_scale), .3)
	set_play_menu(false)
	active_card.visible = true
	top_level = false
	set_stats_visible(false)
	await get_tree().create_timer(.1).timeout

func searching_hand():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, "scale", Vector2(1.1,1.1), .2)
	if PLAYER_CARDS[id].defense == 0:
		deffense_rect.visible = false
	else:
		deffense_rect.visible = true
	card_stats.visible = true
	card_stats.scale = Vector2(1.6,1.6)

func release_searching_hand():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, "scale", Vector2(min_card_scale,min_card_scale), .2)
	if PLAYER_CARDS[id].defense == 0:
		deffense_rect.visible = false
	else:
		deffense_rect.visible = false
	card_stats.visible = false
	card_stats.scale = Vector2(1,1)

func _on_use_card_toggled(toggled_on):
	if game_data_manager.is_starting == false:
		if toggled_on:
			detail_card()
			game_data_manager.is_searching = false
			game_data_manager.is_detailed = true
			game_data_manager.p1_body.append(self)
		if not toggled_on:
			release_detail_card()
			game_data_manager.is_searching = true
			game_data_manager.is_detailed = false
			game_data_manager.p1_body = []

func _on_active_card_mouse_entered():
	game_data_manager.is_on_button = true
	if game_data_manager.is_searching == true:
		searching_hand()

func _on_active_card_mouse_exited():
	game_data_manager.is_on_button = false
	if game_data_manager.is_searching == true:
		release_searching_hand()

func _on_play_button_pressed():
	if game_data_manager.is_starting == false:
		var current_slots
		var max_slots
		if PLAYER_CARDS[id].type == 0:
			current_slots = game_data_manager.p1_attack.size()
			max_slots = game_data_manager.p1_a_slots.size()
		if PLAYER_CARDS[id].type == 1:
			current_slots = game_data_manager.p1_defense.size()
			max_slots = game_data_manager.p1_d_slots.size()
		if PLAYER_CARDS[id].type == 2:
			current_slots = game_data_manager.p1_artefact.size()
			max_slots = game_data_manager.p1_ar_slots.size()
		if PLAYER_CARDS[id].type == 3:
			current_slots = game_data_manager.p1_action.size()
			max_slots = game_data_manager.p1_ac_slots.size()
		if current_slots < max_slots:
			game_data_manager.put(self)
			put_button.visible = false 
		else:
			print("no_size")
		change_slots_size()

func _on_put_button_pressed():
	if game_data_manager.is_starting == false:
		game_data_manager.destroy(self)
		change_slots_size()

func change_slots_size():
	game_data_manager.p1_dc_slots[0].card_count.text = str(game_data_manager.p1_deck.size())
	game_data_manager.p1_g_slots[0].card_count.text = str(game_data_manager.p1_graveyard.size())
