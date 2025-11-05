extends Node

var Score = 0
var Boss_counter = 0 # make this increase when leaving the locker room
var boss_flip = false # make sure its off
var currentBoss = null
var Enemy_tally = 0

var levelCosts = {
	"healthCost" : 10,
	"staminaCost" : 10,
	"powerCost" : 15
}

#Player stats - Mirza
var playerStats = {
	"health" : 40,
	"stamina" : 10,
	"power" : 10,
	"maxHealth" : 40,
	"maxStamina" : 10,
	"maxPower" : 10,
	"dodging": false,
	"totalXP" : 0
}

#boss stats - Mirza
var bosses = { 
	"Hit-Man Skeleton": {"health" : 40, "stamina" : 30, "power" : 5, "dodge" : false, "block" : false}, #all stats are just placeholders for know
	"Devil": {"health" : 100, "stamina" : 50, "power" : 50, "dodge": false, "block" : false} #all stats are just placeholders for know
}

#Global functions - Stephen
func depleteHealth() -> void:
	playerStats.health -= bosses[currentBoss].power
	#win_conditions()
func depleteStamina(move, multiplier) -> void:
	if move == "attack":
		playerStats.stamina -= 2
		if bosses[currentBoss].dodge != true and bosses[currentBoss].block != true:
			bosses[currentBoss].health -= playerStats.power
		print(bosses[currentBoss].health)
		win_conditions()
	elif move == "hook":
		playerStats.stamina -= multiplier * 2
		if bosses[currentBoss].dodge != true and bosses[currentBoss].block != true:
			bosses[currentBoss].health -= (playerStats.power + multiplier)
		print(bosses[currentBoss].health)
		win_conditions()
	elif move == "dodge":
		playerStats.stamina -= 1
func getPlayerHealth():
	return playerStats.health
func getPlayerStamina():
	return playerStats.stamina
func getPlayerPower():
	return playerStats.power
func getMaxPlayerHealth():
	return playerStats.maxHealth
func getMaxPlayerStamina():
	return playerStats.maxStamina
func getMaxPlayerPower():
	return playerStats.maxPower
func getHealthCost():
	return levelCosts.healthCost
func getStaminaCost():
	return levelCosts.staminaCost
func getPowerCost():
	return levelCosts.powerCost
func getTotalXP():
	return playerStats.totalXP
func resetAllPlayerStats() -> void:
	playerStats.health = playerStats.maxHealth
	playerStats.stamina = playerStats.maxStamina
	playerStats.power = playerStats.maxPower
func setMaxPlayerHealth(new) -> void:
	playerStats.maxHealth += new
func setMaxPlayerStamina(new) -> void:
	playerStats.maxStamina += new
func setMaxPlayerPower(new) -> void:
	playerStats.maxPower += new
func healthCostUp() -> void:
	playerStats.totalXP -= levelCosts.healthCost
	levelCosts.healthCost += 10
func staminaCostUp() -> void:
	playerStats.totalXP -= levelCosts.staminaCost
	levelCosts.staminaCost += 10
func powerCostUp() -> void:
	playerStats.totalXP -= levelCosts.powerCost
	levelCosts.powerCost += 15
func totalXP():
	playerStats.totalXP += 50

#when player health reaches 0 change to a new scene - Mirza
func win_conditions() -> void:
	if(playerStats.health <= 0):
		get_tree().change_scene_to_file("res://Scenes/death_menu.tscn")
	elif(bosses[currentBoss].health <= 0):
		Global.totalXP()
		Global.resetAllPlayerStats()
		get_tree().change_scene_to_file("res://Scenes/locker_room.tscn")
		
	
