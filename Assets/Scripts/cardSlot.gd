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

@export_category("editable")
@export var slot_id = 0
@export var slot_number = 0

func _ready():
	modulate = Color(Color(0.5, 0.5, 0.5, 0.706))

func _process(delta):
	dragging_slot()

func dragging_slot():
	if global.is_dragging == true:
		visible = true
	else:
		visible = false
