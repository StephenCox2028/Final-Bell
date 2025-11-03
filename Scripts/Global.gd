extends Node
var Score = 0
var Boss_counter = 0 # make this increase when leaving the locker room
var boss_flip = false # make sure its off
var currentBoss = null
var Enemy_tally = 0
var MAXHEALTH = 40
var MAXSTAMINA = 10
var MAXPOWER = 10

var combat_ui
#Player stats - Mirza
var playerStats = {
	"health" : 40,
	"stamina" : 10,
	"power" : 10,
	"dodging": false
}
var bosses = {
	"health" : 1,
	"stamina" : 1,
	"power" : 1,
	"dodge": false,
	"block" : false
}

#boss stats - Mirza

#Global functions - Stephen
func depleteHealth() -> void:
	playerStats.health -= bosses.power
	if combat_ui:
		combat_ui.progress_bar.value = (float(playerStats.health)/ float(MAXHEALTH))*100.0

	win_conditions()
func depleteStamina(move, multiplier) -> void:
	if move == "attack":
		playerStats.stamina -= 2
		if bosses.dodge != true and bosses.block != true:
			bosses.health -= playerStats.power
		win_conditions()
	elif move == "hook":
		playerStats.stamina -= multiplier * 2
		if bosses.dodge != true and bosses.block != true:
			bosses.health -= (playerStats.power + multiplier)
		print(bosses.health)
		win_conditions()
	elif move == "dodge":
		playerStats.stamina -= 1
	combat_ui.progress_bar_2.value = (float(playerStats.stamina)/float(MAXSTAMINA))*100
func getPlayerHealth():
	return playerStats.health
func getPlayerStamina():
	return playerStats.stamina
func getPlayerPopwer():
	return playerStats.power
#when player health reaches 0 change to a new scene - Mirza
func win_conditions() -> void:
	if(playerStats.health <= 0):
		get_tree().change_scene_to_file("res://Scenes/death_menu.tscn")

	elif(bosses.health <= 0):
		get_tree().change_scene_to_file("res://Scenes/locker_room.tscn")
