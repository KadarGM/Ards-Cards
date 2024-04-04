extends Node2D

var selected = false

func _ready():
	pass

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left click"):
		selected = true

func _physics_process(delta):
	if selected:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(3,3), 1).set_ease(Tween.EASE_OUT_IN)
		print("entered")
	#elif not selected:
		#var tween = create_tween()
		#tween.tween_property(self, "scale", Vector2(1,1), 1).set_ease(Tween.EASE_OUT_IN)
		#print("exited")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false
