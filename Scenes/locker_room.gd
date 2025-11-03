extends Node2D

const RATS = preload("res://Scenes/rats.tscn")
const PLAYER = preload("res://Scenes/character.tscn")

var rng = RandomNumberGenerator.new()
var timeofset
func _onready():
	pass
func _on_timer_timeout() -> void:
	timeofset = randi_range(-5, 5)
	# make a rat as chird at a location
	spawn_rat()
	# make timer again
	$Timer.wait_time = timeofset + 15
	$Timer.start()
	pass # Replace with function body.
# every 30sec+ 15-30 as a random timer make a child rat and in the rat it 
# will go zoomies until blah x blah y and then DIE
func spawn_rat():
	# Make an instance of the Rat scene
	var rat = RATS.instantiate()

	# Optional: set position or random offset
	rat.position = Vector2(-120, -52)
	# Add it as a child of this scene
	add_child(rat)

	
#Move the character in locker room - Mirza
@onready var sprite: Sprite2D = $Mc  
@onready var hitbox: Area2D = $Mc/player_area
var speed = 100
var player_inside = false

func _ready():
	print("[READY] hitbox layer=", hitbox.collision_layer, " mask=", hitbox.collision_mask)
	hitbox.area_entered.connect(_on_hitbox_entered)
		
func _process(delta):
	var v := Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		sprite.position.y -= speed * delta
	if Input.is_action_pressed("move_down"):
		sprite.position.y += speed * delta
	if Input.is_action_pressed("move_right"):
		sprite.position.x += speed * delta
	if Input.is_action_pressed("move_left"):
		sprite.position.x -= speed * delta
	if v != Vector2.ZERO:
		sprite.position += v.normalized() * speed * delta

func _on_hitbox_entered(area: Area2D):
	Global.boss_flip = true
	get_tree().change_scene_to_file("res://Scenes/combat.tscn")


func _on_next_button_pressed() -> void:
	Global.boss_flip = true
