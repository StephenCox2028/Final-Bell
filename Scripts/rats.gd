extends Node2D

var speed := 100.0

func _ready() -> void:
	$AnimatedSprite2D.play("default")
func _process(delta: float) -> void:
	self.position.x += delta * speed
	if (position.x >= 100.0):
		queue_free()
