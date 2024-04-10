extends Node

var card_body

var is_searching = true
var player_hand_max = 8
var player_hand_min = 0


var fight_slot_max = 4
var fight_slot_min = 0
var attack_slot_current

var putted_card
var new_slot

var attack_slots_array = []

func _ready():
	pass

func get_current_attack(current):
	attack_slot_current = current
	return attack_slot_current

func get_putted(card):
	putted_card = card
	return putted_card

func get_slot(slot):
	new_slot = slot
	return new_slot

func put(body):
	card_body = body
	card_animation(card_body, attack_slots_array[0].position)
	attack_slots_array.remove_at(0)

func card_animation(who,where):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(who, "position", where, .5)
