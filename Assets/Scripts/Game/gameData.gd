extends Node

#region Variables
const CARD = preload("res://Assets/Scenes/card.tscn")
const SLOT = preload("res://Assets/Scenes/slot.tscn")

var game_data_manager = GameDataManager
var deck = DeckDataResource

@onready var card_barier = $CardBarier

# Holders
var card_holder
var slot_holder
#endregion

func _ready():
	who_start()
	on_start_game("player1")
	on_start_game("player2")

func who_start():
	var num
	num = randi_range(1,2)
	if num == 1:
		game_data_manager.players_turn = "player1"
		pass
	if num == 2:
		game_data_manager.players_turn = "player2"
		pass

func on_start_game(player):
	card_barier.visible = false
	game_data_manager.is_starting = true
	node_holders()
	create_slot(player,"grave",1)
	create_slot(player,"deck",1)
	create_slot(player,"action",1)
	create_slot(player,"artefact",2)
	create_slot(player,"attack",4)
	create_slot(player,"defense",4)
	create_deck(player,60)
	for c in range(8):
		await get_tree().create_timer(.5).timeout
		draw_card(player,1)
	await get_tree().create_timer(1.0).timeout
	game_data_manager.is_starting = false

func _process(_delta):
	p1_process()
	p2_process()

func p1_process():
	#create_slot_counter("player1")
	if game_data_manager.is_starting == false and game_data_manager.is_grave_active == false and game_data_manager.is_deck_active == false:
		if game_data_manager.p1_hand.size() < 8:
			if Input.is_action_just_pressed("space key"):
				draw_card(game_data_manager.players_turn,1)
				await get_tree().create_timer(.5).timeout
	if game_data_manager.p1_graveyard.size() > 0 or game_data_manager.p1_deck.size() > 0:
		if game_data_manager.is_grave_active == true or game_data_manager.is_deck_active == true:
			game_data_manager.can_dragging = false
			await get_tree().create_timer(.1).timeout
			card_barier.z_index = 10
			card_barier.visible = true
		if game_data_manager.is_grave_active == false or game_data_manager.is_deck_active == false:
			game_data_manager.can_dragging = true
			await get_tree().create_timer(.1).timeout
			card_barier.z_index = -1
			card_barier.visible = false

func p2_process():
	#create_slot_counter("player2")
	if game_data_manager.is_starting == false and game_data_manager.is_grave_active == false and game_data_manager.is_deck_active == false:
		if game_data_manager.p2_hand.size() < 8:
			if Input.is_action_just_pressed("space key"):
				draw_card("player2",1)
				await get_tree().create_timer(.5).timeout
	if game_data_manager.p2_graveyard.size() > 0 or game_data_manager.p2_deck.size() > 0:
		if game_data_manager.is_grave_active == true or game_data_manager.is_deck_active == true:
			game_data_manager.can_dragging = false
			await get_tree().create_timer(.1).timeout
			card_barier.z_index = 3
			card_barier.visible = true
		if game_data_manager.is_grave_active == false or game_data_manager.is_deck_active == false:
			game_data_manager.can_dragging = true
			await get_tree().create_timer(.1).timeout
			card_barier.z_index = -1
			card_barier.visible = false

func node_holders(): # Creates the necessary node holders for cards and slots.
	card_holder = Node2D.new()
	slot_holder = Node2D.new()
	card_holder.name = "card_holder"
	slot_holder.name = "slot_holder"
	add_child(slot_holder,true)
	add_child(card_holder,true)

func draw_card(player, num): # Draws cards from the deck to the player's hand.
	if player == "player1":
		if game_data_manager.p1_deck.size() > 0 and game_data_manager.is_dragging == false:
			for c in range(num):
				var clone = game_data_manager.p1_deck[c]
				clone.id_in_slot = c
				clone.slot_type = "hand"
				game_data_manager.p1_hand.append(clone)
				game_data_manager.p1_deck.remove_at(c)
				clone.card_bg.visible = false
				clone.card_trans.visible = true
				clone.active_card.visible = true
				from_deck_to_hand_anim("player1",clone,c)
			await  get_tree().create_timer(.2).timeout
			game_data_manager.reorganize_hand("player1")
	if player == "player2":
		if game_data_manager.p2_deck.size() > 0 and game_data_manager.is_dragging == false:
			for c in range(num):
				var clone = game_data_manager.p2_deck[c]
				clone.id_in_slot = c
				clone.slot_type = "hand"
				game_data_manager.p2_hand.append(clone)
				game_data_manager.p2_deck.remove_at(c)
				clone.card_bg.visible = false
				clone.card_trans.visible = true
				clone.active_card.visible = true
				from_deck_to_hand_anim("player2",clone,c)
			await  get_tree().create_timer(.2).timeout
			game_data_manager.reorganize_hand("player2")

