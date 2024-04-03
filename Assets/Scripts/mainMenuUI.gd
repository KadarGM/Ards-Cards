extends CanvasLayer

@onready var setting_menu = $Control/SettingMenu
@onready var main_menu = $Control/MainMenu
@onready var manage_decks = $Control/ManageDecks

func _ready():
	start()

func start():	
	main_menu.visible = true
	manage_decks.visible = false
	setting_menu.visible = false
	setting_menu.pivot_offset = setting_menu.size/2
	manage_decks.pivot_offset = manage_decks.size/2
	main_menu.pivot_offset = main_menu.size/2

func _on_play_button_pressed():
	main_menu.visible = false
	await get_tree().create_timer(.1).timeout
	#get_tree().change_scene_to_file("res://Assets/Scenes/game.tscn")
	get_tree().quit()

func _on_manage_deck_button_pressed():
	main_menu.visible = false
	manage_decks.visible = true

func _on_setting_button_pressed():
	main_menu.visible = false
	setting_menu.visible = true

func _on_back_button_pressed():
	manage_decks.visible = false
	main_menu.visible = true

func _on_exit_button_pressed():
	main_menu.visible = false
	await get_tree().create_timer(.1).timeout
	get_tree().quit()

func _on_back_setting_button_pressed():
	setting_menu.visible = false
	main_menu.visible = true
