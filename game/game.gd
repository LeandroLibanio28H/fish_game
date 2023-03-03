extends Node2D

const BUBBLE_SCENE = preload("res://bubble/bubble.tscn")

@export var fish : Area2D

var rng := RandomNumberGenerator.new()

var count : int = 0
var score : int = 0

var next : Node2D = null
var next2 : Node2D = null


func _ready() -> void:
	rng.randomize()
	spawn_gems(null, 2)
	fish.started_play.connect( 
		func ():
			$Timer.start()
	)

func spawn_gems(bubble : Node2D = null, _count := 1) -> void:
	for i in _count:
		var gem := BUBBLE_SCENE.instantiate()
		var pos := Vector2.ZERO
		while pos == Vector2.ZERO or pos.distance_to(fish.global_position) < 250.0:
			pos = Vector2(
				randf_range(200.0, 1080 - 200),
				randf_range(200.0, 1920 - 200)
			)
		if next != null:
			while pos == Vector2.ZERO or pos.distance_to(next.position) < 250:
				pos = Vector2(
					randf_range(200.0, 1080 - 200),
					randf_range(200.0, 1920 - 200)
				)
		gem.global_position = pos
		gem.name = str(count)
		count += 1
		gem.collected.connect(spawn_gems)
		call_deferred("add_child", gem)
		if not bubble:
			if next:
				next2 = gem
			else:
				next = gem
		elif score == 0:
			if bubble == next:
				next = next2
				next2 = gem
				score += 1
				var time = $Timer.time_left
				$Timer.stop()
				time += 1.2
				$Timer.start(time)
				$CanvasLayer/HUD.set_score(score)
		else:
			if bubble != next:
				$CanvasLayer/HUD.lose()
				$Timer.stop()
			else:
				next = next2
				next2 = gem
				score += 1
				var time = $Timer.time_left
				$Timer.stop()
				time += 1.2
				$Timer.start(time)
				$CanvasLayer/HUD.set_score(score)


func _process(_delta: float) -> void:
	$CanvasLayer/HUD.set_time($Timer.time_left as int)
