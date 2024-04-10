extends Node

const CARD = preload("res://Assets/Scenes/card.tscn")
const SLOT = preload("res://Assets/Scenes/slot.tscn")
const BOARD = preload("res://Assets/Scenes/board.tscn")

var game_data_manager = GameDataManager

# Holders
var card_holder
var card_player_hand
var card_player_attack
var slot_holder
var slot_player_attack

func _ready():
	on_start_game()
	print(game_data_manager.attack_slots_array)

func _process(delta):
	game_data_manager.get_current_attack(slot_player_attack.get_child_count())
	game_data_manager.get_slot(slot_player_attack.get_child(0))

func on_start_game():
	set_board()
	node_holders()
	create_slot("player1","attack",game_data_manager.fight_slot_max)
	draw_card("player1",6)

func set_board():
	var board = BOARD.instantiate()
	add_child(board,true)

func node_holders():
	card_holder = Node2D.new()
	card_player_hand = Node2D.new()
	card_player_attack = Node2D.new()

	slot_holder = Node2D.new()
	slot_player_attack = Node2D.new()
	
	card_holder.name = "card_holder"
	card_player_attack.name = "card_player_attack"
	card_player_hand.name = "card_player_hand"

	slot_holder.name = "slot_holder"
	slot_player_attack.name = "slot_player_attack"

	add_child(slot_holder,true)
	get_node("slot_holder").add_child(slot_player_attack,true)

	add_child(card_holder,true)
	get_node("card_holder").add_child(card_player_hand,true)
	get_node("card_holder").add_child(card_player_attack,true)
	

func draw_card(player, num):
	if player == "player1":
		for c in range(num):
			var clone = CARD.instantiate()
			clone.id = randi_range(0,3)
			card_player_hand.add_child(clone, true)
		reorganize_hand()

func create_slot(player,type,num):
	if player == "player1":
		if type == "attack":
			for s in range(num):
				var clone = SLOT.instantiate()
				game_data_manager.attack_slots_array.append(clone)
				organize_attack_slot(clone,s)
				slot_player_attack.add_child(clone,true)

func organize_attack_slot(body,n):
	body.position.x = 2130 + (350 * n) 
	body.position.y = 1325

func reorganize_hand():
	var card_spacing = 150
	var start_x = get_viewport().size.x
	var cards = card_player_hand.get_child_count()
	for c in range(cards):
		card_player_hand.get_child(c).position.x = start_x - (card_spacing * c)
		card_player_hand.get_child(c).position.y = 1800
