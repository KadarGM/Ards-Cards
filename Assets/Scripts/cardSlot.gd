extends StaticBody2D

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

var slot_id = 0
var is_empty = true

func _ready():
	modulate = Color(Color(0.5, 0.5, 0.5, 0.706))

func _process(delta):
	if global.is_dragging == true:
		visible = true
	else:
		visible = false
