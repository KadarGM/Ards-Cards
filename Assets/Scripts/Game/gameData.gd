extends Node

#region Variables
const CARD = preload("res://Assets/Scenes/card.tscn")
const SLOT = preload("res://Assets/Scenes/slot.tscn")

var game_data_manager = GameDataManager
var deck = DeckDataResource

@onready var card_barier = $CardBarier
@onready var turn_name = $TurnName

# Holders
var card_holder
var slot_holder
#endregion

func _ready():
	var P1_SLOT_TYPE_ARRAYS = [game_data_manager.p1_a_slots,game_data_manager.p1_d_slots,game_data_manager.p1_ar_slots,game_data_manager.p1_ac_slots,game_data_manager.p1_g_slots,game_data_manager.p1_dc_slots]
	var P2_SLOT_TYPE_ARRAYS = [game_data_manager.p2_a_slots,game_data_manager.p2_d_slots,game_data_manager.p2_ar_slots,game_data_manager.p2_ac_slots,game_data_manager.p2_g_slots,game_data_manager.p2_dc_slots]
	generate_slots("player1",P1_SLOT_TYPE_ARRAYS)
	generate_slots("player2",P2_SLOT_TYPE_ARRAYS)
	print("Slots were generated!")
	create_deck("player1",50,game_data_manager.p1_dc_slots,game_data_manager.p1_deck)
	create_deck("player2",50,game_data_manager.p2_dc_slots,game_data_manager.p2_deck)
	print("Decks were created!")
	who_start()
	on_start_game("player1",game_data_manager.p1_deck,game_data_manager.p1_hand,-150,1920,1800,5)
	on_start_game("player2",game_data_manager.p2_deck,game_data_manager.p2_hand,150,1920,300,5)
	print("Game is ready!")
	turn_name.text = (game_data_manager.players_turn + game_data_manager.TURN_TYPE_ARRAY[0])
	print(game_data_manager.players_turn, " starts first!")
	print("Round: ",game_data_manager.count_round," Turn: ", game_data_manager.turn_count)

func who_start():
	var num
	num = randi_range(1,2)
	if num == 1:
		game_data_manager.players_turn = "player1"
	if num == 2:
		game_data_manager.players_turn = "player2"

func generate_slots(player,slot_type_array):
	node_holders()
	for i in range(game_data_manager.TYPE_ARRAY.size()):
		create_slot(player,slot_type_array, game_data_manager.TYPE_ARRAY[i], game_data_manager.TYPE_COUNT[i])

func on_start_game(player, deck_array,hand,card_spacing,start_x,y_pos,start_card):
	card_barier.visible = false
	game_data_manager.is_starting = true
	for c in range(start_card):
		await get_tree().create_timer(.5).timeout
		draw_card(player,1,deck_array,hand,card_spacing,start_x,y_pos)
	await get_tree().create_timer(1.0).timeout
	game_data_manager.is_starting = false

func _process(_delta):
	if game_data_manager.is_starting == false:
		if game_data_manager.players_turn == "player1":
			game_process(game_data_manager.players_turn,game_data_manager.p1_deck,game_data_manager.p1_hand,game_data_manager.p1_graveyard,-150,1920,1800)
		elif game_data_manager.players_turn == "player2":
			game_process(game_data_manager.players_turn,game_data_manager.p2_deck,game_data_manager.p2_hand,game_data_manager.p2_graveyard,150,1920,300)
		else:
			print("This does not work: _process error!")

func game_process(player, deck_array, hand_array,grave_array,card_spacing,start_x,y_pos):
	if game_data_manager.is_grave_active == false and game_data_manager.is_deck_active == false:
		if hand_array.size() < 8:
			if Input.is_action_just_pressed("space key"):
				await get_tree().create_timer(.2).timeout
				draw_card(player,1,deck_array,hand_array,card_spacing,start_x,y_pos)
				await get_tree().create_timer(.2).timeout
	if grave_array.size() > 0 or deck_array.size() > 0:
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

func node_holders(): # Creates the necessary node holders for cards and slots.
	card_holder = Node2D.new()
	slot_holder = Node2D.new()
	card_holder.name = "card_holder"
	slot_holder.name = "slot_holder"
	add_child(slot_holder,true)
	add_child(card_holder,true)

