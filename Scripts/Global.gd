extends Node

var currentBoss = null

#Player stats - Mirza
var playerStats = {
	"health" : 40,
	"stamina" : 10,
	"power" : 10,
	"dodging": false
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
		#win_conditions()
	elif move == "hook":
		playerStats.stamina -= multiplier * 2
		if bosses[currentBoss].dodge != true and bosses[currentBoss].block != true:
			bosses[currentBoss].health -= (playerStats.power + multiplier)
		print(bosses[currentBoss].health)
		#win_conditions()
	elif move == "dodge":
		playerStats.stamina -= 1
func getPlayerHealth():
	return playerStats.health
func getPlayerStamina():
	return playerStats.stamina
func getPlayerPopwer():
	return playerStats.power
#when player health reaches 0 change to a new scene - Mirza
"""
func win_conditions() -> void:
	if(playerStats.health <= 0):
		get_tree().change_scene_to_file("res://Scenes/death_menu.tscn")
	else:
		"""
		to change scene to locker room
		get._tree().change_scene_to_file()
		"""
	if(bosses[currentBoss].health <= 0):
		get_tree().change_scene_to_file("res://Scenes/victory_menu.tscn")
