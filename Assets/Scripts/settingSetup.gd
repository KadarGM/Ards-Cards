extends Control

@onready var resolution_menu = $HBoxContainer/ChoiceVBox/ResolutionMenu
@onready var screen_menu = $HBoxContainer/ChoiceVBox/ScreenMenu
@onready var fullscreen_box = $HBoxContainer/ChoiceVBox/FullscreenBox
@onready var borderless_box = $HBoxContainer/ChoiceVBox/BorderlessBox
@onready var ui_scaler = $HBoxContainer/ChoiceVBox/HBoxContainer/UIScaler
@onready var ui_scaler_text = $HBoxContainer/ChoiceVBox/HBoxContainer/UIScalerText

var Resolutions : Dictionary = {
	"3840 x 2160":Vector2i(3840,2160),
	"2560 x 1440":Vector2i(2560,1080),
	"1920 x 1080":Vector2i(1920,1080),
	"1280 x 720":Vector2i(1280,720),
	}

func _ready():
	add_resolutions()
	check_variables()
	get_screens()
	check_texts()

func check_variables():
	var _window = get_window()
	var mode = _window.get_mode()
	
	if mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
		resolution_menu.set_disabled(true)
		fullscreen_box.set_pressed_no_signal(true)

func check_texts():
	remove_resolutions()
	add_resolutions()
	get_tree().create_timer(.05).timeout.connect(set_resolution_text)
	get_tree().create_timer(.05).timeout.connect(change_borderless_text)
	get_tree().create_timer(.05).timeout.connect(set_monitor_text)

func set_resolution_text():
	var resolution_text = str(get_window().get_size().x) + "x" + str(get_window().get_size().y)
	resolution_menu.set_text(resolution_text)

func set_monitor_text():
	var active_screen =  DisplayServer.window_get_current_screen()
	var monitor_text = "Screen: "+str(active_screen)
	screen_menu.set_text(monitor_text)
	screen_menu.select(active_screen)

func change_borderless_text():
	var _window = get_window()
	var mode = _window.get_mode()

	if mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
		borderless_box.text = "Exclusive"
	else:
		borderless_box.text = "Borderless"

func add_resolutions():
	var current_resolution = get_window().get_size()
	var ID = 0
	for r in Resolutions:
		resolution_menu.add_item(r, ID)
		if Resolutions[r] == current_resolution:
			resolution_menu.select(ID)
		ID += 1

func remove_resolutions():
	var current_resolution = get_window().get_size()
	var ID = Resolutions.size()
	print(Resolutions.size())
	for r in range(ID+1):
		resolution_menu.remove_item(ID)
		ID -= 1

func _on_resolution_menu_item_selected(index):
	var ID = resolution_menu.get_item_text(index)
	get_window().set_size(Resolutions[ID])
	centre_window()
	get_tree().create_timer(.05).timeout.connect(set_monitor_text)

func centre_window():
	var center_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(center_screen - window_size/2)

func _on_fullscreen_box_toggled(toggled_on):
	resolution_menu.set_disabled(toggled_on)
	if toggled_on:
		get_window().set_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)
		borderless_box.button_pressed = true
		borderless_box.text = "Exclusive"
	else:
		get_window().set_mode(Window.MODE_WINDOWED)
		borderless_box.button_pressed = false
		borderless_box.text = "Borderless"
		centre_window()
	check_texts()

func get_screens():
	var screens = DisplayServer.get_screen_count()
	if screens > 1:
		screen_menu.visible = true
		for s in screens:
			screen_menu.add_item("Screen: "+str(s))
	else:
		screen_menu.visible = false

func _on_screen_menu_item_selected(index):
	var _window = get_window()
	var mode = _window.get_mode()

	_window.set_mode(Window.MODE_WINDOWED)
	_window.set_current_screen(index)

	if mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
		_window.set_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)
	check_texts()

func _on_borderless_box_toggled(toggled_on):
	var _window = get_window()
	var mode = _window.get_mode()

	if toggled_on:
		if mode == Window.MODE_EXCLUSIVE_FULLSCREEN or mode == Window.MODE_FULLSCREEN:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			_window.set_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			_window.set_mode(Window.MODE_WINDOWED)
	else:
		if mode == Window.MODE_EXCLUSIVE_FULLSCREEN or mode == Window.MODE_FULLSCREEN:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			_window.set_mode(Window.MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			_window.set_mode(Window.MODE_WINDOWED)
			borderless_box.button_pressed = false
	check_texts()



