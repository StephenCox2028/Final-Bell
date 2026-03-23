extends Node2D
@onready var animation: AnimationPlayer = $Animation
@export var isdodge = false # is your ability to get hit(if not dodgeing you can get smacked) -Stephen
@export var ispunch = false # is your boolean for punching. - Stephen
@export var isHolding = false #is your boolean for holding down a button - Stephen
@export var canmove = true # is your inability to move(if you cant move you cant dodge) - Stephen
@onready var staminaCooldown = $StaminaCooldown
@onready var transition = $Transition/Transition
@onready var hp_bar: ProgressBar = $Bars/HpBar
@onready var stamina_bar: ProgressBar = $Bars/StaminaBar
@onready var power_bar: ProgressBar = $Bars/PowerBar
@onready var enemy_hp: ProgressBar = $Bars/EnemyHP
@onready var versusScreenAnim = $VersusScreen/AnimationPlayer
@onready var versusScreen = $VersusScreen
#Main Character animation functions - Mirza
@onready var character = $character/MC_animated

@onready var timer: Timer = $Timer
var time_in_seconds : int = 90
var rounds: int = Global.current_round

func idle():
	character.play("Idle")

func charge_right():
	character.play("hook_charge_right")
	
func charge_left():
	character.play("hook_charge_left")

func block_animation():
	character.play("block")
	
func cross_animation():
	character.play("cross")
	
func jab_animation():
	character.play("jab")

func charge_hook():
	character.play("hook_charge")

func leftHook():
	character.play("left_hook")
	
func rightHook():
	character.play("right_hook")

#Sounds
@onready var Punch = $Punch
@onready var Hook = $Hook
@onready var Bell = $Bell
@onready var heartbeat = $Heartbeat

const ENEMY = preload("res://Scenes/enemys.tscn")
const BOSS = preload("res://Scenes/bosses.tscn")

var originalPos = Vector2(917.0, 773)		#Original position of the character. - Stephen
const HOLD_TIME_THRESHOLD = 0.5
const SHAKE_STRENGTH = 10.0		#Strength and intensity of player shaking. - Stephen
var heldTime = 0
var exhaustion = false
@export var battleStarted: bool = Global.battleStarted

#Dictionary value that carries the time intervals for each attack. It starts with a negative number
#to allow for a longer press to be able to hook. - Stephen
var pressTimes = {
	"leftAttack": -1.0,
	"rightAttack": -1.0
}

var health: float = 100.0

func _ready():
	if Global.secretEnabled == true:
		Global.playerStats.health = 50000
		Global.playerStats.maxHealth = 50000
	print(Global.playerStats.health)
	transition.play("fade-in")
	versusScreenAnim.play("Versus")
	Global.combat_ui = self
	isdodge = false
	ispunch = false
	isHolding = false
	canmove = true
	hp_bar.value = (100)
	stamina_bar.value = (100)
	power_bar.value = (0)
	enemy_hp.value = (100)
	enemy_hp.visible = true
	$BarContainer/BarforfightameTop2.visible=true
	Global.playerStats.health = Global.playerStats.maxHealth
	Global.playerStats.stamina = Global.MAXSTAMINA
	Global.playerStats.power = Global.MAXPOWER
	rounds = Global.current_round
	$rounds.text = "Rounds:" + str(rounds)
	start_nextRound()
	timer.start()
	
	# make the power bar dissapear if you are smart but enemy bar apeer
	if Global.Coach == "vamp":
		power_bar.visible = false
		$BarContainer/BarforfightameTop2.visible = false
	if (Global.boss_flip == true) :
		var boss = BOSS.instantiate()
			# Optional: set position or random offset
		boss.position = Vector2(902.0, 640.0)
		boss.scale = Vector2(3,3)
			# Add it as a child of this scene
		add_child(boss)
		move_child(boss, versusScreen.get_index())
	else:
		var enemy = ENEMY.instantiate()
		
			# Optional: set position or random offset
		enemy.position = Vector2(902, 640.0)
		enemy.scale = Vector2(3,3)
			# Add it as a child of this scene
		add_child(enemy)
		move_child(enemy, versusScreen.get_index())
		#print(Global.playerStats.stamina)
		#print(Global.playerStats.health)
		#print(Global.playerStats.power)

