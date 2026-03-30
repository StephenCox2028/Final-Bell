extends Node
var Score = 0
var Boss_counter = 0 # make this increase when leaving the locker room
var boss_flip = false # make sure its off
#var currentBoss = null
var current_round = 1
var Enemy_tally = 0
var MAXSTAMINA = 10
var MAXPOWER = 10

var enemy_max =1
@export var battleStarted: bool
var secretEnabled: bool = false

var levelCosts = {
	"healthCost" : 10,
	"staminaCost" : 10,
	"powerCost" : 15
}

var combat_ui
var Coach = "self"

#Player stats - Mirza
var playerStats = {
	"health" : 100,
	"stamina" : 10,
	"power" : 10,
	"maxHealth" : 200,
	"maxStamina" : 10,
	"maxPower" : 10,
	"dodging": false,
	"totalXP" : 0
}

var bosses = {
	"health" : 1,
	"stamina" : 1,
	"power" : 1,
	"dodge": false,
	"block" : false,
	"difficultyMax" : 5.0,
	"difficultyMin": 5.0,
	"block_chance" : 0,
	"phase": 1,
	"phase-change": false,
}

#boss stats - Mirza
#var bosses = { 
#	"HitManSkeleton": {"health" : 40, "power" : 5, "dodge" : false, "block" : false, "difficultyMax" : 5.0, "difficultyMin": 5.0}, #all stats are just placeholders for now
#	"Devil": {"health" : 100, "power" : 50, "dodge": false, "block" : false, "difficultyMax" : 3.5, "difficultyMin" : 1.5} #all stats are just placeholders for now
#}

#Global functions - Stephen
func depleteHealth() -> void:
	playerStats.health -= bosses.power
	print(playerStats.health)
	combat_ui.power_bar.value += 10
	if combat_ui:
		combat_ui.hp_bar.value = (float(playerStats.health)/ float(playerStats.maxHealth))*100.0
	win_conditions()
	
func depleteStamina(move, multiplier) -> void:
	if move == "attack":
		playerStats.stamina -= 3
		if bosses.dodge != true and bosses.block != true:
			if bosses.difficultyMax < 5.0:
				var chance = randi_range(1, 100)# HERE is the block---------------------------------------------------------
				if chance > Global.bosses.block_chance:
					bosses.health -= playerStats.power
					#DAMAGE
					combat_ui.power_bar.value += 10
					combat_ui.enemy_hp.value = float(bosses.health)/float(enemy_max)*100
					if (Coach == "vamp"):
						playerStats.health += playerStats.maxHealth*.01  #heal bar
						if (playerStats.health > playerStats.maxHealth):
							playerStats.health = playerStats.maxHealth
						combat_ui.hp_bar.value = (float(playerStats.health)/ float(playerStats.maxHealth))*100.0
				else:
					print("NO DAMAGE DONE!")
			else:
				bosses.health -= playerStats.power
				combat_ui.power_bar.value += 10
				combat_ui.enemy_hp.value =float(bosses.health)/float(enemy_max)*100
				if (Coach == "vamp"):
					playerStats.health += playerStats.maxHealth*.01  #heal bar
					if (playerStats.health > playerStats.maxHealth):
						playerStats.health = playerStats.maxHealth
					combat_ui.hp_bar.value = (float(playerStats.health)/ float(playerStats.maxHealth))*100.0
		print(bosses.health)
		win_conditions()
	elif move == "hook":
		playerStats.stamina -= multiplier * 2
		if bosses.dodge != true and bosses.block != true:
			if bosses.difficultyMax < 5.0:
				var chance = randi_range(1,100)# HERE is the block---------------------------------------------------------
				if chance > Global.bosses.block_chance:
					bosses.health -= (playerStats.power + multiplier)
					combat_ui.enemy_hp.value =float(bosses.health)/float(enemy_max)*100
					combat_ui.power_bar.value += 10
					if (Coach == "vamp"):
						playerStats.health += playerStats.maxHealth*.01  #heal bar
						if (playerStats.health > playerStats.maxHealth):
							playerStats.health = playerStats.maxHealth
						combat_ui.hp_bar.value = (float(playerStats.health)/ float(playerStats.maxHealth))*100.0
				else: 
					print("NO DAMAGE DONE!")
			else:
				bosses.health -= (playerStats.power + multiplier)
				combat_ui.enemy_hp.value =float(bosses.health)/float(enemy_max)*100
				combat_ui.power_bar.value += 10
				if (Coach == "vamp"):
					playerStats.health += playerStats.maxHealth*.01  #heal bar
					if (playerStats.health > playerStats.maxHealth):
						playerStats.health = playerStats.maxHealth
					combat_ui.hp_bar.value = (float(playerStats.health)/ float(playerStats.maxHealth))*100.0
		print(bosses.health)
		if bosses.dodge != true and bosses.block != true:
			bosses.health -= playerStats.power
			combat_ui.enemy_hp.value =float(bosses.health)/float(enemy_max)*100
		win_conditions()
	elif move == "dodge":
		playerStats.stamina -= 2
	combat_ui.stamina_bar.value = (float(playerStats.stamina)/float(MAXSTAMINA))*100
	
	

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
	playerStats.health = playerStats.maxHealth
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
func dead():
	playerStats.totalXP = 0
	playerStats.maxPower = 10
	playerStats.maxStamina = 10
	playerStats.maxHealth = 40
	levelCosts.healthCost = 10
	levelCosts.staminaCost = 10
	levelCosts.powerCost = 15
	resetAllPlayerStats()

#when player health reaches 0 change to a new scene - Mirza
func win_conditions() -> void:
	if(playerStats.health <= 0):
		get_tree().change_scene_to_file("res://Scenes/death_menu.tscn")
	elif(bosses.health <= 0):
		Global.bosses.is_dead = true
		Global.totalXP()
		Global.resetAllPlayerStats()
		if boss_flip == true:
			Boss_counter += 1
			boss_flip = false
		else:
			Boss_counter += 1
		print("Boss flip:" + str(Global.boss_flip))
		print("Boss Flip counter: " + str(Global.Boss_counter))
		get_tree().change_scene_to_file("res://Victory.tscn")
