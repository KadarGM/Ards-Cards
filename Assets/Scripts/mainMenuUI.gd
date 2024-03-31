extends CanvasLayer

@onready var menu = $MainMenu
@onready var decks_menu = $ManageDecks
@onready var setting_menu = $SettingMenu
@onready var logo = $Logo
@onready var logo_rect = $Logo/TextureRect

var tween: Tween

func animation(type,dir1,dir2,cond):
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(type, "position", Vector2(dir1,dir2), 0.5)
	if cond == false:
		tween.tween_property(type, "visible", false, 0.1)
	else:
		type.visible = true
	await get_tree().create_timer(0.4).timeout

func start():
	menu.position = Vector2(-400,0)
	decks_menu.position = Vector2(-400,0)
	setting_menu.position = Vector2(-400,0)
	logo_rect.position = Vector2(logo.size.x,(logo.size.y - logo_rect.size.y)/2)

	menu.visible = false
	decks_menu.visible = false
	setting_menu.visible = false
	logo.visible = true

	animation(logo_rect,logo.size.x - 100 - logo_rect.size.x,(logo.size.y - logo_rect.size.y)/2,true)
	animation(menu,0,0,true)

func _ready():
	start()

func _on_play_button_pressed():
	animation(logo_rect,logo.size.x,(logo.size.y - logo_rect.size.y)/2,false)
	animation(menu,-400,0,false)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Assets/Scenes/game.tscn")

func _on_manage_deck_button_pressed():
	animation(logo_rect,logo.size.x,(logo.size.y - logo_rect.size.y)/2,false)
	animation(decks_menu,0,0,true)
	animation(menu,-400,0,false)

func _on_setting_button_pressed():
	animation(logo_rect,logo.size.x,(logo.size.y - logo_rect.size.y)/2,false)
	animation(setting_menu,0,0,true)
	animation(menu,-400,0,false)

func _on_back_button_pressed():
	animation(logo_rect,logo.size.x - 100 - logo_rect.size.x,(logo.size.y - logo_rect.size.y)/2,true)
	animation(menu,0,0,true)
	animation(decks_menu,-400,0,false)

func _on_back_setting_button_pressed():
	animation(logo_rect,logo.size.x - 100 - logo_rect.size.x,(logo.size.y - logo_rect.size.y)/2,true)
	animation(menu,0,0,true)
	animation(setting_menu,-400,0,false)

func _on_exit_button_pressed():
	animation(logo_rect,logo.size.x,(logo.size.y - logo_rect.size.y)/2,false)
	animation(menu,-400,0,false)
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
