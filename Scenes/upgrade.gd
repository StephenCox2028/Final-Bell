extends TextureRect

"""
Onready allows the objects to be created before the scene runs. It is similar to the _ready function.
These objects select the labels and buttons that the user will press.
"""
@onready var healthButton = $Health/HealthButton
@onready var healthCostLabel = $Health/HealthCost
@onready var staminaButton = $Stamina/StaminaButton
@onready var staminaCostLabel = $Stamina/StaminaCost
@onready var powerButton = $Power/PowerButton
@onready var powerCostLabel = $Power/PowerCost
@onready var currentHealthLabel = $Health/CurrentHealth
@onready var currentStaminaLabel = $Stamina/CurrentStamina
@onready var currentPowerLabel = $Power/CurrentPower
@onready var TotalXP = $TotalXP
@onready var redHealth = $Health/RedHealth
@onready var redStamina = $Stamina/RedStamina
@onready var redPower = $Power/RedPower
@onready var animations = $AnimationPlayer
@onready var levelUp = $LevelUp
@onready var denied = $Denied
@onready var transition = $Transition/Transition

#Sets all labels to present stats.
func _ready():
	currentHealthLabel.text = "Current Health: " + str(Global.getPlayerHealth())
	currentStaminaLabel.text = "Current Stamina: " + str(Global.getPlayerStamina())
	currentPowerLabel.text = "Current Power: " + str(Global.getPlayerPower())
	healthCostLabel.text = "Total Cost: " + str(Global.getHealthCost()) + " XP"
	staminaCostLabel.text = "Total Cost: " + str(Global.getStaminaCost()) + " XP"
	powerCostLabel.text = "Total Cost: " + str(Global.getPowerCost()) + " XP"
	TotalXP.text = "Total XP: " + str(Global.getTotalXP()) + " XP"

#Whenever a value is upgraded, update the label to broadcast the new value.
func healthCostLabelUpdate() -> void:
	healthCostLabel.text = "Total Cost: " + str(Global.getHealthCost()) + " XP"
func staminaCostLabelUpdate() -> void:
	staminaCostLabel.text = "Total Cost: " + str(Global.getStaminaCost()) + " XP"
func powerCostLabelUpdate() -> void:
	powerCostLabel.text = "Total Cost: " + str(Global.getPowerCost()) + " XP"
func totalXPLabelUpdate() -> void:
	TotalXP.text = "Total XP: " + str(Global.getTotalXP()) + " XP"
func healthLabelUpdate() -> void:
	currentHealthLabel.text = "Current Health: " + str(Global.getPlayerHealth())
func staminaLabelUpdate() -> void:
	currentStaminaLabel.text = "Current Stamina: " + str(Global.getPlayerStamina())
func powerLabelUpdate() -> void:
	currentPowerLabel.text = "Current Power: " + str(Global.getPlayerPower())

#Signal that makes sure that no other animations are playing if one already is.
func _on_animation_player_animation_started(anim_name):
	if anim_name == "redHealth":
		redStamina.visible = false
		redPower.visible = false
	if anim_name == "redStamina":
		redHealth.visible = false
		redPower.visible = false
	if anim_name == "redPower":
		redHealth.visible = false
		redStamina.visible = false

#Signals run multiple functions that change global stats and update labels
func _on_health_button_pressed():
	if Global.getTotalXP() >= Global.getHealthCost():
		levelUp.play()
		animations.play("levelUp")
		Global.healthCostUp()
		Global.setMaxPlayerHealth(1)
		Global.resetAllPlayerStats()
		healthCostLabelUpdate()
		totalXPLabelUpdate()
		healthLabelUpdate()
	else:
		#Play red blinking animation to symbolize not enough XP.
		denied.play()
		animations.play("redHealth")

func _on_stamina_button_pressed():
	if Global.getTotalXP() >= Global.getStaminaCost():
		levelUp.play()
		animations.play("levelUp")
		Global.staminaCostUp()
		Global.setMaxPlayerStamina(1)
		Global.resetAllPlayerStats()
		staminaCostLabelUpdate()
		totalXPLabelUpdate()
		staminaLabelUpdate()
	else:
		#Play red blinking animation to symbolize not enough XP.
		denied.play()
		animations.play("redStamina")

func _on_power_button_pressed():
	if Global.getTotalXP() >= Global.getPowerCost():
		levelUp.play()
		animations.play("levelUp")
		Global.powerCostUp()
		Global.setMaxPlayerPower(1)
		Global.resetAllPlayerStats()
		powerCostLabelUpdate()
		totalXPLabelUpdate()
		powerLabelUpdate()
	else:
		#Play red blinking animation to symbolize not enough XP.
		denied.play()
		animations.play("redPower")

#If the back button is pressed, go back to the locker room.
func _on_back_button_pressed():
	transition.play("fade-out")

func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/locker_room.tscn")
