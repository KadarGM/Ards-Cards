extends CanvasLayer

var tween: Tween

func _ready():
	animation()

func animation():
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", Vector2.ONE, 0.3)
	
	visible = true

	
func _on_play_button_pressed():
	pass # Replace with function body.


func _on_manage_deck_button_pressed():
	pass # Replace with function body.


func _on_setting_button_pressed():
	pass # Replace with function body.


func _on_exit_button_pressed():
	get_tree().quit()
