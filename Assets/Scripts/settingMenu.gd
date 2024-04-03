extends Control

var Resolutions : Dictionary = {
	"1280 x 720":Vector2i(1280,720),
	"1920 x 1080":Vector2i(1920,1080),
	"2560 x 1440":Vector2i(2560,1440),
	"3840 x 2160":Vector2i(3840,2160),
	}

@onready var texture_rect = $SettingMenu/HBoxContainer/ChoiceVBox/TextureRect
@onready var resolution_menu = $SettingMenu/HBoxContainer/ChoiceVBox/ResolutionMenu
@onready var screen_menu = $SettingMenu/HBoxContainer/ChoiceVBox/ScreenMenu
@onready var ui_scaler_text = $SettingMenu/HBoxContainer/ChoiceVBox/HBoxContainer/UIScalerText
@onready var ui_scaler = $SettingMenu/HBoxContainer/ChoiceVBox/HBoxContainer/UIScaler
@onready var fullscreen_box = $SettingMenu/HBoxContainer/ChoiceVBox/FullscreenBox
@onready var borderless_box = $SettingMenu/HBoxContainer/ChoiceVBox/BorderlessBox
@onready var back_button = $SettingMenu/HBoxContainer/ChoiceVBox/backButton

@onready var setting_menu = $SettingMenu
@onready var main_menu = $MainMenu
@onready var manage_decks = $ManageDecks

var save_setting_path = "res://save/"
var save_setting_name = "UI_config.tres"
var setting_data_resource : SettingDataResource
	

func _ready():
	add_resolutions()
	check_texts()
	check_variables()
	get_screens()
	load_data()

func load_data():
	if !DirAccess.dir_exists_absolute(save_setting_path):
		DirAccess.make_dir_absolute(save_setting_path)
	
	if ResourceLoader.exists(save_setting_path + save_setting_name):
		setting_data_resource = ResourceLoader.load(save_setting_path + save_setting_name)

	if setting_data_resource == null:
		setting_data_resource = SettingDataResource.new()
		
	if setting_data_resource != null:
		set_mode(setting_data_resource.fullscreen, setting_data_resource.borderless)
		set_resolution(setting_data_resource.resolution, setting_data_resource.resolution_id)
		set_ui_scale(setting_data_resource.scale_ui)
		set_screen(setting_data_resource.screen_id)
	print("loaded")

func set_mode(fullscreen, borderless):
	match fullscreen:
		true:
			if borderless == false:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
				fullscreen_box.button_pressed = true
				borderless_box.button_pressed = false
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
				fullscreen_box.button_pressed = true
				borderless_box.button_pressed = true
		false:
			if borderless == false:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
				fullscreen_box.button_pressed = false
				borderless_box.button_pressed = false
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
				fullscreen_box.button_pressed = false
				borderless_box.button_pressed = true
			centre_window()
	check_texts()
	print("set mode loaded")

func set_resolution(resolution, resolution_id):
	get_window().set_size(resolution)
	setting_data_resource.resolution = resolution
	setting_data_resource.resolution_id = resolution_id
	resolution_menu.select(resolution_id)
	check_texts()
	centre_window()
	print("resolution loaded")
	
func set_ui_scale(scale_ui):
	ui_scaler.value = scale_ui*100
	setting_menu.scale = Vector2(scale_ui, scale_ui)
	main_menu.scale = Vector2(scale_ui, scale_ui)
	manage_decks.scale = Vector2(scale_ui, scale_ui)
	ui_scaler_text.set_text("UI: " + str(scale_ui*100) + "%")

func set_screen(screen):
	screen_menu.select(screen)
	setting_data_resource.screen_id = screen
	var monitor_text = "Screen: "+str(screen)
	screen_menu.set_text(monitor_text)

func save_data():
	ResourceSaver.save(setting_data_resource, save_setting_path + save_setting_name)
	print("saved")

func check_variables():
	var _window = get_window()
	var mode = _window.get_mode()
	
	if mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
		resolution_menu.set_disabled(true)
		fullscreen_box.set_pressed_no_signal(true)

func check_texts():
	get_tree().create_timer(.05).timeout.connect(set_resolution_text)
	get_tree().create_timer(.05).timeout.connect(change_borderless_text)
	get_tree().create_timer(.05).timeout.connect(set_monitor_text)
	get_tree().create_timer(.05).timeout.connect(set_scale_text)

