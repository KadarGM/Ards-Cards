extends Node2D

#region Variables, Constants
var max_card_scale = 2.2
var detailed_scale = 1.4
var min_card_scale = 1
var draggable = false
var is_inside_drop = false
var init_pos: Vector2
var body_ref
var offset: Vector2
var is_on_card = false
var is_selected = false
var can_desselect = false
var card_owner

var game_data_manager = GameDataManager

const CARDS_LIST: Array[CardDataResource] = [
	preload("res://Assets/Resources/Cards/testCard1.tres"),
	preload("res://Assets/Resources/Cards/testCard2.tres"),
	preload("res://Assets/Resources/Cards/testCard3.tres"),
	preload("res://Assets/Resources/Cards/testCard4.tres"),
	]

const TYPE_ARRAY = ["Attack Creature", "Defend Creature", "Artefact", "Action", "Spell", "Attack Elite", "Defend Elite", "Hero"]
const TYPE_SHORT_ARRAY = ["A", "D", "AR", "AC", "SP", "AE", "DE", "HE"]
const RACE_ARRAY = ["Forest", "Rusty", "Black", "Termite", "Yellow", "White"]
const HERO_ARRAY = []
const ELITE_ARRAY = []
const SPEC_ARRAY = ["Fighter", "Archer", "Sorcerer", "Dark_wizard", "Necromancer", "Shaman", "Rider shooter", "Elite", "Rider"]

const RACE_COLOR : Dictionary = {
	0 : Color(0.11, 0.69, 0.09), #Forest
	1 : Color(0.871, 0.541, 0.114), #Rusty
	2 : Color(0.114, 0.149, 0.149), #Black
	3 : Color(0.702, 0.74, 0.562), #Termite
	4 : Color(0.82, 0.74, 0.221), #Yellow
	5 : Color(1, 1, 1), #White
}

const RACE_TEXT_COLOR : Dictionary = {
	0 : Color(0.884, 1, 0.871), #Forest
	1 : Color(1, 0.979, 0.959), #Rusty
	2 : Color(0.917, 0.94, 0.94), #Black
	3 : Color(0.096, 0.107, 0.054), #Termite
	4 : Color(0.113, 0.097, 0.009), #Yellow
	5 : Color(0, 0, 0), #White
}

@export var id: int
@export var selected_id: int
@export var id_in_slot: int
@export var slot_type: String
@export var type: int

@onready var play_menu = $cardTrans/PlayMenu
@onready var use_button = $cardTrans/PlayMenu/HBoxContainer/VBoxContainer
@onready var destroy_button = $cardTrans/PlayMenu/HBoxContainer/VBoxContainer2
@onready var active_card = $cardTrans/ActiveCard
@onready var card_trans = $cardTrans
@onready var name_label = $cardTrans/NameLabel
@onready var card_stats = $cardTrans/CardStats
@onready var fg = $cardTrans/CardFG/FG
@onready var bg = $CardBG/BG
@onready var mana_label = $cardTrans/CardStats/LeftContainer/GridContainer/ManaRect/ManaSprite/ManaLabel
@onready var health_label = $cardTrans/CardStats/LeftContainer/GridContainer/HealthRect/HealthSprite/HealthLabel
@onready var deffense_label = $cardTrans/CardStats/LeftContainer/GridContainer/DeffenseRect/DeffenseSprite/DeffenseLabel
@onready var attack_label = $cardTrans/CardStats/LeftContainer/GridContainer/AttackRect/AttackSprite/AttackLabel
@onready var card_bg = $CardBG
@onready var type_label = $cardTrans/CardStats/LeftContainer/GridContainer/TypeRect/TypeSprite/TypeLabel
@onready var race_label = $cardTrans/RaceLabel
@onready var mana_rect = $cardTrans/CardStats/LeftContainer/GridContainer/ManaRect
@onready var health_rect = $cardTrans/CardStats/LeftContainer/GridContainer/HealthRect
@onready var deffense_rect = $cardTrans/CardStats/LeftContainer/GridContainer/DeffenseRect
@onready var attack_rect = $cardTrans/CardStats/LeftContainer/GridContainer/AttackRect
@onready var type_rect = $cardTrans/CardStats/LeftContainer/GridContainer/TypeRect
@onready var type_sprite = $cardTrans/CardStats/LeftContainer/GridContainer/TypeRect/TypeSprite
@onready var select_color = $cardTrans/SelectColor
@onready var ready_color = $cardTrans/ReadyColor
@onready var destroy_color = $cardTrans/DestroyColor


#endregion

func _ready():
	set_stats()
	set_stats_visible(false)
	destroy_button.visible = false
	card_trans.visible = false
	active_card.visible = false
	card_bg.visible = true

