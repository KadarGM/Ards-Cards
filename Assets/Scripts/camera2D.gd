extends Camera2D

const DEAD_ZONE = 300
const SPEED = 1.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var _target = get_local_mouse_position()
		if _target.length() < DEAD_ZONE:
			self.position = Vector2(0,0)
		else:
			self.position = _target.normalized() * (_target.length() - DEAD_ZONE) * SPEED
