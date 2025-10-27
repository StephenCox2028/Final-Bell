extends Control
@onready var victory_menu: Control = $"."
@onready var score: Label = $Score

func _ready() -> void:
	score.text = str("Score: ",Global.Score)
