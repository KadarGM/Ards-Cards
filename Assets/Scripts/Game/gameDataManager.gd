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
var p1_hand = []
var p1_attack = []
var p1_defense = []
var p1_a_slots = []
var p1_a_slots_full = []
var p1_d_slots = []
var p1_d_slots_full = []


var p2_hand = []

func put(body):
	var card_body = body
	if body.type == 0:
		card_animation(card_body, p1_a_slots[0].position)
		p1_attack.append(card_body)
		p1_hand.remove_at(card_body.id_in_slot)
		p1_a_slots_full.append(p1_a_slots[0])
		p1_a_slots.remove_at(0)
	if body.type == 1:
		card_animation(card_body, p1_d_slots[0].position)
		p1_defense.append(card_body)
		p1_hand.remove_at(card_body.id_in_slot)
		p1_d_slots_full.append(p1_d_slots[0])
		p1_d_slots.remove_at(0)
	reindex_card_in_hand("player1")
	reorganize_hand()

func card_animation(who,where):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(who, "position", where, .5)

func reindex_card_in_hand(player):
	if player == "player1":
		for c in range(p1_hand.size()):
			p1_hand[c].id_in_slot = c

func reorganize_hand():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	var card_spacing = 150
	var start_x = get_viewport().size.x
	var cards = p1_hand.size()
	for c in range(cards):
		tween.tween_property(p1_hand[c], "position:x", start_x - (card_spacing * c), .5)
		p1_hand[c].position.y = 1800

func reset():
	var p1_deck = []
	var p1_hand = []
	var p1_attack = []
	var p1_defense = []
	var p1_a_slots = []
	var p1_a_slots_full = []
	var p1_d_slots = []
	var p1_d_slots_full = []
