extends Control



var lost := false


func set_score(score : int) -> void:
	$Margin/Score.text = str(score)



func set_time(time : int) -> void:
	$Margin/Timer.text = str(time)


func lose() -> void:
	lost = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	$Margin/Message.text += $Margin/Score.text
	$Margin/Message.show()



func _input(event: InputEvent) -> void:
	if lost:
		if event is InputEventScreenTouch:
			if event.is_pressed():
				get_tree().reload_current_scene()