#region SET_CARD_STATS
func set_stats():
	type_label.text = str(TYPE_SHORT_ARRAY[CARDS_LIST[id].type])
	type_label.visible = true
	type_rect.color = RACE_COLOR[CARDS_LIST[id].race]
	type_sprite.modulate = RACE_TEXT_COLOR[CARDS_LIST[id].race]
	#CARDS_LIST[id].name
	name_label.visible = true
	name_label.text = CARDS_LIST[id].name
	name_label.add_theme_color_override("font_color", RACE_TEXT_COLOR[CARDS_LIST[id].race])
	#name_label.interpolate_property(get_stylebox("normal"), "bg_color", Color.red, Color.blue)
	#CARDS_LIST[id].description
	#descritption_label.text = str(CARDS_LIST[id].description)
	#CARDS_LIST[id].race
	#race_label.visible = true
	#race_label.text = RACE_ARRAY[CARDS_LIST[id].race]
	fg.modulate = RACE_COLOR[CARDS_LIST[id].race]
	#CARDS_LIST[id].picture
	#CARDS_LIST[id].mana_cost
	mana_label.text = str(CARDS_LIST[id].mana_cost)
	mana_rect.visible = true
	if CARDS_LIST[id].type == 0 or CARDS_LIST[id].type == 1: #Attack Creature, Defense Creature
		if CARDS_LIST[id].hero == 0 or CARDS_LIST[id].type == 1:
			#CARDS_LIST[id].hero
			pass
		if CARDS_LIST[id].elite == 0 or CARDS_LIST[id].type == 1:
			#CARDS_LIST[id].elite
			pass
		#CARDS_LIST[id].health
		health_label.text = str(CARDS_LIST[id].health)
		health_rect.visible = true
		deffense_rect.visible = false
		#CARDS_LIST[id].attack
		attack_label.text = str(CARDS_LIST[id].attack)
		attack_rect.visible = true
		#CARDS_LIST[id].specialization
		#specialization_label.text = str(SPEC_ARRAY[CARDS_LIST[id].specialization])
		if CARDS_LIST[id].will_cast == true:
			pass
			#if CARDS_LIST[id].when_cast != 0:
				#if CARDS_LIST[id].when_cast == 1:
					#CARDS_LIST[id].when_cast
					#CARDS_LIST[id].when_repeat
					#CARDS_LIST[id].when_value
				#if CARDS_LIST[id].when_cast == 2:
					#pass
				#if CARDS_LIST[id].when_cast == 3:
					#pass
				#if CARDS_LIST[id].when_cast == 4:
					#pass
				#if CARDS_LIST[id].when_cast == 5:
					#pass
			#if CARDS_LIST[id].what_cast != 0:
				#if CARDS_LIST[id].what_cast == 1:
					#CARDS_LIST[id].where_cast
					#CARDS_LIST[id].where_repeat
					#CARDS_LIST[id].where_value
				#if CARDS_LIST[id].what_cast == 2:
					#pass
				#if CARDS_LIST[id].what_cast == 3:
					#pass
				#if CARDS_LIST[id].what_cast == 4:
					#pass
				#if CARDS_LIST[id].what_cast == 5:
					#pass
				#if CARDS_LIST[id].what_cast == 6:
					#pass
				#if CARDS_LIST[id].what_cast == 7:
					#pass
				#if CARDS_LIST[id].what_cast == 8:
					#pass
			#if CARDS_LIST[id].where_cast != 0:
				#if CARDS_LIST[id].where_cast == 1:
					#CARDS_LIST[id].when_cast
					#CARDS_LIST[id].when_repeat
					#CARDS_LIST[id].when_value
				#if CARDS_LIST[id].where_cast == 2:
					#pass
				#if CARDS_LIST[id].where_cast == 3:
					#pass
				#if CARDS_LIST[id].where_cast == 4:
					#pass
				#if CARDS_LIST[id].where_cast == 5:
					#pass
				#if CARDS_LIST[id].where_cast == 6:
					#pass
				#if CARDS_LIST[id].where_cast == 7:
					#pass
				#if CARDS_LIST[id].where_cast == 8:
					#pass
			#if CARDS_LIST[id].whom_cast != 0:
				#if CARDS_LIST[id].whom_cast == 1:
					#CARDS_LIST[id].whom_cast
					#CARDS_LIST[id].whom_repeat
					#CARDS_LIST[id].whom_value
				#if CARDS_LIST[id].whom_cast == 2:
					#pass
				#if CARDS_LIST[id].whom_cast == 3:
					#pass
				#if CARDS_LIST[id].whom_cast == 4:
					#pass
	if CARDS_LIST[id].type == 2 or CARDS_LIST[id].type == 3 or CARDS_LIST[id].type == 4:
		health_rect.visible = false
		attack_rect.visible = false
		deffense_rect.visible = false
