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

#arrays
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

var p2_hand = []
#endregion

var SLOT_TYPES_ARRAY = [p1_a_slots,p1_d_slots,p1_ar_slots,p1_ac_slots]

func reset(): # Reset all player-related variables to their initial states.

	is_searching = true
	is_grave_active = false
	is_deck_active = false
	is_detailed = false
	is_starting = false
	can_dragging = true
	is_dragging = false

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

	p2_hand = []

func _process(_delta):
	if p1_selected.size() > 0 and p1_selected[0].slot_type == "grave":
		if is_grave_active == true:
			for i in range(p1_graveyard.size()):
				p1_graveyard[i].z_index = i + 5
			p1_selected[0].z_index = p1_graveyard.size() + 4
		if is_grave_active == false:
			reorganize_showed_grave("player1")

	if p1_selected.size() > 0 and p1_selected[0].slot_type == "deck":
		if is_grave_active == true:
			for i in range(p1_deck.size()):
				p1_deck[i].z_index = i + 5
			p1_selected[0].z_index = p1_deck.size() + 4
		if is_deck_active == false:
			reorganize_showed_deck("player1")

	if Input.is_action_just_pressed("e key"):
		if is_starting == false and is_detailed == true and is_grave_active == false and is_dragging == false and is_deck_active == false:
			if p1_selected[0].slot_type == "hand":
				var current_slots
				var max_slots
				if p1_selected[0].CARDS_LIST[p1_selected[0].id].type == 0:
					current_slots = p1_attack.size()
					max_slots = p1_a_slots.size()
				if p1_selected[0].CARDS_LIST[p1_selected[0].id].type == 1:
					current_slots = p1_defense.size()
					max_slots = p1_d_slots.size()
				if p1_selected[0].CARDS_LIST[p1_selected[0].id].type == 2:
					current_slots = p1_artefact.size()
					max_slots = p1_ar_slots.size()
				if p1_selected[0].CARDS_LIST[p1_selected[0].id].type == 3:
					current_slots = p1_action.size()
					max_slots = p1_ac_slots.size()
				if current_slots < max_slots:
					put(p1_selected[0])
					p1_selected[0].use_button.visible = false 
				else:
					print("no_size")
				p1_selected[0].change_slots_size()
			p1_selected[0].active_card.button_pressed = false

	if Input.is_action_just_pressed("r key"):
		if is_starting == false and is_detailed == true and is_grave_active == false and is_dragging == false and is_deck_active == false:
			is_searching = true
			if p1_selected[0].slot_type != "hand" and p1_selected[0].slot_type != "grave" and p1_selected[0].slot_type != "deck":
				p1_selected[0].change_slots_size()
				p1_selected[0].active_card.button_pressed = false
				destroy(p1_selected[0])
				
			elif p1_selected[0].slot_type == "hand":
				p1_graveyard.append(p1_selected[0])
				p1_hand.remove_at(p1_selected[0].id_in_slot)
				p1_selected[0].slot_type = "grave"
				reorganize_hand("player1")
				card_animation(p1_selected[0],"position", p1_g_slots[0].position)
				p1_selected[0].z_index = p1_g_slots.size()
				p1_selected[0].card_bg.visible = true
				p1_selected[0].card_trans.visible = false
		
	if Input.is_action_just_pressed("g key"):
		if is_starting == false and p1_graveyard.size() > 0 and is_dragging == false and is_deck_active == false:
			if is_detailed == true:
				is_searching = true
			if is_grave_active == false:
				show_grave("player1")
				is_grave_active = true
				reorganize_showed_grave("player1")
			elif is_grave_active == true:
				hide_grave("player1")
				is_grave_active = false

	if Input.is_action_just_pressed("d key"):
		if is_starting == false and p1_deck.size() > 0 and is_dragging == false and is_grave_active == false:
			if is_detailed == true:
				is_searching = true
			if is_deck_active == false:
				show_deck("player1")
				is_deck_active = true
				reorganize_showed_deck("player1")
			elif is_deck_active == true:
				hide_deck("player1")
				is_deck_active = false

