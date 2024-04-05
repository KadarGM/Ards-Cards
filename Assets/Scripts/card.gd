extends Node2D

var card = self

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

func _ready():
	mana_point.position.x = 0
	health.position.x = 0
	deffense.position.x = 0
	attack.position.x = 0
	name_value.position.y = 0

func _on_area_2d_mouse_entered():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(card, "scale", Vector2(2.5,2.5), .3)
	tween.tween_property(mana_point, "position:x", 150, .3).set_delay(0)
	tween.tween_property(health, "position:x", 150, .3).set_delay(.025)
	tween.tween_property(deffense, "position:x", 150, .3).set_delay(.05)
	tween.tween_property(attack, "position:x", 150, .3).set_delay(.075)
	tween.tween_property(name_value, "position:y", -205, .3).set_delay(.1)
	self.top_level = true

func _on_area_2d_mouse_exited():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(card, "scale", Vector2(1,1), .3)
	tween.tween_property(mana_point, "position:x", 0, .3).set_delay(.1)
	tween.tween_property(health, "position:x", 0, .3).set_delay(.075)
	tween.tween_property(deffense, "position:x", 0, .3).set_delay(.05)
	tween.tween_property(attack, "position:x", 0, .3).set_delay(.025)
	tween.tween_property(name_value, "position:y", 0, .3).set_delay(0)
	self.top_level = false
