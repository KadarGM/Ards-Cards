extends Node

#region Variables
#conditions
var is_searching = true
var is_grave_active = false
var is_deck_active = false
var is_detailed = false
var is_max_detailed = false
var is_starting = false
var can_dragging = true
var is_dragging = false


var who_is_starting
var who_is_attacking
var who_is_defending
var who_is_ending
var who_can_cast

var players_turn
var count_round = 0
var turn_count = 0

#region Player 1 arrays
var p1_selected = []
var p1_dc_selected = []
var p1_g_selected = []
var p1_a_selected = []
var p1_ac_selected = []
var p1_d_selected = []
var p1_ar_selected = []

var p1_deck = []
var p1_graveyard = []
var p1_hand = []
var p1_attack = []
var p1_defense = []
var p1_artefact = []
var p1_action = []

var p1_dc_slots = []
var p1_g_slots = []
var p1_a_slots = []
var p1_ac_slots = []
var p1_d_slots = []
var p1_ar_slots = []
#endregion

#region Player 2 arrays
var p2_selected = []
var p2_dc_selected = []
var p2_g_selected = []
var p2_a_selected = []
var p2_ac_selected = []
var p2_d_selected = []
var p2_ar_selected = []

var p2_deck = []
var p2_graveyard = []
var p2_hand = []
var p2_attack = []
var p2_defense = []
var p2_artefact = []
var p2_action = []

var p2_dc_slots = []
var p2_g_slots = []
var p2_a_slots = []
var p2_ac_slots = []
var p2_d_slots = []
var p2_ar_slots = []

#endregion

var P1_TYPE_ARRAYS = [p1_attack,p1_defense,p1_artefact,p1_action]
var P2_TYPE_ARRAYS = [p2_attack,p2_defense,p2_artefact,p2_action]
var P1_SLOT_TYPE_ARRAYS = [p1_a_slots,p1_d_slots,p1_ar_slots,p1_ac_slots]
var P2_SLOT_TYPE_ARRAYS = [p2_a_slots,p2_d_slots,p2_ar_slots,p2_ac_slots]
var P1_SLOT_SELECTED_ARRAY = [p1_a_selected,p1_d_selected,p1_ar_selected,p1_ac_selected]
var P2_SLOT_SELECTED_ARRAY = [p2_a_selected,p2_d_selected,p2_ar_selected,p2_ac_selected]

const TYPE_ARRAY = [
	"attack",
	"defense",
	"artefact",
	"action",
	"grave",
	"deck",
	]

const TYPE_COUNT = [4,4,2,1,1,1]

const TURN_TYPE_ARRAY = [" attack!", " defend!", " ending!"]
const PLAYER_TEXT_ARRAY = ["player1", "player2"]

func reset(): # Reset all player-related variables to their initial states.

	is_searching = true
	is_grave_active = false
	is_deck_active = false
	is_detailed = false
	is_max_detailed = false
	is_starting = false
	can_dragging = true
	is_dragging = false
	turn_count = 0
	count_round = 0

	#region Player 1 arrays
	p1_selected = []
	p1_dc_selected = []
	p1_g_selected = []
	p1_a_selected = []
	p1_ac_selected = []
	p1_d_selected = []
	p1_ar_selected = []

	p1_deck = []
	p1_graveyard = []
	p1_hand = []
	p1_attack = []
	p1_defense = []
	p1_artefact = []
	p1_action = []

	p1_dc_slots = []
	p1_g_slots = []
	p1_a_slots = []
	p1_ac_slots = []
	p1_d_slots = []
	p1_ar_slots = []
	
	#endregion

	#region Player 2 arrays
	p2_selected = []
	p2_dc_selected = []
	p2_g_selected = []
	p2_a_selected = []
	p2_ac_selected = []
	p2_d_selected = []
	p2_ar_selected = []

	p2_deck = []
	p2_graveyard = []
	p2_hand = []
	p2_attack = []
	p2_defense = []
	p2_artefact = []
	p2_action = []

	p2_dc_slots = []
	p2_g_slots = []
	p2_a_slots = []
	p2_ac_slots = []
	p2_d_slots = []
	p2_ar_slots = []
	