func put(body): # Place a card into its corresponding slot based on its type.
	var card_body = body
	if card_body.CARDS_LIST[body.id].type == 0:
		for i in range(p1_a_slots.size()):
			if p1_a_slots[i].is_empty == 1:
				card_body.slot_type = "p1_attack"
				p1_attack.append(card_body)
				p1_hand.remove_at(card_body.id_in_slot)
				p1_attack[i].id_in_slot = i
				p1_a_slots[i].is_empty = 0
				card_animation(card_body, "position",p1_a_slots[i].position)
				break
	if card_body.CARDS_LIST[body.id].type == 1:
		for i in range(p1_d_slots.size()):
			if p1_d_slots[i].is_empty == 1:
				card_body.slot_type = "p1_defense"
				p1_defense.append(card_body)
				p1_hand.remove_at(card_body.id_in_slot)
				p1_defense[i].id_in_slot = i
				p1_d_slots[i].is_empty = 0
				card_animation(card_body, "position", p1_d_slots[i].position)
				break
	if card_body.CARDS_LIST[body.id].type == 2:
		for i in range(p1_ar_slots.size()):
			if p1_ar_slots[i].is_empty == 1:
				card_body.slot_type = "p1_artefact"
				p1_artefact.append(card_body)
				p1_hand.remove_at(card_body.id_in_slot)
				p1_artefact[i].id_in_slot = i
				p1_ar_slots[i].is_empty = 0
				card_animation(card_body, "position", p1_ar_slots[i].position)
				break
	if card_body.CARDS_LIST[body.id].type == 3:
		for i in range(p1_ac_slots.size()):
			if p1_ac_slots[i].is_empty == 1:
				card_body.slot_type = "p1_action"
				p1_action.append(card_body)
				p1_hand.remove_at(card_body.id_in_slot)
				p1_action[i].id_in_slot = i
				p1_ac_slots[i].is_empty = 0
				card_animation(card_body, "position", p1_ac_slots[i].position)
				break
	if p1_hand.size() > 0:
		reorganize_hand("player1")
	await get_tree().create_timer(.3).timeout
	body.release_searching_hand()
	is_searching = true
	#print("p1_dc_slots: ",p1_dc_slots)
	#print("p1_g_slots: ",p1_g_slots)
	#print("p1_a_slots: ",p1_a_slots)
	#print("p1_ac_slots: ",p1_ac_slots)
	#print("p1_d_slots: ",p1_d_slots)
	#print("p1_ar_slots: ",p1_ar_slots)

func slot_visible(player,cond):
	var slot_type
	if player == "player1":
		if is_starting == false:
			if cond == true:
				slot_type = SLOT_TYPES_ARRAY[p1_selected[0].id]
				for i in range(slot_type.size()):
					if slot_type[i].is_empty == 1:
						slot_type[i].color_rect.visible = true
					if slot_type[i].is_empty == 0:
						slot_type[i].color_rect.visible = false
			elif cond == false:
				for i in range(SLOT_TYPES_ARRAY.size()):
					slot_type = SLOT_TYPES_ARRAY[i]
					for j in range(slot_type.size()):
						slot_type[j].color_rect.visible = false

func destroy(body): # Destroy a card and move it to the graveyard.
	var card_body = body
	if card_body.slot_type == "p1_attack":
		p1_a_slots[card_body.id_in_slot].is_empty = 1
		p1_graveyard.append(card_body)
		p1_attack.remove_at(card_body.id_in_slot)
		card_body.slot_type = "grave"
		card_animation(card_body,"position", p1_g_slots[0].position)
		reorganize_slot("player1",p1_attack,p1_a_slots)
	if card_body.slot_type == "p1_defense":
		p1_d_slots[card_body.id_in_slot].is_empty = 1
		p1_graveyard.append(card_body)
		p1_defense.remove_at(card_body.id_in_slot)
		card_body.slot_type = "grave"
		card_animation(card_body,"position", p1_g_slots[0].position)
		reorganize_slot("player1",p1_defense,p1_d_slots)
	if card_body.slot_type == "p1_artefact":
		p1_ar_slots[card_body.id_in_slot].is_empty = 1
		p1_graveyard.append(card_body)
		p1_artefact.remove_at(card_body.id_in_slot)
		card_body.slot_type = "grave"
		card_animation(card_body,"position", p1_g_slots[0].position)
		reorganize_slot("player1",p1_artefact,p1_ar_slots)
	if card_body.slot_type == "p1_action":
		p1_ac_slots[card_body.id_in_slot].is_empty = 1
		p1_graveyard.append(card_body)
		p1_action.remove_at(card_body.id_in_slot)
		card_body.slot_type = "grave"
		card_animation(card_body,"position", p1_g_slots[0].position)
		reorganize_slot("player1",p1_action,p1_ac_slots)
	card_body.z_index = p1_g_slots.size()
	card_body.card_bg.visible = true
	card_body.card_trans.visible = false
	is_searching = true