func _process(delta) -> void:
	Global.battleStarted = battleStarted
	if battleStarted:
		if Global.getPlayerHealth() <= 10:
			heartbeat.autoplay = true
			heartbeat.play()
		else:
			if heartbeat.playing == true and Global.getPlayerHealth() > 10:
				heartbeat.autoplay = false
				heartbeat.stop()
		if exhaustion == false:
			#If the player reaches ZERO stamina, cause Exhaustion.
			if Global.playerStats.stamina <= 0:
				Global.playerStats.stamina = 0
				exhaustion = true
				staminaCooldown.start()
			#If player is at max (or greater than max) stamina, keep at max.
			if Global.playerStats.stamina >= Global.playerStats.maxStamina:
				Global.playerStats.stamina = Global.playerStats.maxStamina
		#If player is NOT greater or equal to the max stamina, raise stamina.
		if !(Global.playerStats.stamina >= Global.playerStats.maxStamina):
			Global.playerStats.stamina += 0.025
		#print(Global.getPlayerStamina())
		stamina_bar.value=(float(Global.playerStats.stamina)/float(Global.playerStats.maxStamina))*100

func _on_stamina_cooldown_timeout():
	exhaustion = false

func start_nextRound():
	time_in_seconds = 90
	$Label.text = "01:30"
	timer.start()	
	
func on_timer_timeout():
	var m = 0
	var s = 0
	time_in_seconds -= 1
	m = int(time_in_seconds / 60) #calulates minutes
	s = time_in_seconds - m * 60 #calculates seconds 
	$Label.text = '%02d:%02d' % [m, s] #outputs minutes and seconds on label
	if time_in_seconds == 0:
		timer.stop()
		
		rounds += 1
		Global.current_round = rounds
		$rounds.text = "Rounds: " + str(rounds)
	
		if rounds > 8:
			Global.end_match()
		else: 
			get_tree().change_scene_to_file("res://round_complete.tscn")

