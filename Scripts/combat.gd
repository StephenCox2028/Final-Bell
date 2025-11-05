extends Node2D
@onready var animation: AnimationPlayer = $Animation
@onready var character = $Character
@export var isdodge = false # is your ability to get hit(if not dodgeing you can get smacked) -Stephen
@export var ispunch = false # is your boolean for punching. - Stephen
@export var isHolding = false #is your boolean for holding down a button - Stephen
@export var canmove = true # is your inability to move(if you cant move you cant dodge) - Stephen
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var staminaCooldown = $StaminaCooldown
@onready var sweatParticles = $Character/SweatParticles

const ENEMY = preload("res://Scenes/enemys.tscn")
const BOSS = preload("res://Scenes/bosses.tscn")

var originalPos = Vector2(588.0, 401.0)		#Original position of the character. - Stephen
const HOLD_TIME_THRESHOLD = 0.5
const SHAKE_STRENGTH = 10.0		#Strength and intensity of player shaking. - Stephen
var heldTime = 0
var exhaustion = false

#Dictionary value that carries the time intervals for each attack. It starts with a negative number
#to allow for a longer press to be able to hook. - Stephen
var pressTimes = {
	"leftAttack": -1.0,
	"rightAttack": -1.0
}

var health: float = 100.0

#Rounds and Timer - Mirza 
var timer: Timer
var time_in_seconds : int = 0
var rounds = 0

func _ready():
	isdodge = false
	ispunch = false
	isHolding = false
	canmove = true
	progress_bar.value = (100)

	
	if (Global.boss_flip == true) :
		var boss = BOSS.instantiate()
			# Optional: set position or random offset
		boss.position = Vector2(605, 235)
		boss.scale = Vector2(3,3)
			# Add it as a child of this scene
		add_child(boss)
	else:
		var enemy = ENEMY.instantiate()
		
			# Optional: set position or random offset
		enemy.position = Vector2(605, 235)
		enemy.scale = Vector2(3,3)
			# Add it as a child of this scene
		add_child(enemy)
		print(Global.playerStats.stamina)
		print(Global.playerStats.health)
		print(Global.playerStats.power)

func _process(delta) -> void:
	if exhaustion == false:
		#If the player reaches ZERO stamina, cause Exhaustion.
		if Global.playerStats.stamina <= 0:
			exhaustion = true
			sweatParticles.emitting = true
			staminaCooldown.start()
		#If player is at max (or greater than max) stamina, keep at max.
		if Global.playerStats.stamina >= Global.playerStats.maxStamina:
			Global.playerStats.stamina = Global.playerStats.maxStamina
	if !(Global.playerStats.stamina >= Global.playerStats.maxStamina):
		Global.playerStats.stamina += 0.01
	print(Global.getPlayerStamina())

func _on_stamina_cooldown_timeout():
	sweatParticles.emitting = false
	exhaustion = false

func on_timer_timeout():
	var m = 0
	var s = 0
	time_in_seconds += 1
	m = int(time_in_seconds / 60) #calulates minutes
	s = time_in_seconds - m * 60 #calculates seconds 
	start_nextRound(rounds) #starts round 1 and sets new rounds
	$Label.text = '%02d:%02d' % [m, s] #outputs minutes and seconds on label
	if m == 1  && s == 30:
		start_nextRound(rounds) 

func start_nextRound(rounds):
	rounds += 1
	$rounds.text = 'Rounds: ' + str(rounds)
	if rounds > 8:
		end_match()

func end_match():
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")

