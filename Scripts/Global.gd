extends Node

var Score = 0
var Boss_counter = 0 # make this increase when leaving the locker room
var boss_flip = false # make sure its off
var currentBoss = null
var Enemy_tally = 0

#Variables for scoring
var rng = RandomNumberGenerator.new()
var num_punches = 0
var punches_landed = 0
var accuracy = 0
var power_punches = 0
var knockdowns = 0

#Player stats - Mirza
var playerStats = {
	"health" : 40,
	"stamina" : 10,
	"power" : 10,
	"dodging": false
}

#boss stats - Mirza
var bosses = { 
	"Hit-Man Skeleton": {"health" : 40, "stamina" : 30, "power" : 5, "dodge" : false, "block" : false}, 
	"Devil": {"health" : 100, "stamina" : 50, "power" : 50, "dodge": false, "block" : false} 
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
			Global.punches_landed += 1
			print("Punch landed " + str(Global.punches_landed))
			if bosses[currentBoss].health >= bosses[currentBoss].health / 2:
				if rng.randi_range(1, 10) / 10 >= 0.6:
					knockdowns = rng.randi_range(1, 10)
		else:
			print("Block")
		#print(bosses[currentBoss].health)
		win_conditions()
	elif move == "hook":
		playerStats.stamina -= multiplier * 2
		if bosses[currentBoss].dodge != true and bosses[currentBoss].block != true:
			bosses[currentBoss].health -= (playerStats.power + multiplier)
			Global.punches_landed += 1
			print("Punch landed " + str(Global.punches_landed))
			if bosses[currentBoss].health >= bosses[currentBoss].health / 2:
				if rng.randi_range(1, 10) / 10 >= 0.6:
					knockdowns = rng.randi_range(1, 10)
				
		else:
			print("Block")
		#print(bosses[currentBoss].health)
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
	elif(bosses[currentBoss].health <= 0):
		get_tree().change_scene_to_file("res://Scenes/locker_room.tscn")
		
		
#Scoring - Mirza

func calculate_score(num_punches, punches_landed, accuracy, knockdown) -> int:
	accuracy = num_punches / punches_landed
	Score = (punches_landed / power_punches) * (accuracy * 10) * (knockdowns * 30)
	return Score
	
func end_match():
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
