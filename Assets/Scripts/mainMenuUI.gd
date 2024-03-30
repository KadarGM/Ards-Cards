extends CanvasLayer

@onready var menu = $MainMenu
@onready var decks_menu = $ManageDecks
@onready var setting_menu = $SettingMenu
@onready var logo = $Logo

var tween: Tween

func _ready():
	menu.visible = false
	decks_menu.visible = false
	setting_menu.visible = false
	logo.visible = false
	menu.position = Vector2(-400,0)
	decks_menu.position = Vector2(-400,0)
	setting_menu.position = Vector2(-400,0)
	logo.position = Vector2(logo.size.x,0)
	animation()

func animation():
	menu.visible = true
	logo.visible = true
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(logo, "position", Vector2(0,0), 0.5)
	tween.tween_property(menu, "position", Vector2(0,0), 0.5)

func _on_play_button_pressed():
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(menu, "position", Vector2(-400,0), 0.5)
	tween.tween_property(logo, "position", Vector2(logo.size.x,0), 0.7)
	tween.tween_property(menu, "visible", false, 0.2)
	tween.tween_property(logo, "visible", false, 0.2)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Assets/Scenes/game.tscn")

func _on_manage_deck_button_pressed():
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(menu, "position", Vector2(-400,0), 0.5)
	tween.tween_property(decks_menu, "position", Vector2(0,0), 0.5)
	tween.tween_property(menu, "visible", false, 0.2)
	decks_menu.visible = true

func _on_setting_button_pressed():
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(menu, "position", Vector2(-400,0), 0.5)
	tween.tween_property(setting_menu, "position", Vector2(0,0), 0.5)
	tween.tween_property(menu, "visible", false, 0.2)
	setting_menu.visible = true

func _on_back_button_pressed():
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(decks_menu, "position", Vector2(-400,0), 0.5)
	tween.tween_property(menu, "position", Vector2(0,0), 0.5)
	tween.tween_property(decks_menu, "visible", false, 0.2)
	menu.visible = true

func _on_back_setting_button_pressed():
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(setting_menu, "position", Vector2(-400,0), 0.5)
	tween.tween_property(menu, "position", Vector2(0,0), 0.5)
	tween.tween_property(setting_menu, "visible", false, 0.2)
	menu.visible = true
	
func _on_exit_button_pressed():
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(menu, "position", Vector2(-400,0), 0.5)
	tween.tween_property(logo, "position", Vector2(logo.size.x,0), 0.7)
	tween.tween_property(menu, "visible", false, 0.2)
	tween.tween_property(logo, "visible", false, 0.2)
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
