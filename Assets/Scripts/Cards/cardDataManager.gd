extends Node2D

var max_card_scale = 2.2
var min_card_scale = 1


var game_data_manager = GameDataManager

@export var id: int
@export var id_in_slot: int
@export var slot_type: String
@export var type: int

@onready var stats_values = []
@onready var stats = CardDataList.card[id]

@onready var play_menu = $cardTrans/PlayMenu
@onready var put_button = $cardTrans/PlayMenu/HBoxContainer/VBoxContainer
@onready var put_button_1 = $cardTrans/PlayMenu/HBoxContainer/VBoxContainer2
@onready var active_card = $ActiveCard

@onready var card_trans = $cardTrans
@onready var name_label = $cardTrans/CardFG/NameLabel
@onready var color_rect = $cardTrans/CardFG/ColorRect

@onready var card_stats = $cardTrans/CardStats
@onready var fg = $cardTrans/CardFG/FG

@onready var mana_label = $cardTrans/CardStats/LeftContainer/GridContainer/ManaSprite/ManaLabel
@onready var health_label = $cardTrans/CardStats/LeftContainer/GridContainer/HealthSprite/HealthLabel
@onready var deffense_label = $cardTrans/CardStats/LeftContainer/GridContainer/DeffenseSprite/DeffenseLabel
@onready var attack_label = $cardTrans/CardStats/LeftContainer/GridContainer/AttackSprite/AttackLabel

@onready var card_bg = $CardBG
@onready var type_label = $TypeLabel

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
	color_rect.modulate = fg.modulate
	#put_button.modulate = fg.modulate

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
			#if game_data_manager.is_detailed == false:
				#game_data_manager.hide_grave("player1")
				
		if Input.is_action_just_pressed("left click"):
			if game_data_manager.is_detailed == true:
				release_detail_card()
				game_data_manager.is_searching = true
				active_card.button_pressed = false
				release_searching_hand()
			if game_data_manager.p1_graveyard.size() > 0:
				game_data_manager.reorganize_showed_grave("player1")

func set_stats_value():
	stats_values = stats
	type_label.text = str(type)
	name_label.text = str(stats_values[0])
	mana_label.text = str(stats_values[1])
	health_label.text = str(stats_values[2])
	deffense_label.text = str(stats_values[3])
	attack_label.text = str(stats_values[4])

func set_stats_visible(cond):
	card_stats.visible = cond
	color_rect.visible = cond
	name_label.visible = cond

func set_play_menu(cond):
	play_menu.visible = cond

func detail_card():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(card_trans, "scale", Vector2(max_card_scale,max_card_scale), .3)
	print(id_in_slot)
	set_stats_visible(true)
	if game_data_manager.is_in_grave == false:
		set_play_menu(true)
	top_level = true
	await get_tree().create_timer(.1).timeout

func release_detail_card():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(card_trans, "scale", Vector2(min_card_scale,min_card_scale), .3)
	set_stats_visible(false)
	set_play_menu(false)
	top_level = false
	await get_tree().create_timer(.1).timeout

func searching_hand():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, "scale", Vector2(1.1,1.1), .2)

func release_searching_hand():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, "scale", Vector2(min_card_scale,min_card_scale), .2)

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
		if type == 0:
			current_slots = game_data_manager.p1_attack.size()
			max_slots = game_data_manager.p1_a_slots.size()
		if type == 1:
			current_slots = game_data_manager.p1_defense.size()
			max_slots = game_data_manager.p1_d_slots.size()
		if type == 2:
			current_slots = game_data_manager.p1_artefact.size()
			max_slots = game_data_manager.p1_ar_slots.size()
		if type == 3:
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
