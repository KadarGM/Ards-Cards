extends Node

#region Variables
#conditions
var is_searching = true
var is_grave_active = false
var is_detailed = false
var is_starting = false
var is_in_grave = false
var is_dragging = false
var is_drawing = false


#arrays
var p1_body = []
var p1_drag = []

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
var p1_g_show = []

var p2_hand = []



#endregion

func reset(): # Reset all player-related variables to their initial states.
	p1_body = []

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
	p1_g_show = []

	p2_hand = []

func _process(_delta):
#region Grave - commentary
	#check_put_avaliable(p1_attack)
	#check_put_avaliable(p1_defense)
	#check_put_avaliable(p1_artefact)
	#if is_drawing == false:
		#if is_detailed == true and p1_body[0].slot_type == "grave":
			#if is_grave_active == true:
				#for i in range(p1_graveyard.size()):
					#p1_graveyard[i].z_index = i + 5
				#p1_body[0].z_index = p1_graveyard.size() + 4
			#if is_grave_active == false:
				#reorganize_showed_grave("player1")
#endregion
	
#region E key - removed
		#if Input.is_action_just_pressed("e key"):
			#if is_starting == false and is_detailed == true and is_grave_active == false:
				#if p1_body[0].slot_type == "hand":
					#var current_slots
					#var max_slots
					#if p1_body[0].CARDS_LIST[p1_body[0].id].type == 0:
						#current_slots = p1_attack.size()
						#max_slots = p1_a_slots.size()
					#if p1_body[0].CARDS_LIST[p1_body[0].id].type == 1:
						#current_slots = p1_defense.size()
						#max_slots = p1_d_slots.size()
					#if p1_body[0].CARDS_LIST[p1_body[0].id].type == 2:
						#current_slots = p1_artefact.size()
						#max_slots = p1_ar_slots.size()
					#if p1_body[0].CARDS_LIST[p1_body[0].id].type == 3:
						#current_slots = p1_action.size()
						#max_slots = p1_ac_slots.size()
					#if current_slots < max_slots:
						#put(p1_body[0])
						#p1_body[0].use_button.visible = false 
					#else:
						#print("no_size")
					#p1_body[0].change_slots_size()
					#p1_body[0].release_detail_card()
				#p1_body[0].active_card.button_pressed = false
#endregion

#region R key - comentary
		#if Input.is_action_just_pressed("r key"):
			#if is_starting == false and is_detailed == true and is_grave_active == false:
				#p1_body[0].release_detail_card()
				#is_searching = true
				#if p1_body[0].slot_type != "hand" and p1_body[0].slot_type != "grave" and p1_body[0].slot_type != "deck":
					#destroy(p1_body[0])
					#p1_body[0].change_slots_size()
					#p1_body[0].active_card.button_pressed = false
				#elif p1_body[0].slot_type == "hand":
					#p1_graveyard.append(p1_body[0])
					#p1_hand.remove_at(p1_body[0].id_in_slot)
					#p1_body[0].slot_type = "grave"
					#reorganize_hand("player1")
					#card_animation(p1_body[0],"position", p1_g_slots[0].position)
					#p1_body[0].z_index = p1_g_slots.size()
					#p1_body[0].card_bg.visible = true
					#p1_body[0].card_trans.visible = false
					#p1_body[0].active_card.visible = false
					#p1_body[0].destroy_button.visible = false
#endregion
			
		if Input.is_action_just_pressed("g key"):
			if is_starting == false and p1_graveyard.size() > 0:
				if is_detailed == true:
					p1_body[0].release_detail_card()
					is_searching = true
				if is_grave_active == false:
					show_grave("player1")
					is_grave_active = true
					reorganize_showed_grave("player1")
				elif is_grave_active == true:
					hide_grave("player1")
					is_grave_active = false

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
	#body.destroy_button.visible = true
	is_searching = true
	
#region For button - commentary
#func check_put_avaliable(type1): # Check if a card can be put into a particular slot type and adjust UI accordingly.
	#var typ
	#var maximum
	#if type1 == p1_attack:
		#typ = 0
		#maximum = 4
	#if type1 == p1_defense:
		#typ = 1
		#maximum = 4
	#if type1 == p1_artefact:
		#typ = 2
		#maximum = 2
	#if type1 == p1_action:
		#typ = 3
		#maximum = 1
	#if type1.size() == maximum:
		#for i in range(p1_hand.size()):
			#if p1_hand[i].CARDS_LIST[p1_hand[i].id].type == typ:
				#p1_hand[i].use_button.visible = false
	#if type1.size() < maximum:
		#for i in range(p1_hand.size()):
			#if p1_hand[i].CARDS_LIST[p1_hand[i].id].type == typ:
				#p1_hand[i].use_button.visible = true
	
#endregion

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
	card_body.active_card.visible = false
	#card_body.destroy_button.visible = false
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

func reorganize_showed_grave(player): # Reorganize the displayed graveyard for a player.
	if player == "player1":
		for c in range(p1_graveyard.size()):
			p1_graveyard[c].z_index = c + 5
			p1_graveyard[c].release_searching_hand()

func hide_grave(player): # Hide the graveyard for a player.
	if player == "player1":
		for i in range(p1_graveyard.size()):
			p1_graveyard[i].release_searching_hand()
			p1_graveyard[i].card_bg.visible = true
			p1_graveyard[i].card_trans.visible = false
			p1_graveyard[i].active_card.visible = false
			card_animation(p1_graveyard[i],"position", p1_g_slots[0].position)
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

func show_active_slots(player, slot_type, status):
	if player == "player1":
		var slot
		if slot_type == 0:
			slot = p1_a_slots
		if slot_type == 1:
			slot = p1_d_slots
		if slot_type == 2:
			slot = p1_ar_slots
		if slot_type == 3:
			slot = p1_ac_slots
		for i in range(slot.size()):
			if status == 0:
				if slot[i].is_empty == 1:
					slot[i].color_rect.visible = true
				if slot[i].is_empty == 0:
					slot[i].color_rect.visible = false
			if status == 1:
				if slot[i].is_empty == 1:
					slot[i].color_rect.visible = false
