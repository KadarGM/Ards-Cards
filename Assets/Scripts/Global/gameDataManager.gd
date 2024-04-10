extends Node

const CARD = preload("res://Assets/Scenes/card.tscn")
const SLOT = preload("res://Assets/Scenes/slot.tscn")

var p_hand = []
var p_attack = []

var is_searching = true
var player_hand_max = 8
var player_hand_min = 0

var card_id
var new_slot
var max_fight_slot = 4
var min_fight_slot = 0

func _ready():
	player_slot(4,"attack")
	draw_cards(8)

func draw_cards(num):
	for c in range(num):
		var random = randi_range(0,3)
		var clone = CARD.instantiate()
		clone.position.x = -150 * c
		clone.id_hand = c
		clone.id = random 
		add_child(clone,true)
		clone.add_to_group("PlayerHand")
		p_hand.append(clone)

func player_slot(num,type):
	if type == "attack":
		for s in range(num):
			var clone = SLOT.instantiate()
			clone.position.x = 200 + (350 * s) 
			clone.position.y = 420
			clone.id = s
			add_child(clone,true)
			clone.add_to_group("PlayerSlots")
			p_attack.append(clone)

func put(id,card):
	new_slot = p_attack[0]
	card_id = id
	var child_node = get_node(str(card))
	p_hand.remove_at(id)
	card.remove_from_group("PlayerHand")
	card_animation(card,new_slot.position)
	p_attack.remove_at(0)
	print("card[",card_id,"] was put")
		
func to_grave():
	pass

func card_animation(who,where):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(who, "position", where, .5)