#Player dodge and attack inputs - Stephen
func _input(event):
	if Input.is_action_just_pressed("dodgeright"): 
		if Global.getPlayerStamina() > 0 and exhaustion == false:
			if canmove == true: # Conditional to check if the player is able to make a move.
				if isdodge == false: # Checks to see if you aren't in the middle of dodging.
					if isHolding == false:	# isHolding checks to see if the player is holding down one of the attack keys.
						isdodge = true
						animation.play("dodgeright")
						Global.playerStats.dodging = true	# This allows for the global script to know that the player is dodging.
						Global.depleteStamina("dodge", heldTime)
						pass
	if Input.is_action_just_pressed("dodgeleft"):
		if Global.getPlayerStamina() > 0 and exhaustion == false:
			if canmove == true: # Conditional to check if the player is able to make a move.
				if isdodge == false: # Checks to see if you aren't in the middle of dodging.
					if isHolding == false:	# isHolding checks to see if the player is holding down one of the attack keys.
						isdodge = true
						animation.play("dodgeleft")
						Global.playerStats.dodging = true	# This allows for the global script to know that the player is dodging.
						Global.depleteStamina("dodge", heldTime)
						pass

	if Input.is_action_pressed("attackLeft"):
		if Global.getPlayerStamina() > 0 and exhaustion == false:
			if isHolding == false:	#If Q is not being held down.
				pressTimes["leftAttack"] = Time.get_ticks_msec() / 1000.0	#Tracks the total time that the process has been running.
				isHolding = true
			heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["leftAttack"]	#Tracks the time that Q has been held by subtracting the present process time to the time that Q was first held down.
			if heldTime >= HOLD_TIME_THRESHOLD and isHolding == true:	#If Q has been held longer than the HOLD_TIME_THRESHOLD... 
				start_shake()	#Run the shaking function.
				heldTime = 0	#Set heldTime back to 0. 
	if Input.is_action_just_released("attackLeft"):
		if Global.getPlayerStamina() > 0 and exhaustion == false:
			if isdodge == false:
				heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["leftAttack"]
				if heldTime < HOLD_TIME_THRESHOLD and isHolding == true:	#If the hold time is less than the HOLD_TIME_THRESHOLD 
					animation.play("punch") #Simply punch
					Global.depleteStamina("attack", heldTime)
				else:
					animation.play("punch")
					Global.depleteStamina("hook", heldTime)
				heldTime = 0		#Reset holdTime
				isHolding = false
				if character.position != originalPos:	#If the character position is not at it's original...
					character.position = originalPos	#Reset the position after shaking.
					animation.play("punch")

	if Input.is_action_pressed("attackRight"):
		if Global.getPlayerStamina() > 0 and exhaustion == false:
			if isHolding == false:	#If E is not being held down.
				pressTimes["rightAttack"] = Time.get_ticks_msec() / 1000.0		#Tracks the total time that the process has been running.
				isHolding = true
			heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["rightAttack"]	#Tracks the time that Q has been held by subtracting the present process time to the time that E was first held down.
			if heldTime >= HOLD_TIME_THRESHOLD and isHolding == true:	#If E has been held longer than the HOLD_TIME_THRESHOLD...
				start_shake()	#Run the shaking function.
				heldTime = 0	#Set heldTime back to 0.
	if Input.is_action_just_released("attackRight"):
		if Global.getPlayerStamina() > 0 and exhaustion == false:
			if isdodge == false:
				heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["rightAttack"]
				if heldTime < HOLD_TIME_THRESHOLD and isHolding == true:	#If the hold time is less than the HOLD_TIME_THRESHOLD
					animation.play("punch")	#Simply punch
					Global.depleteStamina("attack", heldTime)
				else:
					animation.play("punch")
					Global.depleteStamina("hook", heldTime)
				heldTime = 0	#Resets holdTime
				isHolding = false
				if character.position != originalPos:	#If the character position is not at it's original...
					character.position = originalPos	#Reset the position after shaking.
					animation.play("punch")

func _on_animation_animation_finished(anim_name):
	if anim_name == "dodgeleft" and anim_name == "dodgeright":
		canmove = true
		isdodge = false
		isHolding = false
		Global.playerStats.dodge = false

#shake hook animation - Stephen
func start_shake():
	#This line changes the character position from it's original to a random Vector2 depending on the shake strength. Since the function repeatedly runs
	#while either Q or E is held down, it looks like the character is shaking, but in reality the character is shifting positions quickly.
	character.position = originalPos + Vector2(randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH), randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH))
	await get_tree().process_frame	#Waits for the next frame.

	if isHolding:	#If the player is still holding down a key, repeat the function.
		start_shake()

func DamageTaken():
	var jab = 0.005 
	var cross = 0.01
	var hook = 0.02
	var block = 0.0025
	var probablityJab = 85
	var probablityCross = 65
	var probablityHook = 50
	var probablityBlock = 100
	var fighting_Moves = [1,2,3,4] # An array showing all four possible attacks. 
	
	for fighting_Move in fighting_Moves: # repeats moves for multiple attacks
		var chance = randi() % 100 +1
		match fighting_Move:
			1:	
				if chance <= probablityBlock: #Checks the probablitiy if you will block. It's 100% so you will always block.
					health -= block #Does minor damage if enemy hits you
					print ("Health:", health)  # This prints out your current health.
			2:#Exact same with the rest.
				if chance <= probablityJab:
					health -= jab
					print ("Health:", health)
			3:
				if chance <= probablityCross:
					health -= cross
					print ("Health:", health)
			4:
				if chance <= probablityHook:
					health -= hook
					print ("Health:")
		progress_bar.value = (health/100)
		print("apple sauce")

	if health <= 0:
		health = 0
		print ("You Died")
