extends Resource
class_name SettingDataResource

@export var resolution : Vector2i = Vector2i(1280,720)
@export var resolution_id : int = 0
@export var screen_id : int = 0
@export var scale_ui : float = 1.0
@export var fullscreen : bool = false
@export var borderless : bool = false

func change_resolution_id(value: int):
	resolution_id = value
func change_resolution(value: Vector2i):
	resolution = value
func change_screen(value: int):
	screen_id = value
func change_scale_ui(value: float):
	scale_ui = value
func change_fullscreen(value: bool):
	fullscreen = value
func change_borderless(value: bool):
	borderless = value