func draw_card(player, num, deck_array, hand_array,card_spacing,start_x,y_pos): # Draws cards from the deck to the player's hand.
	if deck_array.size() > 0 and game_data_manager.is_dragging == false:
		for c in range(num):
			var deck_clone = deck_array[c]
			deck_clone.id_in_slot = c
			deck_clone.slot_type = "hand"
			hand_array.append(deck_clone)
			deck_array.remove_at(c)
			deck_clone.card_bg.visible = false
			deck_clone.card_trans.visible = true
			deck_clone.active_card.visible = true
			from_deck_to_hand_anim(player,deck_clone,c)
		await  get_tree().create_timer(.2).timeout
		game_data_manager.reorganize_hand(player,hand_array,card_spacing,start_x,y_pos)

func from_deck_to_hand_anim(player,clone,c): # Animates the transition of cards from the deck to the player's hand.,
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	var card_spacing = 150
	var start_x = 1920
	var start_y
	if player == "player1":
		clone.position.x = 3600
		clone.position.y = 1300
		start_y = 1800
	elif player == "player2":
		clone.position.x = 220
		clone.position.y = 825
		start_y = 300
	tween.tween_property(clone, "position:x", start_x - (card_spacing * c), .5)
	tween.tween_property(clone, "position:y", start_y, .5)

func create_deck(player,num, deck_slot, deck_array): # Creates the player's deck with a specified number of cards.
	for c in num:
		var clone = CARD.instantiate()
		clone.id = randi_range(0,3)
		clone.id_in_slot = c
		clone.slot_type = "deck"
		clone.card_owner = player
		clone.position = deck_slot[0].position
		deck_array.append(clone)
		card_holder.add_child(clone,true)
		clone.card_bg.visible = true
		clone.card_trans.visible = false
		clone.active_card.visible = false

func create_slot(player,slot_type_array,type,num): # Creates slots for different purposes (e.g., attack, defense, etc.) for the player.
	var slot_type = null
	var type_array = game_data_manager.TYPE_ARRAY
	for i in range(slot_type_array.size()):
			if type == type_array[i]:
				slot_type = slot_type_array[i]
				break
	if slot_type == null:
		print("Erorr: Slot type does not exist.")
		return
	else:
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
	elif player == "player2":
		game_data_manager.p2_g_slots[0].card_count.visible = true
		game_data_manager.p2_g_slots[0].card_count.text = str(game_data_manager.p2_graveyard.size())
		game_data_manager.p2_dc_slots[0].card_count.visible = true
		game_data_manager.p2_dc_slots[0].card_count.text  = str(game_data_manager.p2_deck.size())
	else:
		print("problem: create_slot_counter")

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
	#var turn_type_array
	var player
	var next_player
	var slot_selected_array
	var type_array
	var hand
	var deck
	var card_sapcing
	var start_x
	var y_pos
	if game_data_manager.players_turn == "player1":
		player = "player1"
		next_player = "player2"
		slot_selected_array = game_data_manager.P1_SLOT_SELECTED_ARRAY
		type_array = game_data_manager.P1_TYPE_ARRAYS
		deck = game_data_manager.p1_deck
		hand = game_data_manager.p1_hand
		#turn_type_array = game_data_manager.P1_TURN_TYPE_ARRAY
		card_sapcing = -150
		start_x = 1920
		y_pos = 1800
	elif game_data_manager.players_turn == "player2":
		player = "player2"
		next_player = "player1"
		slot_selected_array = game_data_manager.P2_SLOT_SELECTED_ARRAY
		type_array = game_data_manager.P2_TYPE_ARRAYS
		deck = game_data_manager.p2_deck
		hand = game_data_manager.p2_hand
		#turn_type_array = game_data_manager.P2_TURN_TYPE_ARRAY
		card_sapcing = 150
		start_x = 1920
		y_pos = 300
	if game_data_manager.is_starting == false:
		if game_data_manager.turn_count <= 3:
			game_data_manager.players_turn = next_player
			game_data_manager.turn_count += 1
		if game_data_manager.turn_count == 3:
			game_data_manager.turn_count = 0
			game_data_manager.count_round += 1
			game_data_manager.reset_board_next_turn(slot_selected_array,type_array)
		if game_data_manager.turn_count == 0 and game_data_manager.count_round >= 1:
			if hand.size() < 8:
				draw_card(player,1,deck,hand,card_sapcing,start_x,y_pos)
		for i in range(game_data_manager.TURN_TYPE_ARRAY.size()):
			if game_data_manager.turn_count == i:
				#turn_type_array[i] = true
				turn_name.text = (game_data_manager.players_turn + game_data_manager.TURN_TYPE_ARRAY[i])
			#else:
				#turn_type_array[i] = false
		print("Round: ",game_data_manager.count_round," Turn: ", game_data_manager.turn_count)
		