#endregion

func reset_board_next_turn(selected_slot_array,selected_type_array):
	for i in range(selected_type_array.size()):
		for s in range (selected_type_array[i].size()):
			selected_type_array[i][s].select_color.visible = false
			selected_type_array[i][s].is_selected = false
			selected_type_array[i][s].can_desselect = false
			selected_slot_array[i] = []

func put(player,body,hand,type_arrays,slot_types_arrays): # Place a card into its corresponding slot based on its type.
	var spacing
	var x
	var y
	if player == "player1":
		spacing = -150
		x = 1920
		y = 1800
	elif player == "player2":
		spacing = 150
		x = 1920
		y = 300
	for a in range(type_arrays.size()):
		if body.CARDS_LIST[body.id].type == a:
			for s in range(slot_types_arrays[a].size()):
				if slot_types_arrays[a][s].is_empty == true:
					body.slot_type = TYPE_ARRAY[a]
					type_arrays[a].append(body)
					hand.remove_at(body.id_in_slot)
					type_arrays[a][s].id_in_slot = s
					slot_types_arrays[a][s].is_empty = false
					card_animation(body, "position",slot_types_arrays[a][s].position)
					break
	if hand.size() > 0:
		reorganize_hand(player,hand,spacing,x,y)
	await get_tree().create_timer(.3).timeout
	body.release_searching_hand()
	is_searching = true

func slot_visible(_player,cond,slot_type,select,slot_types_arrays):
	if cond == true:
		slot_type = slot_types_arrays[select[0].id]
		for i in range(slot_type.size()):
			if slot_type[i].is_empty == true:
				slot_type[i].color_rect.visible = true
			if slot_type[i].is_empty == false:
				slot_type[i].color_rect.visible = false
	elif cond == false:
		for i in range(slot_types_arrays.size()):
			slot_type = slot_types_arrays[i]
			for j in range(slot_type.size()):
				slot_type[j].color_rect.visible = false

func destroy(player,body): # Destroy a card and move it to the graveyard.
	var grave
	var grave_slot
	var card_body = body
	var type_arrays
	var slot_types_arrays
	var deck
	if player == "player1":
		grave = p1_graveyard
		grave_slot = p1_g_slots
		type_arrays = P1_TYPE_ARRAYS
		slot_types_arrays = P1_SLOT_TYPE_ARRAYS
		deck = p1_deck
	elif player == "player2":
		grave = p2_graveyard
		grave_slot = p2_g_slots
		type_arrays = P2_TYPE_ARRAYS
		slot_types_arrays = P2_SLOT_TYPE_ARRAYS
		deck = p2_deck
	if card_body.slot_type == "deck":
		grave.append(card_body)
		deck.remove_at(card_body.id_in_slot)
		card_body.slot_type = "grave"
		card_animation(card_body, "position", grave_slot[0].position)
		print("works?")
	elif card_body.slot_type != "deck":
		for i in range(type_arrays.size()):
			if card_body.slot_type == TYPE_ARRAY[i]:
				slot_types_arrays[i][card_body.id_in_slot].is_empty = true
				grave.append(card_body)
				if slot_types_arrays[i][card_body.id_in_slot].is_selected == true:
					slot_types_arrays[i][card_body.id_in_slot].select_color.visible = false
					slot_types_arrays[i][card_body.id_in_slot].is_selected = false
				type_arrays[i].remove_at(card_body.id_in_slot)
				card_body.slot_type = "grave"
				reorganize_slot(type_arrays[i], slot_types_arrays[i])
				card_animation(card_body, "position", grave_slot[0].position)
				break
	card_body.z_index = grave_slot.size()
	card_body.card_bg.visible = true
	card_body.card_trans.visible = false
	is_searching = true

func reorganize_slot(type,slot_type): # Reorganize slots after a card is destroyed.
	for c in range(type.size()):
		type[c].id_in_slot = c
		slot_type[c].is_empty = false
		slot_type[type.size()].is_empty = true
		card_animation(type[c],"position:x",slot_type[c].position.x)

