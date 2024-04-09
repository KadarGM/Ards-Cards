extends Node2D

var slot_dict : Dictionary = {
	
	"Deck": 0,
	"Graveyard": 1,
	"Hero": 2,
	"Hand": 3,
	"Deffend": 4,
	"Attack": 5,
	"Artefacts": 6,
	"Actions": 7
	
}

var start_round = 0
var player_turn

var max_cards_hand = 7
var max_cards_deck = 60
var cards_in_deck = []

func _ready():
	pass

func shuffle_deck():
	pass

func _process(delta):
	pass

func start_game():
	pass

func who_is_first():
	pass

func deals_cards():
	pass

func round_cycle():
	pass

func end_game():
	pass
