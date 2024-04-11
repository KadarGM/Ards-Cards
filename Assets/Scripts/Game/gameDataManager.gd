extends Node

#conditions
var is_searching = true

#limits
var player_hand_max = 8
var player_hand_min = 0
var fight_slot_max = 4
var fight_slot_min = 0

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
var p1_a_slots_full = []
var p1_d_slots = []
var p1_d_slots_full = []
var p1_ar_slots = []
var p1_ar_slots_full = []

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
	p1_a_slots_full = []
	p1_d_slots = []
	p1_d_slots_full = []
	p1_ar_slots = []
	p1_ar_slots_full = []

func put(body):
	var card_body = body

	if body.type == 0:
		for i in range(p1_a_slots.size()):
			if p1_a_slots[0].id_slot != 0:
				p1_a_slots[0].id_slot = 0
				card_animation(card_body, p1_a_slots[0].position)
				card_body.slot_type = "p1_attack"
				p1_attack.append(card_body)
				p1_hand.remove_at(card_body.id_in_slot)
				break
			if p1_a_slots[i].id_slot != 0:
				p1_a_slots[i].id_slot = 0
				card_animation(card_body, p1_a_slots[i].position)
				card_body.slot_type = "p1_attack"
				p1_attack.append(card_body)
				p1_hand.remove_at(card_body.id_in_slot)
				break
			
			
				#p1_a_slots_full.append(p1_a_slots[0])
				#p1_a_slots.remove_at(0)
			
		
		#reindex_card_slots(p1_attack)
	if body.type == 1:
		card_animation(card_body, p1_d_slots[0].position)
		card_body.slot_type = "p1_defense"
		p1_defense.append(card_body)
		p1_hand.remove_at(card_body.id_in_slot)
		p1_d_slots_full.append(p1_d_slots[0])
		p1_d_slots.remove_at(0)
		#reindex_card_slots(p1_defense)
	if body.type == 2:
		card_animation(card_body, p1_ar_slots[0].position)
		card_body.slot_type = "p1_artefact"
		p1_artefact.append(card_body)
		p1_hand.remove_at(card_body.id_in_slot)
		p1_ar_slots_full.append(p1_ar_slots[0])
		p1_ar_slots.remove_at(0)
		#reindex_card_slots(p1_artefact)
	if p1_hand.size() > 0:
		reindex_card_in_hand("player1")
		reorganize_hand()
	body.put_button_1.visible = true
	print("put_p1_hand: ",p1_hand)
	print("put_p1_attack: ",p1_attack)
	print("put_p1_a_slots: ",p1_a_slots)
	print("put_p1_a_slots_full: ",p1_a_slots_full)

func destroy(body):
	var card_body = body
	if body.slot_type == "p1_attack":
		card_animation(card_body, p1_g_slots[0].position)
		p1_graveyard.append(card_body)
		p1_attack.remove_at(card_body.id_in_slot)
		p1_a_slots.append(p1_a_slots_full[card_body.id_in_slot])
		p1_a_slots_full.remove_at(card_body.id_in_slot)
		reindex_slots(p1_a_slots)
		reindex_card(p1_attack)
		
		body.card_bg.visible = true
		body.card_trans.visible = false
		body.active_card.visible = false
	if p1_attack.size() > 0:
		reindex_card(p1_attack)
		reorganize_slots()
	print("des_p1_hand: ",p1_hand)
	print("des_p1_attack: ",p1_attack)
	print("des_p1_a_slots: ",p1_a_slots)
	print("des_p1_a_slots_full: ",p1_a_slots_full)
	
func card_animation(who,where):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(who, "position", where, .5)

func reindex_card_in_hand(player):
	if player == "player1":
		for c in range(p1_hand.size()):
			p1_hand[c].id_in_slot = c

func reindex_slots(body):
	for c in range(body.size()):
		body[c].id_slot = c

func reindex_card(body):
	#if player == "player1":
		for c in range(body.size()):
			body[c].id_in_slot = c

func reorganize_hand():
	var card_spacing = 150
	var start_x = get_viewport().size.x
	var cards = p1_hand.size()
	for c in range(cards):
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
		tween.tween_property(p1_hand[c], "position:x", start_x - (card_spacing * c), .5)
		p1_hand[c].position.y = 1800

func reorganize_slots():
	var cards = p1_attack.size()
	for c in range(cards):
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
		tween.tween_property(p1_attack[c], "position:x", p1_attack[c].position.x, .5)


