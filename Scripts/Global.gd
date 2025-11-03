extends Node

var Score = 0
var Boss_counter = 0 # make this increase when leaving the locker room
var boss_flip = false # make sure its off
var currentBoss = null
var Enemy_tally = 0

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
	print(playerStats.health)
	#win_conditions()
func depleteStamina(move, multiplier) -> void:
	if move == "attack":
		playerStats.stamina -= 2
		if bosses.dodge != true and bosses.block != true:
			bosses.health -= playerStats.power
		print(bosses.health)
		win_conditions()
	elif move == "hook":
		playerStats.stamina -= multiplier * 2
		if bosses.dodge != true and bosses.block != true:
			bosses.health -= (playerStats.power + multiplier)
		print(bosses.health)
		win_conditions()
	elif move == "dodge":
		playerStats.stamina -= 1
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
	else:
		"""
		to change scene to locker room
		get._tree().change_scene_to_file()
		"""
	if(bosses.health <= 0):
		get_tree().change_scene_to_file("res://Scenes/victory_menu.tscn")
