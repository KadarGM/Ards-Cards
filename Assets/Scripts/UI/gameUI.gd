extends CanvasLayer

@onready var setting_menu = $Control2/SettingMenu
@onready var game_menu = $Control/GameMenu
@onready var setting_bg = $Control2/SettingBG
@onready var control_2 = $Control2


func _ready():
	start()

func start():
	game_menu.visible = true
	setting_menu.visible = false
	setting_bg.visible = false
	control_2.visible = false
	setting_menu.pivot_offset = setting_menu.size/2
	game_menu.pivot_offset = game_menu.size/2

func _on_setting_button_pressed():
	game_menu.visible = false
	setting_menu.visible = true
	setting_bg.visible = true
	control_2.visible = true

func _on_exit_button_pressed():
	game_menu.visible = false
	setting_bg.visible = false
	control_2.visible = false
	get_window().set_mode(Window.MODE_WINDOWED)
	get_tree().change_scene_to_file("res://Assets/Scenes/main.tscn")

func _on_back_setting_button_pressed():
	setting_menu.visible = false
	setting_bg.visible = false
	control_2.visible = false
	game_menu.visible = true
