extends Control

@onready var resolution_menu = $MarginContainer/HBoxContainer/ChoiceVBox/ResolutionMenu
@onready var screen_menu = $MarginContainer/HBoxContainer/ChoiceVBox/ScreenMenu
@onready var scale_slider = $MarginContainer/HBoxContainer/ChoiceVBox/ScaleBox/ScaleSlider
@onready var scale_label = $MarginContainer/HBoxContainer/ChoiceVBox/ScaleBox/ScaleLabel
@onready var fullscreen_box = $MarginContainer/HBoxContainer/ChoiceVBox/FullscreenBox
@onready var fsr_options = $MarginContainer/HBoxContainer/ChoiceVBox/FSROptions

var Resolutions : Dictionary = {
	"3840x2160":Vector2i(3840,2160),
	"2560x1440":Vector2i(2560,1080),
	"1920x1080":Vector2i(1920,1080),
	"1280x720":Vector2i(1280,720),
	}

func _ready():
	add_resolutions()
	check_variables()

func check_variables():
	var _window = get_window()
	var mode = _window.get_mode()
	
	if mode == Window.MODE_FULLSCREEN:
		resolution_menu.set_disabled(true)
		fullscreen_box.set_pressed_no_signal(true)

func set_resolution_text():
	var resolution_text = str(get_window().get_size().x) + "x" + str(get_window().get_size().y)
	resolution_menu.set_text(resolution_text)

func add_resolutions():
	var current_resolution = get_window().get_size()
	var ID = 0
	for r in Resolutions:
		resolution_menu.add_item(r, ID)
		if Resolutions[r] == current_resolution:
			resolution_menu.select(ID)
		ID += 1

func _on_resolution_menu_item_selected(index):
	var ID = resolution_menu.get_item_text(index)
	get_window().set_size(Resolutions[ID])
	centre_window()

func centre_window():
	var center_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(center_screen - window_size/2)

func _on_fullscreen_box_toggled(toggled_on):
	resolution_menu.set_disabled(toggled_on)
	if toggled_on:
		get_window().set_mode(Window.MODE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)
		centre_window()
	get_tree().create_timer(.05).timeout.connect(set_resolution_text)