#Player dodge and attack inputs - Stephen
func _input(event):
	if Global.battleStarted:
		if power_bar.value == 100 && Input.is_action_just_pressed("SuperMove") and canmove:
			match Global.Coach:
				"self":
					Global.bosses.health = Global.bosses.health * .90# also make a bone animation
					enemy_hp.value =float(Global.bosses.health)/float(Global.enemy_max)*100
				"angel":
					Global.playerStats.health = Global.playerStats.maxHealth# also make a bone animation
					hp_bar.value = (100)
				_:
					pass
			power_bar.value = (0)
		if Input.is_action_just_pressed("dodgeright") and canmove: 
			if Global.getPlayerStamina() > 0 and exhaustion == false:
				if canmove == true: # Conditional to check if the player is able to make a move.
					if isdodge == false: # Checks to see if you aren't in the middle of dodging.
						if isHolding == false:	# isHolding checks to see if the player is holding down one of the attack keys.
							isdodge = true
							animation.play("dodgeright")
							Global.playerStats.dodging = true	# This allows for the global script to know that the player is dodging.
							Global.depleteStamina("dodge", heldTime)
							pass
		if Input.is_action_just_pressed("dodgeleft") and canmove:
			if Global.getPlayerStamina() > 0 and exhaustion == false:
				if canmove == true: # Conditional to check if the player is able to make a move.
					if isdodge == false: # Checks to see if you aren't in the middle of dodging.
						if isHolding == false:	# isHolding checks to see if the player is holding down one of the attack keys.
							isdodge = true
							animation.play("dodgeleft")
							Global.playerStats.dodging = true	# This allows for the global script to know that the player is dodging.
							Global.depleteStamina("dodge", heldTime)
							pass

		if Input.is_action_pressed("attackLeft") and canmove:
			if Global.getPlayerStamina() > 0 and exhaustion == false:
				if isHolding == false:	#If Q is not being held down.
					pressTimes["leftAttack"] = Time.get_ticks_msec() / 1000.0	#Tracks the total time that the process has been running.
					isHolding = true
				heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["leftAttack"]	#Tracks the time that Q has been held by subtracting the present process time to the time that Q was first held down.
				if heldTime >= HOLD_TIME_THRESHOLD and isHolding == true:	#If Q has been held longer than the HOLD_TIME_THRESHOLD... 
					start_shake()	#Run the shaking function.
					heldTime = 0	#Set heldTime back to 0. 
		if Input.is_action_just_released("attackLeft") and canmove:
			if Global.getPlayerStamina() > 0 and exhaustion == false:
				if isdodge == false:
					heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["leftAttack"]
					if heldTime < HOLD_TIME_THRESHOLD and isHolding == true:	#If the hold time is less than the HOLD_TIME_THRESHOLD 
						jab_animation() #Simply punch
						Global.depleteStamina("attack", heldTime)
					else:
						leftHook()
						Global.depleteStamina("hook", heldTime)
					heldTime = 0		#Reset holdTime
					isHolding = false
					if character.position != originalPos:	#If the character position is not at it's original...
						character.position = originalPos	#Reset the position after shaking.
						leftHook()
		if Input.is_action_pressed("attackRight") and canmove:
			if Global.getPlayerStamina() > 0 and exhaustion == false:
				if isHolding == false:	#If E is not being held down.
					pressTimes["rightAttack"] = Time.get_ticks_msec() / 1000.0		#Tracks the total time that the process has been running.
					isHolding = true
				heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["rightAttack"]	#Tracks the time that Q has been held by subtracting the present process time to the time that E was first held down.
				if heldTime >= HOLD_TIME_THRESHOLD and isHolding == true:	#If E has been held longer than the HOLD_TIME_THRESHOLD...
					start_shake()	#Run the shaking function.s
					heldTime = 0	#Set heldTime back to 0.
		if Input.is_action_just_released("attackRight") and canmove:
			if Global.getPlayerStamina() > 0 and exhaustion == false:
				if isdodge == false:
					heldTime = (Time.get_ticks_msec()/1000.0) - pressTimes["rightAttack"]
					if heldTime < HOLD_TIME_THRESHOLD and isHolding == true:	#If the hold time is less than the HOLD_TIME_THRESHOLD
						cross_animation()	#Simply punch
						print("cross")
						Global.depleteStamina("attack", heldTime)
					else:
						rightHook()
						Global.depleteStamina("hook", heldTime)
					heldTime = 0	#Resets holdTime
					isHolding = false
					if character.position != originalPos:	#If the character position is not at it's original...
						character.position = originalPos	#Reset the position after shaking.
						rightHook()

func _on_animation_animation_finished(anim_name):
	if anim_name == "dodgeleft" or anim_name == "dodgeright":
		canmove = true
		isdodge = false
		isHolding = false
		Global.playerStats.dodging = false

#shake hook animation - Stephen
func start_shake():
	#This line changes the character position from it's original to a random Vector2 depending on the shake strength. Since the function repeatedly runs
	#while either Q or E is held down, it looks like the character is shaking, but in reality the character is shifting positions quickly.
	character.position = originalPos + Vector2(randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH), randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH))
	
	await get_tree().process_frame	#Waits for the next frame.

	if isHolding:	#If the player is still holding down a key, repeat the function.
		start_shake()

"""
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
					#print ("Health:", health)  # This prints out your current health.
			2:#Exact same with the rest.
				if chance <= probablityJab:
					health -= jab
					#print ("Health:", health)
			3:
				if chance <= probablityCross:
					health -= cross
					#print ("Health:", health)
			4:
				if chance <= probablityHook:
					health -= hook
					#print ("Health:")
		hp_bar.value = (health/100)
		#print("apple sauce")
"""

func _on_mc_animated_animation_looped():
	character.stop()
	character.play("Idle")


#func _on_animation_player_animation_finished(anim_name):
	#timer.start(-1) 
