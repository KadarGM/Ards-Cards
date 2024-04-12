extends Node

const CARD = preload("res://Assets/Scenes/card.tscn")
const SLOT = preload("res://Assets/Scenes/slot.tscn")
const BOARD = preload("res://Assets/Scenes/board.tscn")

var game_data_manager = GameDataManager

# Holders
var card_holder
var slot_holder
var is_starting = false

func _ready():
	on_start_game("player1")

func on_start_game(player):
	is_starting = true
	set_board()
	node_holders()
	create_slot(player,"grave",1)
	create_slot(player,"deck",1)
	create_slot(player,"artefact",2)
	create_slot(player,"attack",4)
	create_slot(player,"defense",4)
	create_deck(player,60)
	for c in range(8):
		await get_tree().create_timer(.5).timeout
		draw_card(player,1)
	is_starting = false
#
func _process(delta):
	create_slot_counter()
	if is_starting == false:
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
	if player == "player1":
		if game_data_manager.p1_deck.size() > 0:
			for c in range(num):
				var clone = game_data_manager.p1_deck[c]
				clone.id_in_slot = c
				clone.slot_type = "hand"
				game_data_manager.p1_hand.append(clone)
				game_data_manager.p1_deck.remove_at(c)
				clone.card_bg.visible = false
				clone.card_trans.visible = true
				clone.active_card.visible = true
				from_deck_to_hand_anim(player,clone,c)
			await  get_tree().create_timer(.3).timeout
			game_data_manager.reorganize_hand(player)#
	#if player == "player2":
		#for c in range(num):
			#var clone = CARD.instantiate()
			#clone.id = randi_range(0,3)
			#clone.id_in_slot = c
			#game_data_manager.p2_hand.append(clone)
			#card_holder.add_child(clone, true)

func from_deck_to_hand_anim(player,clone,c):
	if player == "player1":
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
		var card_spacing = 150
		var start_x = 1920
		clone.position.x = 3600
		clone.position.y = 1300
		tween.tween_property(clone, "position:x", start_x - (card_spacing * c), .5)
		tween.tween_property(clone, "position:y", 1800, .5)

func create_deck(player,num):
	if player == "player1":
		for c in num:
			var clone = CARD.instantiate()
			clone.id = randi_range(0,3)
			clone.type = randi_range(0,2)
			clone.id_in_slot = c
			clone.slot_type = "deck"
			clone.position = game_data_manager.p1_dc_slots[0].position
			game_data_manager.p1_deck.append(clone)
			card_holder.add_child(clone,true)
			clone.card_bg.visible = true
			clone.card_trans.visible = false
			clone.active_card.visible = false

func create_slot(player,type,num):
	var slot_type
	if player == "player1":
		if type == "attack":
			slot_type = game_data_manager.p1_a_slots
		if type == "defense":
			slot_type= game_data_manager.p1_d_slots
		if type == "artefact":
			slot_type = game_data_manager.p1_ar_slots
		if type == "grave":
			slot_type = game_data_manager.p1_g_slots
		if type == "deck":
			slot_type = game_data_manager.p1_dc_slots
		for s in range(num):
			var slot = SLOT.instantiate()
			slot.id_slot = s
			slot.slot = type
			slot_type.append(slot)
			slot_holder.add_child(slot,true)
			organize(player,type,slot,s)

func create_slot_counter():
	game_data_manager.p1_g_slots[0].card_count.visible = true
	game_data_manager.p1_g_slots[0].card_count.text = str(game_data_manager.p1_graveyard.size())
	game_data_manager.p1_dc_slots[0].card_count.visible = true
	game_data_manager.p1_dc_slots[0].card_count.text  = str(game_data_manager.p1_deck.size())

func organize(player,type,body,n):
	if player == "player1":
		if type == "attack":
			body.position.x = 2130 + (350 * n) 
			body.position.y = 1325
		if type == "defense":
			body.position.x = 1730 - (350 * n) 
			body.position.y = 1325
		if type == "artefact":
			body.position.x = 3200 - (350 * n) 
			body.position.y = 1800
		if type == "grave":
			body.position.x = 220
			body.position.y = 1325
		if type == "deck":
			body.position.x = 3600
			body.position.y = 1325
