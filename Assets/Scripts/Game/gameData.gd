extends Node

const CARD = preload("res://Assets/Scenes/card.tscn")
const SLOT = preload("res://Assets/Scenes/slot.tscn")
const BOARD = preload("res://Assets/Scenes/board.tscn")

var game_data_manager = GameDataManager

# Holders
var card_holder
var slot_holder

func _ready():
	on_start_game()

func on_start_game():
	set_board()
	node_holders()
	create_slot("player1","attack",game_data_manager.fight_slot_max)
	create_slot("player1","defense",game_data_manager.fight_slot_max)
	create_deck("player1",60)
	#await get_tree().create_timer(5).timeout
	#draw_card("player1",6)

func _process(delta):
	if game_data_manager.p1_hand.size() < 8:
		if Input.is_action_just_pressed("right click"):
			draw_card("player1",1)

func set_board():
	var board = BOARD.instantiate()
	add_child(board,true)

func node_holders():
	card_holder = Node2D.new()
	slot_holder = Node2D.new()
	card_holder.name = "card_holder"
	slot_holder.name = "slot_holder"
	add_child(slot_holder,true)
	add_child(card_holder,true)

func draw_card(player, num):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	var card_spacing = 150
	var start_x = get_viewport().size.x
	var cards = game_data_manager.p1_hand.size()
	if player == "player1":
		for c in range(num):
			var clone = game_data_manager.p1_deck[c]
			clone.id_in_slot = c
			game_data_manager.p1_hand.append(clone)
			game_data_manager.p1_deck.remove_at(c)
			clone.card_bg.visible = false
			clone.card_trans.visible = true
			clone.active_card.visible = true
		for c in range(num):
			tween.tween_property(game_data_manager.p1_hand[c], "position:x", start_x - (card_spacing * c), .5)
			game_data_manager.p1_hand[c].position.y = 1800
		game_data_manager.reindex_card_in_hand("player1")
		game_data_manager.reorganize_hand()

	if player == "player2":
		for c in range(num):
			var clone = CARD.instantiate()
			clone.id = randi_range(0,3)
			clone.id_in_slot = c
			game_data_manager.p2_hand.append(clone)
			card_holder.add_child(clone, true)

func create_deck(player,num):
	if player == "player1":
		for c in num:
			var clone = CARD.instantiate()
			clone.id = randi_range(0,3)
			clone.type = randi_range(0,1)
			clone.id_in_slot = c
			game_data_manager.p1_deck.append(clone)
			card_holder.add_child(clone,true)
			clone.position.x = 3600
			clone.position.y = 1300
			clone.card_bg.visible = true
			clone.card_trans.visible = false
			clone.active_card.visible = false

func create_slot(player,type,num):
	if player == "player1":
		if type == "attack":
			for s in range(num):
				var clone = SLOT.instantiate()
				game_data_manager.p1_a_slots.append(clone)
				organize_attack_slot(clone,s)
				slot_holder.add_child(clone,true)
		if type == "defense":
			for s in range(num):
				var clone = SLOT.instantiate()
				game_data_manager.p1_d_slots.append(clone)
				organize_defense_slot(clone,s)
				slot_holder.add_child(clone,true)

func organize_defense_slot(body,n):
	body.position.x = 1730 - (350 * n) 
	body.position.y = 1325

func organize_attack_slot(body,n):
	body.position.x = 2130 + (350 * n) 
	body.position.y = 1325

func draw_from_deck(player):
	pass
