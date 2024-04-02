extends CanvasLayer

@onready var menu = $MainMenu
@onready var decks_menu = $ManageDecks
@onready var setting = $SettingSetup
@onready var ui_scaler_text = $SettingSetup/HBoxContainer/ChoiceVBox/HBoxContainer/UIScalerText
@onready var ui_scaler = $SettingSetup/HBoxContainer/ChoiceVBox/HBoxContainer/UIScaler

func _ready():
	start()
	set_scale_on_start()

func start():	
	menu.visible = true
	decks_menu.visible = false
	setting.visible = false
	setting.pivot_offset = setting.size/2
	decks_menu.pivot_offset = decks_menu.size/2
	menu.pivot_offset = menu.size/2

func _on_play_button_pressed():
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Assets/Scenes/game.tscn")

func _on_manage_deck_button_pressed():
	menu.visible = false
	decks_menu.visible = true

func _on_setting_button_pressed():
	menu.visible = false
	setting.visible = true

func _on_back_button_pressed():
	decks_menu.visible = false
	menu.visible = true

func _on_exit_button_pressed():
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()

func _on_back_setting_button_pressed():
	setting.visible = false
	menu.visible = true

func set_scale_on_start():
	ui_scaler_text.set_text("UI: " + str(ui_scaler.value) + "%")

func _on_ui_scaler_value_changed(value):
	ui_scaler_text.set_text("UI: " + str(value) + "%")
	setting.scale = Vector2(value/100, value/100)
	menu.scale = Vector2(value/100, value/100)
	decks_menu.scale = Vector2(value/100, value/100)