#endregion

func select_card_in_slot(_player,select,selected_slot_array,selected_type_array):
	var selected_slot
	var selected_type
	if select.is_selected == false:
		for t in range(selected_type_array.size()):
			if select.slot_type == game_data_manager.TYPE_ARRAY[t]:
				selected_slot = selected_slot_array[t]
				selected_type = selected_type_array[t]
				break
		selected_slot.append(selected_type[select.id_in_slot])
		re_id_select(selected_slot)
		selected_slot[select.selected_id].select_color.visible = true
		select.is_selected = true
	else:
		return

func deselect_card_in_slot(_player,select,selected_slot_array,selected_type_array):
	var selected_slot
	var selected_type
	if select.is_selected == true:
		for t in range(selected_type_array.size()):
			if select.slot_type == game_data_manager.TYPE_ARRAY[t]:
				selected_slot = selected_slot_array[t]
				selected_type = selected_type_array[t]
				break
		selected_type[select.id_in_slot].select_color.visible = false
		select.is_selected = false
		selected_slot.remove_at(select.selected_id)
		re_id_select(selected_slot)
	else:
		return

func re_id_select(selected_slot):
	for i in range(selected_slot.size()):
			selected_slot[i].selected_id = i

#region UI
func set_stats_visible(cond): # Sets the visibility of various UI elements related to card statistics.
	card_stats.visible = cond
	name_label.visible = cond

func change_slots_size(): # Updates the count of cards in the player's deck and graveyard slots.
	game_data_manager.p1_dc_slots[0].card_count.text = str(game_data_manager.p1_deck.size())
	game_data_manager.p1_g_slots[0].card_count.text = str(game_data_manager.p1_graveyard.size())
#endregion

#region Searching Cards
func searching_hand(): # Enlarges the card when it is being searched for.
	game_data_manager.is_detailed = true
	card_animation(card_trans,"scale",Vector2(detailed_scale,detailed_scale), .5)
	card_stats.visible = true
	card_animation(card_stats,"scale",Vector2(1.6,1.6), .5)
	top_level = true
	await get_tree().create_timer(.1).timeout
	top_level = true

func release_searching_hand(): # Restores the card to its original size after it has been searched for.
	game_data_manager.is_detailed = true
	card_animation(card_trans,"scale",Vector2(min_card_scale,min_card_scale), .5)
	card_stats.visible = false
	top_level = false
	await get_tree().create_timer(.1).timeout
	top_level = false
#endregion

func card_animation(body,parametr,how_many, time):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(body, parametr, how_many, time)

func _on_active_card_mouse_entered(): # Handles mouse entering the active card area.
	is_on_card = true
	if game_data_manager.players_turn == "player1":
			if game_data_manager.is_dragging == false:
				game_data_manager.p1_selected = []
				game_data_manager.p1_selected.append(self)
				draggable = true
			if game_data_manager.is_searching == true:
				searching_hand()
				self.top_level = true
	elif game_data_manager.players_turn == "player2":
			if game_data_manager.is_dragging == false:
				game_data_manager.p2_selected = []
				game_data_manager.p2_selected.append(self)
				draggable = true
			if game_data_manager.is_searching == true:
				searching_hand()
				self.top_level = true
	
func _on_active_card_mouse_exited(): # Handles mouse exiting the active card area.
	is_on_card = false
	if game_data_manager.players_turn == "player1":
		game_data_manager.p1_selected[0].name_label.visible = false
		if game_data_manager.is_dragging == false:
			game_data_manager.p1_selected = []
			draggable = false
		if game_data_manager.is_searching == true:
			release_searching_hand()
			self.top_level = false
	elif game_data_manager.players_turn == "player2":
		game_data_manager.p2_selected[0].name_label.visible = false
		if game_data_manager.is_dragging == false:
			game_data_manager.p2_selected = []
			draggable = false
		if game_data_manager.is_searching == true:
			release_searching_hand()
			self.top_level = false

func _on_drag_area_body_entered(body):
	if body.is_in_group('dropable'):
		is_inside_drop = true

func _on_drag_area_body_exited(body):
	if body.is_in_group('dropable'):
		is_inside_drop = false

func if_dragged_release(select,slot_type_array):
	game_data_manager.slot_visible(game_data_manager.players_turn,false,game_data_manager.TYPE_ARRAY,select,slot_type_array)
	await get_tree().create_timer(.05).timeout
	if self.is_on_card == false:
		release_searching_hand()
		game_data_manager.is_searching = true
	if self.is_on_card == true:
		game_data_manager.is_searching = true