func show_grave(player): # Show the graveyard for a player.
	var grave
	var card_spacing_x
	var card_spacing_y
	var start_x
	var start_y
	var x_multiplier
	var y_multiplier
	if player == "player1":
		card_spacing_x = 200
		card_spacing_y = 280
		start_x = 3000
		start_y = 480
		grave = p1_graveyard
	elif player == "player2":
		card_spacing_x = 200
		card_spacing_y = 280
		start_x = 3000
		start_y = 480
		grave = p2_graveyard
	for c in range(grave.size()):
		y_multiplier = floor(c/12)
		if c%12 == 0:
			x_multiplier = 0
		if c%12 != 0:
			x_multiplier += 1
		grave[c].id_in_slot = c
		card_animation(grave[c],"position:x",start_x - (card_spacing_x * x_multiplier))
		card_animation(grave[c],"position:y",start_y + (card_spacing_y * y_multiplier))
		grave[c].card_bg.visible = false
		grave[c].card_trans.visible = true
		grave[c].active_card.visible = true
		await get_tree().create_timer(0.01).timeout

func show_deck(player): # Show the deck for a player.
	var deck
	var card_spacing_x
	var card_spacing_y
	var start_x
	var start_y
	var x_multiplier
	var y_multiplier
	if player == "player1":
		card_spacing_x = 200
		card_spacing_y = 280
		start_x = 3000
		start_y = 480
		deck = p1_deck
	elif player == "player2":
		card_spacing_x = 200
		card_spacing_y = 280
		start_x = 3000
		start_y = 480
		deck = p2_deck
	for c in range(deck.size()):
		y_multiplier = floor(c/12)
		if c%12 == 0:
			x_multiplier = 0
		if c%12 != 0:
			x_multiplier += 1
		#start_y += 280
		deck[c].id_in_slot = c
		card_animation(deck[c],"position:x",start_x - (card_spacing_x * x_multiplier))
		card_animation(deck[c],"position:y",start_y + (card_spacing_y * y_multiplier))
		deck[c].card_bg.visible = false
		deck[c].card_trans.visible = true
		deck[c].active_card.visible = true
		await get_tree().create_timer(0.01).timeout

func reorganize_showed_grave(player): # Reorganize the displayed graveyard for a player.
	var grave
	if player == "player1":
		grave = p1_graveyard
	elif player == "player2":
		grave = p2_graveyard
	for c in range(grave.size()):
		grave[c].z_index = c + 11
		grave[c].release_searching_hand()

func reorganize_showed_deck(player): # Reorganize the displayed graveyard for a player.
	if player == "player1":
		for c in range(p1_deck.size()):
			p1_deck[c].z_index = 11
			p1_deck[c].top_level = true
			p1_deck[c].release_searching_hand()
	elif player == "player2":
		for c in range(p2_deck.size()):
			p2_deck[c].z_index = 11
			p2_deck[c].top_level = true
			p2_deck[c].release_searching_hand()

func hide_grave(player): # Hide the graveyard for a player.
	var grave
	var grave_slot
	if player == "player1":
		grave = p1_graveyard
		grave_slot = p1_g_slots
	elif player == "player2":
		grave = p2_graveyard
		grave_slot = p2_g_slots
	for i in range(grave.size()):
		grave[i].release_searching_hand()
		grave[i].card_bg.visible = true
		grave[i].card_trans.visible = false
		grave[i].active_card.visible = false
		card_animation(grave[i],"position", grave_slot[0].position)
		await get_tree().create_timer(0.01).timeout

func hide_deck(player): # Hide the graveyard for a player.
	var deck
	var deck_slot
	if player == "player1":
		deck = p1_deck
		deck_slot = p1_dc_slots
	elif player == "player2":
		deck = p2_deck
		deck_slot = p2_dc_slots
	for i in range(deck.size()):
		deck[i].release_searching_hand()
		deck[i].card_bg.visible = true
		deck[i].card_trans.visible = false
		deck[i].active_card.visible = false
		card_animation(deck[i],"position", deck_slot[0].position)
		await get_tree().create_timer(0.01).timeout

