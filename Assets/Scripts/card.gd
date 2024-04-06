extends Node2D

var draggable = false
var is_inside_dropable = false
var offset: Vector2
var initialPos: Vector2
var body_ref

var max_card_scale = 2
var min_card_scale = 1

var stat_start_pos = 0
var stat_end_pos = 150

@onready var mana_point = $CardStats/ManaPoint
@onready var health = $CardStats/Health
@onready var deffense = $CardStats/Deffense
@onready var attack = $CardStats/Attack

@onready var card_stats = $CardStats
@onready var price_value = $CardStats/ManaPoint/PriceValue
@onready var health_value = $CardStats/Health/HealthValue
@onready var deffense_value = $CardStats/Deffense/DeffenseValue
@onready var attack_value = $CardStats/Attack/AttackValue
@onready var name_value = $CardStats/NameValue


func set_stats(cond):
	mana_point.visible = cond
	health.visible = cond
	deffense.visible = cond
	attack.visible = cond
	name_value.visible = cond

	if cond == false:
		mana_point.position.x = 0
		health.position.x = 0
		deffense.position.x = 0
		attack.position.x = 0
		name_value.position.y = 0

func _ready():
	set_stats(false)

func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("left click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			global.is_dragging = true
		if Input.is_action_pressed("left click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("left click"):
			global.is_dragging = false
			var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
			if is_inside_dropable:
				tween.tween_property(self,"position",body_ref.position,.2)
			else:
				tween.tween_property(self,"global_position",initialPos,.2)
		if Input.is_action_just_released("right click"):
			var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
			tween.tween_property(self, "scale", Vector2(min_card_scale,min_card_scale), .3)
			tween.tween_property(mana_point, "position:x", stat_start_pos, .3).set_delay(.1)
			tween.tween_property(health, "position:x", stat_start_pos, .3).set_delay(.075)
			tween.tween_property(deffense, "position:x", stat_start_pos, .3).set_delay(.05)
			tween.tween_property(attack, "position:x", stat_start_pos, .3).set_delay(.025)
			tween.tween_property(name_value, "position:y", stat_start_pos, .3).set_delay(0)
			set_stats(false)
			global.is_detailed = false
			top_level = false
		if global.is_detailed == false:
			detail_card()
				

func detail_card():
	if Input.is_action_pressed("right click"):
		set_stats(true)
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
		tween.tween_property(self, "scale", Vector2(max_card_scale,max_card_scale), .3)
		tween.tween_property(mana_point, "position:x", stat_end_pos, .3).set_delay(0)
		tween.tween_property(health, "position:x", stat_end_pos, .3).set_delay(.025)
		tween.tween_property(deffense, "position:x", stat_end_pos, .3).set_delay(.05)
		tween.tween_property(attack, "position:x", stat_end_pos, .3).set_delay(.075)
		tween.tween_property(name_value, "position:y", -205, .3).set_delay(.1)
		global.is_detailed = true
		top_level = true

func _on_area_2d_mouse_entered():
	if not global.is_dragging:
		draggable = true

func _on_area_2d_mouse_exited():
	if not global.is_dragging:
		draggable = false
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, "scale", Vector2(min_card_scale,min_card_scale), .3)
	tween.tween_property(mana_point, "position:x", stat_start_pos, .3).set_delay(.1)
	tween.tween_property(health, "position:x", stat_start_pos, .3).set_delay(.075)
	tween.tween_property(deffense, "position:x", stat_start_pos, .3).set_delay(.05)
	tween.tween_property(attack, "position:x", stat_start_pos, .3).set_delay(.025)
	tween.tween_property(name_value, "position:y", stat_start_pos, .3).set_delay(0)
	set_stats(false)
	global.is_detailed = false
	top_level = false

func _on_area_2d_body_entered(body):
	if body.is_in_group('dropable'):
		print("Yes, it is dropable")
		is_inside_dropable = true
		body.modulate = Color(Color(0, 0, 0, 0.706))
		body_ref = body
		draggable = true


func _on_area_2d_body_exited(body):
	is_inside_dropable = false
	body.modulate = Color(Color(0.5, 0.5, 0.5, 0.706))