func process(player,select,selected_slot_array,type_array,slot_type_array,hand):
	if game_data_manager.is_starting == false:
		if (select.size() > 0 and select[0].slot_type != "hand" and select[0].slot_type != "deck" and select[0].slot_type != "grave" and game_data_manager.is_grave_active == false and game_data_manager.is_deck_active == false):
				if select[0].can_desselect == false and select[0].card_owner == game_data_manager.players_turn:
					if Input.is_action_just_pressed("left click"):
						select_card_in_slot(player,select[0],selected_slot_array,type_array)
						await get_tree().create_timer(.1).timeout
						select[0].can_desselect = true
				if select[0].can_desselect == true and select[0].card_owner == game_data_manager.players_turn:
					if Input.is_action_just_pressed("left click"):
						deselect_card_in_slot(player,select[0],selected_slot_array,type_array)
						await get_tree().create_timer(.1).timeout
						select[0].can_desselect = false
		if game_data_manager.is_detailed == true and is_on_card == true: #and game_data_manager.is_dragging == false:
			if Input.is_action_pressed("right click"):
				game_data_manager.is_max_detailed = true
				card_animation(select[0].card_trans,"scale",Vector2(max_card_scale,max_card_scale), .5)
				card_animation(select[0].card_stats,"scale",Vector2(1.2,1.2), .5)
				select[0].name_label.visible = true
			elif Input.is_action_just_released("right click"):
				game_data_manager.is_max_detailed = false
				card_animation(select[0].card_trans,"scale",Vector2(detailed_scale,detailed_scale), .5)
				card_animation(select[0].card_stats,"scale",Vector2(1.6,1.6), .5)
				select[0].name_label.visible = false
		if draggable == true and select.size() > 0 and select[0].slot_type == "hand" and game_data_manager.can_dragging == true:
			if player == select[0].card_owner:
				if Input.is_action_just_pressed("left click"):
					init_pos = select[0].global_position
					offset = get_global_mouse_position() - select[0].global_position
					game_data_manager.is_dragging = true
					game_data_manager.slot_visible(player,true,game_data_manager.TYPE_ARRAY,select,slot_type_array)
					game_data_manager.is_searching = false
				if Input.is_action_pressed("left click"):
					select[0].global_position = get_global_mouse_position() - offset
				elif Input.is_action_just_released("left click"):
					game_data_manager.is_dragging = false
					if is_inside_drop == true:
						var put_type
						var put_slot_type
						for i in range(type_array.size()):
							if select[0].type == i:
								put_type = type_array[i]
								put_slot_type = slot_type_array[i]
								break
						if put_type.size() < put_slot_type.size():
							game_data_manager.put(player,select[0],hand,type_array,slot_type_array)
						else:
							card_animation(select[0],"global_position",init_pos, .2)
							if_dragged_release(select,slot_type_array)
						change_slots_size()
						if_dragged_release(select,slot_type_array)
					else:
						card_animation(select[0],"global_position",init_pos, .2)
						if_dragged_release(select,slot_type_array)
			else:
				return

func _process(_delta):
	var P1_TYPE_ARRAYS = [game_data_manager.p1_attack,game_data_manager.p1_defense,game_data_manager.p1_artefact,game_data_manager.p1_action]
	var P2_TYPE_ARRAYS = [game_data_manager.p2_attack,game_data_manager.p2_defense,game_data_manager.p2_artefact,game_data_manager.p2_action]
	var P1_SLOT_TYPE_ARRAYS = [game_data_manager.p1_a_slots,game_data_manager.p1_d_slots,game_data_manager.p1_ar_slots,game_data_manager.p1_ac_slots]
	var P2_SLOT_TYPE_ARRAYS = [game_data_manager.p2_a_slots,game_data_manager.p2_d_slots,game_data_manager.p2_ar_slots,game_data_manager.p2_ac_slots]
	var P1_SLOT_SELECTED_ARRAY = [game_data_manager.p1_a_selected,game_data_manager.p1_d_selected,game_data_manager.p1_ar_selected,game_data_manager.p1_ac_selected]
	var P2_SLOT_SELECTED_ARRAY = [game_data_manager.p2_a_selected,game_data_manager.p2_d_selected,game_data_manager.p2_ar_selected,game_data_manager.p2_ac_selected]
	if game_data_manager.players_turn == "player1":
		process(game_data_manager.players_turn,game_data_manager.p1_selected,P1_SLOT_SELECTED_ARRAY,P1_TYPE_ARRAYS,P1_SLOT_TYPE_ARRAYS,game_data_manager.p1_hand)
	elif game_data_manager.players_turn == "player2":
		process(game_data_manager.players_turn,game_data_manager.p2_selected,P2_SLOT_SELECTED_ARRAY,P2_TYPE_ARRAYS,P2_SLOT_TYPE_ARRAYS,game_data_manager.p2_hand)
	
