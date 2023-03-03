extends Area2D



@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

signal started_play

var tween_motion : Tween
var tween_sound: Tween
var started := false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed():
			_move_to_touch(event.position)


func _move_to_touch(pos : Vector2) -> void:
	if not started:
		started_play.emit()
		started = true
	const VOLUME_MIN = -10
	const VOLUME_MAX = 20

	audio_stream_player.volume_db = VOLUME_MIN
	audio_stream_player.play()
	
	if tween_sound:
		tween_sound.kill()
	tween_sound = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween_sound.tween_property(audio_stream_player, "volume_db", VOLUME_MAX, 0.5).set_ease(Tween.EASE_OUT)
	tween_sound.tween_property(audio_stream_player, "volume_db", VOLUME_MIN, 0.5).set_ease(Tween.EASE_IN)
	
	
	if tween_motion:
		tween_motion.kill()
	var target_rotation := global_position.direction_to(pos).angle()
	tween_motion = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween_motion.tween_property(self, "global_position", pos, 1.0)
	tween_motion.parallel().tween_property(self, "rotation", target_rotation, 0.25)
