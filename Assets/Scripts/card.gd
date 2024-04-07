extends Node2D

var draggable = false
var is_inside = false
var offset: Vector2
var initialPos: Vector2
var body_ref

var max_card_scale = 2
var min_card_scale = 1

@onready var card_trans = $cardTrans
@onready var name_label = $cardTrans/NameLabel
@onready var card_stats = $cardTrans/CardStats

func _ready():
	set_stats(false)

func set_stats(cond):
	card_stats.visible = cond
	name_label.visible = cond

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
			if is_inside:
				tween.tween_property(self,"global_position",body_ref.global_position,.2)
			else:
				tween.tween_property(self,"global_position",initialPos,.2)

		if Input.is_action_just_released("right click"):
			var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
			tween.tween_property(card_trans, "scale", Vector2(min_card_scale,min_card_scale), .3)
			set_stats(false)
			global.is_detailed = false
			top_level = false
		if global.is_detailed == false:
			detail_card()

func detail_card():
	if Input.is_action_pressed("right click"):
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
		tween.tween_property(card_trans, "scale", Vector2(max_card_scale,max_card_scale), .3)
		set_stats(true)
		tween.tween_property(name_label, "position:y", -205, .3).set_delay(.1)
		global.is_detailed = true
		top_level = true

func _on_area_2d_mouse_entered():
	if not global.is_dragging:
		draggable = true

func _on_area_2d_mouse_exited():
	if not global.is_dragging:
		draggable = false
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(card_trans, "scale", Vector2(min_card_scale,min_card_scale), .3)
	set_stats(false)
	global.is_detailed = false
	top_level = false

func _on_area_2d_body_entered(body):
	is_inside = true
	body_ref = body
	#draggable = true
	body.visible = false
		

func _on_area_2d_body_exited(body):
	is_inside = false
	body.visible = true
