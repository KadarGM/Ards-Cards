extends CanvasLayer

@onready var menu = $MainMenu
@onready var menu_hbox = $MainMenu/MarginContainer/HBoxContainer
@onready var decks_menu = $ManageDecks
@onready var decks_hbox = $ManageDecks/MarginContainer/HBoxContainer
@onready var setting_menu = $SettingMenu
@onready var setting_menu_hbox = $SettingMenu/MarginContainer/HBoxContainer
@onready var logo = $Logo
@onready var setting_setup_hbox = $SettingSetup/MarginContainer/HBoxContainer

var tween: Tween

func _ready():
	start()

func animation(type,dir1,dir2,cond,anim,time):
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(type, anim, Vector2(dir1,dir2), time)
	if cond == false:
		tween.tween_property(type, "visible", false, 0.1)
	else:
		type.visible = true

func start():	
	menu.position = Vector2(-400,0)
	decks_menu.position = Vector2(-400,0)
	setting_menu.position = Vector2(-400,0)
	
	menu.visible = false
	decks_menu.visible = false
	setting_menu.visible = false
	logo.visible = true

	animation(menu,0,0,true,"position",0.7)
	animation(logo,0,0,false,"position",0.7)

func _on_play_button_pressed():
	animation(menu,-400,0,false,"position",0.7)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Assets/Scenes/game.tscn")

func _on_manage_deck_button_pressed():
	animation(decks_menu,0,0,true,"position",0.7)
	animation(menu,-400,0,false,"position",0.7)

func _on_setting_button_pressed():
	animation(setting_menu,0,0,true,"position",0.7)
	animation(menu,-400,0,false,"position",0.7)

func _on_back_button_pressed():
	animation(menu,0,0,true,"position",0.7)
	animation(decks_menu,-400,0,false,"position",0.7)

func _on_back_setting_button_pressed():
	animation(menu,0,0,true,"position",0.7)
	animation(setting_menu,-400,0,false,"position",0.7)

func _on_exit_button_pressed():
	animation(menu,-400,0,false,"position",0.7)
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