func from_deck_to_hand_anim(player,clone,c): # Animates the transition of cards from the deck to the player's hand.
	if player == "player1":
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
		var card_spacing = 150
		var start_x = 1920
		clone.position.x = 3600
		clone.position.y = 1300
		tween.tween_property(clone, "position:x", start_x - (card_spacing * c), .5)
		tween.tween_property(clone, "position:y", 1800, .5)
	if player == "player2":
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
		var card_spacing = 150
		var start_x = 1920
		clone.position.x = 220
		clone.position.y = 825
		tween.tween_property(clone, "position:x", start_x - (card_spacing * c), .5)
		tween.tween_property(clone, "position:y", 300, .5)

func create_deck(player,num): # Creates the player's deck with a specified number of cards.
	if player == "player1":
		for c in num:
			var clone = CARD.instantiate()
			clone.id = randi_range(0,3)
			clone.id_in_slot = c
			clone.slot_type = "deck"
			clone.card_owner = "player1"
			clone.position = game_data_manager.p1_dc_slots[0].position
			game_data_manager.p1_deck.append(clone)
			card_holder.add_child(clone,true)
			clone.card_bg.visible = true
			clone.card_trans.visible = false
			clone.active_card.visible = false
	if player == "player2":
		for c in num:
			var clone = CARD.instantiate()
			clone.id = randi_range(0,3)
			clone.id_in_slot = c
			clone.slot_type = "deck"
			clone.card_owner = "player2"
			clone.position = game_data_manager.p2_dc_slots[0].position
			game_data_manager.p2_deck.append(clone)
			card_holder.add_child(clone,true)
			clone.card_bg.visible = true
			clone.card_trans.visible = false
			clone.active_card.visible = false

func create_slot(player,type,num): # Creates slots for different purposes (e.g., attack, defense, etc.) for the player.
	var slot_type
	if player == "player1":
		if type == "attack":
			slot_type = game_data_manager.p1_a_slots
		if type == "defense":
			slot_type= game_data_manager.p1_d_slots
		if type == "artefact":
			slot_type = game_data_manager.p1_ar_slots
		if type == "action":
			slot_type = game_data_manager.p1_ac_slots
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
	if player == "player2":
		if type == "attack":
			slot_type = game_data_manager.p2_a_slots
		if type == "defense":
			slot_type= game_data_manager.p2_d_slots
		if type == "artefact":
			slot_type = game_data_manager.p2_ar_slots
		if type == "action":
			slot_type = game_data_manager.p2_ac_slots
		if type == "grave":
			slot_type = game_data_manager.p2_g_slots
		if type == "deck":
			slot_type = game_data_manager.p2_dc_slots
		for s in range(num):
			var slot = SLOT.instantiate()
			slot.id_slot = s
			slot.slot = type
			slot_type.append(slot)
			slot_holder.add_child(slot,true)
			organize(player,type,slot,s)

func create_slot_counter(player): # Updates the counters for the player's graveyard and deck slots.
	if player == "player1":
		game_data_manager.p1_g_slots[0].card_count.visible = true
		game_data_manager.p1_g_slots[0].card_count.text = str(game_data_manager.p1_graveyard.size())
		game_data_manager.p1_dc_slots[0].card_count.visible = true
		game_data_manager.p1_dc_slots[0].card_count.text  = str(game_data_manager.p1_deck.size())
	if player == "player2":
		game_data_manager.p2_g_slots[0].card_count.visible = true
		game_data_manager.p2_g_slots[0].card_count.text = str(game_data_manager.p2_graveyard.size())
		game_data_manager.p2_dc_slots[0].card_count.visible = true
		game_data_manager.p2_dc_slots[0].card_count.text  = str(game_data_manager.p2_deck.size())

func organize(player,type,body,n): # Organizes the positions of slots based on their type and index.
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
		if type == "action":
			body.position.x = (3200 - (350 * 2))
			body.position.y = 1800
		if type == "grave":
			body.position.x = 220
			body.position.y = 1325
		if type == "deck":
			body.position.x = 3600
			body.position.y = 1325
	if player == "player2":
		if type == "attack":
			body.position.x = 1730 - (350 * n) 
			body.position.y = 825
		if type == "defense":
			body.position.x = 2130 + (350 * n)
			body.position.y = 825
		if type == "artefact":
			body.position.x = 680 + (350 * n) 
			body.position.y = 300
		if type == "action":
			body.position.x = (680 + (350 * 2))
			body.position.y = 300
		if type == "grave":
			body.position.x = 3600
			body.position.y = 825
		if type == "deck":
			body.position.x = 220
			body.position.y = 825


func _on_next_turn_button_pressed():
	if game_data_manager.players_turn == "player1":
		game_data_manager.players_turn = "player2"
	elif game_data_manager.players_turn == "player2":
		game_data_manager.players_turn = "player1"
	print(game_data_manager.players_turn)