func reorganize_slot(player,type,slot_type): # Reorganize slots after a card is destroyed.
	if player == "player1":
		for c in range(type.size()):
			type[c].id_in_slot = c
			slot_type[c].is_empty = 0
			slot_type[type.size()].is_empty = 1
			card_animation(type[c],"position:x",slot_type[c].position.x)

func show_grave(player): # Show the graveyard for a player.
	if player == "player1":
		var card_spacing_x = 200
		var card_spacing_y = 280
		var start_x = 3000
		var start_y = 480
		var x_multiplier
		var y_multiplier
		for c in range(p1_graveyard.size()):
			y_multiplier = floor(c/12)
			if c%12 == 0:
				x_multiplier = 0
			if c%12 != 0:
				x_multiplier += 1
			#start_y += 280
			p1_graveyard[c].id_in_slot = c
			card_animation(p1_graveyard[c],"position:x",start_x - (card_spacing_x * x_multiplier))
			card_animation(p1_graveyard[c],"position:y",start_y + (card_spacing_y * y_multiplier))
			p1_graveyard[c].card_bg.visible = false
			p1_graveyard[c].card_trans.visible = true
			p1_graveyard[c].active_card.visible = true
			await get_tree().create_timer(0.01).timeout

func show_deck(player): # Show the deck for a player.
	if player == "player1":
		var card_spacing_x = 200
		var card_spacing_y = 280
		var start_x = 3000
		var start_y = 480
		var x_multiplier
		var y_multiplier
		for c in range(p1_deck.size()):
			y_multiplier = floor(c/12)
			if c%12 == 0:
				x_multiplier = 0
			if c%12 != 0:
				x_multiplier += 1
			#start_y += 280
			p1_deck[c].id_in_slot = c
			card_animation(p1_deck[c],"position:x",start_x - (card_spacing_x * x_multiplier))
			card_animation(p1_deck[c],"position:y",start_y + (card_spacing_y * y_multiplier))
			p1_deck[c].card_bg.visible = false
			p1_deck[c].card_trans.visible = true
			p1_deck[c].active_card.visible = true
			await get_tree().create_timer(0.01).timeout

func reorganize_showed_grave(player): # Reorganize the displayed graveyard for a player.
	if player == "player1":
		for c in range(p1_graveyard.size()):
			p1_graveyard[c].z_index = c + 5
			p1_graveyard[c].release_searching_hand()

func reorganize_showed_deck(player): # Reorganize the displayed graveyard for a player.
	if player == "player1":
		for c in range(p1_deck.size()):
			p1_deck[c].z_index = 5
			p1_deck[c].top_level = true
			p1_deck[c].release_searching_hand()

func hide_grave(player): # Hide the graveyard for a player.
	if player == "player1":
		for i in range(p1_graveyard.size()):
			p1_graveyard[i].release_searching_hand()
			p1_graveyard[i].card_bg.visible = true
			p1_graveyard[i].card_trans.visible = false
			p1_graveyard[i].active_card.visible = false
			card_animation(p1_graveyard[i],"position", p1_g_slots[0].position)
			await get_tree().create_timer(0.01).timeout

func hide_deck(player): # Hide the graveyard for a player.
	if player == "player1":
		for i in range(p1_deck.size()):
			p1_deck[i].release_searching_hand()
			p1_deck[i].card_bg.visible = true
			p1_deck[i].card_trans.visible = false
			p1_deck[i].active_card.visible = false
			card_animation(p1_deck[i],"position", p1_dc_slots[0].position)
			await get_tree().create_timer(0.01).timeout

func reorganize_hand(player): # Reorganize the hand of a player.
	if player == "player1":
		var card_spacing = 150
		var start_x = 1920
		for c in range(p1_hand.size()):
			p1_hand[c].id_in_slot = c
			card_animation(p1_hand[c],"position:x",start_x - (card_spacing * c))
			p1_hand[c].position.y = 1800

func card_animation(who,what,where): # Perform animations for card movements.
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(who, what, where, .5)
	await get_tree().create_timer(.5).timeout