func set_resolution_text():
	var resolution = get_window().get_size()
	var resolution_text = str(resolution.x) + "x" + str(resolution.y)
	resolution_menu.set_text(resolution_text)

func set_monitor_text():
	var active_screen = DisplayServer.window_get_current_screen()
	var monitor_text = "Screen: "+str(active_screen)
	screen_menu.set_text(monitor_text)
	screen_menu.select(active_screen)

func change_borderless_text():
	var _window = get_window()
	var mode = _window.get_mode()

	if mode == Window.MODE_EXCLUSIVE_FULLSCREEN or mode == Window.MODE_FULLSCREEN:
		borderless_box.text = "Exclusive"
	else:
		borderless_box.text = "Borderless"

func add_resolutions():
	var current_resolution = get_window().get_size()
	var ID = 0
	resolution_menu.clear()
	for r in Resolutions:
		resolution_menu.add_item(r, ID)
		if Resolutions[r] == current_resolution:
			resolution_menu.select(ID)
			break
		ID += 1

func _on_resolution_menu_item_selected(index):
	setting_data_resource.change_resolution_id(index)
	var ID = resolution_menu.get_item_text(setting_data_resource.resolution_id)
	setting_data_resource.change_resolution(Resolutions[ID])
	get_window().set_size(Resolutions[ID])
	check_texts()
	centre_window()

func centre_window():
	var center_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(center_screen - window_size/2)

func _on_fullscreen_box_toggled(toggled_on):
	setting_data_resource.change_fullscreen(toggled_on)
	resolution_menu.set_disabled(setting_data_resource.fullscreen)
	if setting_data_resource.fullscreen:
		get_window().set_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)
		fullscreen_box.button_pressed = true
		borderless_box.button_pressed = true
		borderless_box.text = "Exclusive"
	else:
		get_window().set_mode(Window.MODE_WINDOWED)
		fullscreen_box.button_pressed = false
		borderless_box.button_pressed = false
		borderless_box.text = "Borderless"
	check_texts()
	centre_window()

func get_screens():
	var screens = DisplayServer.get_screen_count()
	if screens > 1:
		screen_menu.visible = true
		for s in screens:
			screen_menu.add_item("Screen: "+str(s))
	else:
		screen_menu.visible = false

func _on_screen_menu_item_selected(index):
	setting_data_resource.change_screen(index)
	var _window = get_window()
	var mode = _window.get_mode()
	_window.set_mode(Window.MODE_WINDOWED)
	_window.set_current_screen(setting_data_resource.screen_id)

	if mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
		_window.set_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)
	check_texts()
	centre_window()

func _on_borderless_box_toggled(toggled_on):
	setting_data_resource.change_borderless(toggled_on)
	var _window = get_window()
	var mode = _window.get_mode()
	if setting_data_resource.borderless:
		if mode == Window.MODE_EXCLUSIVE_FULLSCREEN or mode == Window.MODE_FULLSCREEN:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			_window.set_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)
			fullscreen_box.button_pressed = true
			borderless_box.button_pressed = true
		else:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			_window.set_mode(Window.MODE_WINDOWED)
			fullscreen_box.button_pressed = false
			borderless_box.button_pressed = true
			centre_window()
	else:
		if mode == Window.MODE_EXCLUSIVE_FULLSCREEN or mode == Window.MODE_FULLSCREEN:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			_window.set_mode(Window.MODE_FULLSCREEN)
			fullscreen_box.button_pressed = true
			borderless_box.button_pressed = false
		else:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			_window.set_mode(Window.MODE_WINDOWED)
			fullscreen_box.button_pressed = false
			borderless_box.button_pressed = false
			centre_window()
	check_texts()

func _on_ui_scaler_value_changed(value):
	setting_data_resource.change_scale_ui(value/100)
	var scale_ui = value/100
	ui_scaler_text.set_text("UI: " + str(scale_ui*100) + "%")
	setting_menu.scale = Vector2(scale_ui, scale_ui)
	main_menu.scale = Vector2(scale_ui, scale_ui)
	manage_decks.scale = Vector2(scale_ui, scale_ui)

func set_scale_text():
	ui_scaler_text.set_text("UI: " + str(setting_data_resource.scale_ui*100) + "%")

func _on_back_button_pressed():
	save_data()
