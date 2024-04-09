extends Node

var is_searching = true
var player_hand_current: int = 1
var player_hand_max = 8
var player_hand_min = 0

#@onready var slot_node_1 = $Board/PlayerHandSlotsNodes/SlotNode1
#@onready var slot_node_2 = $Board/PlayerHandSlotsNodes/SlotNode2
#@onready var slot_node_3 = $Board/PlayerHandSlotsNodes/SlotNode3
#@onready var slot_node_4 = $Board/PlayerHandSlotsNodes/SlotNode4
#@onready var slot_node_5 = $Board/PlayerHandSlotsNodes/SlotNode5
#@onready var slot_node_6 = $Board/PlayerHandSlotsNodes/SlotNode6
#@onready var slot_node_7 = $Board/PlayerHandSlotsNodes/SlotNode7
#@onready var slot_node_8 = $Board/PlayerHandSlotsNodes/SlotNode8
#
#@onready var slots_array = [slot_node_1,slot_node_2,slot_node_3,slot_node_4,slot_node_5,slot_node_6,slot_node_7,slot_node_8]
#
#func _ready():
	#pre_game()
#
#func pre_game():
	#for s in range(player_hand_max):
		#var slot
		#slots_array[s] = slot
		#slot.visible = true
#
#func player_slots():
	#if player_hand_current > 0:
		#for i in range(player_hand_current):
			#var slot
			#slots_array[i] = slot
			#slot.visible = true
#
#func _process(delta):
	#player_slots()
	
