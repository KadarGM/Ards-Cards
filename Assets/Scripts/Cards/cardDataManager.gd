extends Node2D

var max_card_scale = 2.2
var min_card_scale = 1
var is_on_button = false

var game_data_manager = GameDataManager
@export var id: int
@export var id_in_slot: int
@export var slot_type: String
@export var type: int

@onready var stats_values = []
@onready var stats = CardDataList.card[id]

@onready var play_menu = $cardTrans/PlayMenu
@onready var put_button = $cardTrans/PlayMenu/HBoxContainer/VBoxContainer/PutButton
@onready var put_button_1 = $cardTrans/PlayMenu/HBoxContainer/VBoxContainer2/PutButton1
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

func _process(delta):
	if game_data_manager.is_searching == false:
		release_searching_hand()
	if is_on_button == false:
		if Input.is_action_just_pressed("right click"):
			game_data_manager.is_searching = true
			release_detail_card()
			await get_tree().create_timer(.1).timeout
		if Input.is_action_just_pressed("left click"):
			active_card.button_pressed = false
			await get_tree().create_timer(.1).timeout
	if is_on_button == true:
		if Input.is_action_just_pressed("right click"):
			game_data_manager.is_searching = true
			active_card.button_pressed = false
			await get_tree().create_timer(.1).timeout

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
	await get_tree().create_timer(.1).timeout
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(card_trans, "scale", Vector2(max_card_scale,max_card_scale), .3)
	set_stats_visible(true)
	set_play_menu(true)
	top_level = true

func release_detail_card():
	await get_tree().create_timer(.1).timeout
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(card_trans, "scale", Vector2(min_card_scale,min_card_scale), .3)
	set_stats_visible(false)
	set_play_menu(false)
	top_level = false

func searching_hand():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, "scale", Vector2(1.1,1.1), .2)
	

func release_searching_hand():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, "scale", Vector2(min_card_scale,min_card_scale), .2)

func _on_use_card_toggled(toggled_on):
	if toggled_on:
		detail_card()
		game_data_manager.is_searching = false
	if not toggled_on:
		release_detail_card()
		game_data_manager.is_searching = true

func _on_active_card_mouse_entered():
	if game_data_manager.is_searching == true:
		searching_hand()
	if Input.is_action_pressed("left click"):
		active_card.button_pressed = true
	is_on_button = true

func _on_active_card_mouse_exited():
	if game_data_manager.is_searching == true:
		release_searching_hand()
	if Input.is_action_pressed("left click"):
		active_card.button_pressed = false
	is_on_button = false

func _on_play_button_pressed():
	var current_slots
	var max_slots
	var min_slots
	if type == 0:
		current_slots = game_data_manager.p1_a_slots.size()
		max_slots = 4
		min_slots = 0
	if type == 1:
		current_slots = game_data_manager.p1_d_slots.size()
		max_slots = 4
		min_slots = 0
	if type == 2:
		current_slots = game_data_manager.p1_ar_slots.size()
		max_slots = 2
		min_slots = 0
	if current_slots > min_slots and current_slots <= max_slots:
		game_data_manager.put(self)
		put_button.visible = false 
	else:
		print("no_size")

func _on_put_button_pressed():
	game_data_manager.destroy(self)
