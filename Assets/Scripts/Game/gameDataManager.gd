extends Node

#conditions
var is_searching = true

#arrays
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
var p1_d_slots = []
var p1_ar_slots = []

var p2_hand = []

func reset():
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
	p1_d_slots = []
	p1_ar_slots = []

func put(body):
	var card_body = body
	if card_body.type == 0:
		for i in range(p1_a_slots.size()):
			if p1_a_slots[i].is_empty == 1:
				card_body.slot_type = "p1_attack"
				p1_attack.append(card_body)
				p1_hand.remove_at(card_body.id_in_slot)
				p1_attack[i].id_in_slot = i
				p1_a_slots[i].is_empty = 0
				card_animation(card_body, "position",p1_a_slots[i].position)
				break
	if card_body.type == 1:
		for i in range(p1_d_slots.size()):
			if p1_d_slots[i].is_empty == 1:
				card_body.slot_type = "p1_defense"
				p1_defense.append(card_body)
				p1_hand.remove_at(card_body.id_in_slot)
				p1_defense[i].id_in_slot = i
				p1_d_slots[i].is_empty = 0
				card_animation(card_body, "position", p1_d_slots[i].position)
				break
	if card_body.type == 2:
		for i in range(p1_ar_slots.size()):
			if p1_ar_slots[i].is_empty == 1:
				card_body.slot_type = "p1_artefact"
				p1_artefact.append(card_body)
				p1_hand.remove_at(card_body.id_in_slot)
				p1_artefact[i].id_in_slot = i
				p1_ar_slots[i].is_empty = 0
				card_animation(card_body, "position", p1_ar_slots[i].position)
				break
	if p1_hand.size() > 0:
		reorganize_hand("player1")
	await get_tree().create_timer(.3).timeout
	body.put_button_1.visible = true
	

func destroy(body):
	var card_body = body
	if card_body.slot_type == "p1_attack":
		p1_a_slots[card_body.id_in_slot].is_empty = 1
		p1_graveyard.append(card_body)
		p1_attack.remove_at(card_body.id_in_slot)
		card_body.card_bg.visible = true
		card_body.card_trans.visible = false
		card_body.active_card.visible = false
		card_animation(card_body,"position", p1_g_slots[0].position)
		reorganize_slot("player1",p1_attack,p1_a_slots)
	if card_body.slot_type == "p1_defense":
		p1_d_slots[card_body.id_in_slot].is_empty = 1
		p1_graveyard.append(card_body)
		p1_defense.remove_at(card_body.id_in_slot)
		card_body.card_bg.visible = true
		card_body.card_trans.visible = false
		card_body.active_card.visible = false
		card_animation(card_body,"position", p1_g_slots[0].position)
		reorganize_slot("player1",p1_defense,p1_d_slots)
	if card_body.slot_type == "p1_artefact":
		p1_ar_slots[card_body.id_in_slot].is_empty = 1
		p1_graveyard.append(card_body)
		p1_artefact.remove_at(card_body.id_in_slot)
		card_body.card_bg.visible = true
		card_body.card_trans.visible = false
		card_body.active_card.visible = false
		card_animation(card_body,"position", p1_g_slots[0].position)
		reorganize_slot("player1",p1_artefact,p1_ar_slots)

func reorganize_slot(player,type,slot_type):
	if player == "player1":
		for c in range(type.size()):
			type[c].id_in_slot = c
			slot_type[c].is_empty = 0
			slot_type[type.size()].is_empty = 1
			card_animation(type[c],"position:x",slot_type[c].position.x)

func show_grave(player):
	if player == "player1":
		var card_spacing = 150
		var start_x = 2500
		if p1_graveyard.size() > 0 and p1_graveyard.size() <= 20:
			for c in range(p1_graveyard.size()):
				p1_graveyard[c].top_level = true
				card_animation(p1_graveyard[c],"position:x",start_x - (card_spacing * c))
				card_animation(p1_graveyard[c],"position:y",780)
				p1_graveyard[c].card_bg.visible = false
				p1_graveyard[c].card_trans.visible = true
				p1_graveyard[c].active_card.visible = true
		if p1_graveyard.size() <= 40:
			for c in range(20,p1_graveyard.size()):
				p1_graveyard[c].top_level = true
				card_animation(p1_graveyard[c],"position:x",start_x - (card_spacing * (c)))
				card_animation(p1_graveyard[c],"position:y",1080)
				p1_graveyard[c].card_bg.visible = false
				p1_graveyard[c].card_trans.visible = true
				p1_graveyard[c].active_card.visible = true
		if p1_graveyard.size() <= 60:
			for c in range(40,p1_graveyard.size()):
				p1_graveyard[c].top_level = true
				card_animation(p1_graveyard[c],"position:x",start_x - (card_spacing * (c)))
				card_animation(p1_graveyard[c],"position:y",1380)
				p1_graveyard[c].card_bg.visible = false
				p1_graveyard[c].card_trans.visible = true
				p1_graveyard[c].active_card.visible = true
				

func reorganize_hand(player):
	if player == "player1":
		var card_spacing = 150
		var start_x = 1920
		for c in range(p1_hand.size()):
			p1_hand[c].id_in_slot = c
			card_animation(p1_hand[c],"position:x",start_x - (card_spacing * c))
			p1_hand[c].position.y = 1800

func card_animation(who,what,where):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(who, what, where, .5)
