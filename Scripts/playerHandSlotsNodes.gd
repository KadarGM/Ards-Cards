extends Node2D

@onready var slot_node_1 = $SlotNode1
@onready var slot_node_2 = $SlotNode2
@onready var slot_node_3 = $SlotNode3
@onready var slot_node_4 = $SlotNode4
@onready var slot_node_5 = $SlotNode5
@onready var slot_node_6 = $SlotNode6
@onready var slot_node_7 = $SlotNode7
@onready var slot_node_8 = $SlotNode8
var slot_1
var slot_2
var slot_3
var slot_4
var slot_5
var slot_6
var slot_7
var slot_8

@onready var slots_array = [slot_node_1,slot_node_2,slot_node_3,slot_node_4,slot_node_5,slot_node_6,slot_node_7,slot_node_8]
@onready var slots_init = [slot_1,slot_2,slot_3,slot_4,slot_5,slot_6,slot_7,slot_8]


func _ready():
	pre_game()

func pre_game():
	for s in range(slots_array.size()):
		slots_array[s].visible = false

func player_slots_visible():
		for i in range(GameGlobal.player_hand_current):
			slots_array[i].visible = true

func player_slots_pos():
	slots_init = slots_array
	if GameGlobal.player_hand_current == 1:
		slots_init[0].position = Vector2(0,900)
	if GameGlobal.player_hand_current == 2:
		slots_init[0].position = slots_init[3].position
		slots_init[1].position = slots_init[4].position
	if GameGlobal.player_hand_current == 3:
		slots_init[0].position = slots_init[2].position
		slots_init[1].position = slots_init[3].position
		slots_init[2].position = slots_init[4].position
	if GameGlobal.player_hand_current == 4:
		slots_init[0].position = slots_init[2].position
		slots_init[1].position = slots_init[3].position
		slots_init[2].position = slots_init[4].position
		slots_init[3].position = slots_init[5].position
	if GameGlobal.player_hand_current == 5:
		slots_init[0].position = slots_init[1].position
		slots_init[1].position = slots_init[2].position
		slots_init[2].position = slots_init[3].position
		slots_init[3].position = slots_init[4].position
		slots_init[4].position = slots_init[5].position
	if GameGlobal.player_hand_current == 6:
		slots_init[0].position = slots_init[1].position
		slots_init[1].position = slots_init[2].position
		slots_init[2].position = slots_init[3].position
		slots_init[3].position = slots_init[4].position
		slots_init[4].position = slots_init[5].position
		slots_init[5].position = slots_init[6].position
	if GameGlobal.player_hand_current == 7:
		slots_init[0].position = slots_init[0].position
		slots_init[1].position = slots_init[1].position
		slots_init[2].position = slots_init[2].position
		slots_init[3].position = slots_init[3].position
		slots_init[4].position = slots_init[4].position
		slots_init[5].position = slots_init[5].position
		slots_init[6].position = slots_init[6].position
	if GameGlobal.player_hand_current == 8:
		slots_init[0].position = slots_init[0].position
		slots_init[1].position = slots_init[1].position
		slots_init[2].position = slots_init[2].position
		slots_init[3].position = slots_init[3].position
		slots_init[4].position = slots_init[4].position
		slots_init[5].position = slots_init[5].position
		slots_init[6].position = slots_init[6].position
		slots_init[7].position = slots_init[7].position
	slots_array = slots_init
	print(slots_init)
func _process(delta):
	if GameGlobal.player_hand_current != GameGlobal.player_hand_min:
		player_slots_visible()
		player_slots_pos()
