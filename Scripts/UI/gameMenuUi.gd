extends Control

@onready var setting_menu = $"../Control2/SettingMenu"
@onready var game_menu = $GameMenu
@onready var setting_button = $GameMenu/HBoxContainer/VBoxContainer/settingButton

var save_setting_path = "res://save/"
var save_setting_name = "UI_config.tres"

var setting_data_resource : SettingDataResource

func _ready():
	load_data()

func load_data():
	if !DirAccess.dir_exists_absolute(save_setting_path):
		DirAccess.make_dir_absolute(save_setting_path)
	
	if ResourceLoader.exists(save_setting_path + save_setting_name):
		setting_data_resource = ResourceLoader.load(save_setting_path + save_setting_name)

	if setting_data_resource == null:
		setting_data_resource = SettingDataResource.new()
		
	if setting_data_resource != null:
		set_ui_scale(setting_data_resource.scale_ui)
	
func set_ui_scale(scale_ui):
	setting_menu.scale.x = scale_ui
	setting_menu.scale.y = scale_ui
	setting_button.custom_minimum_size *= Vector2(scale_ui,scale_ui)
	setting_button.add_theme_constant_override("icon_max_width", scale_ui*48)