func reorganize_hand(_player,hand,card_spacing,start_x,y_pos): # Reorganize the hand of a player.
	for c in range(hand.size()):
		hand[c].id_in_slot = c
		card_animation(hand[c],"position:x",start_x + (card_spacing * c))
		hand[c].position.y = y_pos

func card_animation(who,what,where): # Perform animations for card movements.
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(who, what, where, .5)
	await get_tree().create_timer(.5).timeout

#func _process(_delta):
	#if is_starting == false:
		#if players_turn == "player1":
			#process(players_turn,p1_selected,P1_TYPE_ARRAYS,P1_SLOT_TYPE_ARRAYS,p1_graveyard,p1_g_slots,p1_hand,p1_deck,-150,1920,1800,p1_is_attacking,p1_is_defending,p1_is_ending)
		#elif players_turn == "player2":
			#process(players_turn,p2_selected,P2_TYPE_ARRAYS,P2_SLOT_TYPE_ARRAYS,p2_graveyard,p2_g_slots,p2_hand,p2_deck,150,1920,300,p2_is_attacking,p2_is_defending,p2_is_ending)
		#else:
			#print("No player selected!")
#
#func process(player,select,type_arrays,slot_types_arrays,grave,grave_slot,hand,deck,card_spacing,start_x,y_pos,attack,defend,ending):
		#if is_detailed == true and is_grave_active == false and is_dragging == false and is_deck_active == false and select.size() > 0 and select[0].card_owner == player:
			#if Input.is_action_just_pressed("e key"):
				#if select[0].slot_type == "hand":
					#var current_slots
					#var max_slots
					#for i in range(type_arrays.size()):
						#if select[0].CARDS_LIST[select[0].id].type == i:
							#current_slots = type_arrays[i].size()
							#max_slots = slot_types_arrays[i].size()
					#if current_slots < max_slots:
						#put(player,select[0],hand,type_arrays,slot_types_arrays)
						#select[0].use_button.visible = false 
					#else:
						#print("no_size")
					#select[0].change_slots_size()
				#select[0].active_card.button_pressed = false
			#if Input.is_action_just_pressed("r key"):
				#is_searching = true
				#if select[0].slot_type != "hand" and select[0].slot_type != "grave" and select[0].slot_type != "deck":
					#select[0].change_slots_size()
					#select[0].active_card.button_pressed = false
					#destroy(player,select[0])
				#elif select[0].slot_type == "hand":
					#grave.append(select[0])
					#hand.remove_at(select[0].id_in_slot)
					#select[0].slot_type = "grave"
					#reorganize_hand(player,hand,card_spacing,start_x,y_pos)
					#card_animation(select[0],"position", grave_slot[0].position)
					#select[0].z_index = grave_slot.size()
					#select[0].card_bg.visible = true
					#select[0].card_trans.visible = false
		#if Input.is_action_just_pressed("g key"):
			#if grave.size() > 0 and is_dragging == false and is_grave_active == false:
				#if is_detailed == true:
					#is_searching = true
				#if is_grave_active == false:
					#show_grave(player)
					#is_grave_active = true
					#reorganize_showed_grave(player)
			#elif is_grave_active == true:
				#hide_grave(player)
				#is_grave_active = false
		#if Input.is_action_just_pressed("d key"):
			#if deck.size() > 0 and is_dragging == false and is_deck_active == false:
				#if is_detailed == true:
					#is_searching = true
				#if is_deck_active == false:
					#show_deck(player)
					#is_deck_active = true
					#reorganize_showed_deck(player)
			#elif is_deck_active == true:
				#hide_deck(player)
				#is_deck_active = false
		#if select.size() > 0 and select[0].card_owner == player:
			#if select[0].slot_type == "grave":
				#if is_grave_active == true:
					#for i in range(grave.size()):
						#grave[i].z_index = i + 5
					#select[0].z_index = p1_graveyard.size() + 4
				#if is_grave_active == false:
					#reorganize_showed_grave(player)
			#elif select[0].slot_type == "deck":
				#if is_grave_active == true:
					#for i in range(deck.size()):
						#deck[i].z_index = i + 5
					#select[0].z_index = deck.size() + 4
				#if is_deck_active == false:
					#reorganize_showed_deck(player)
