func Actions(enemy_node):
	var action = randi_range(1, 3)# change this back to 1, 3 
	match action:
		1:
			enemy_node.animation_player.play("Dodge")# change the animation player to also change their hittability
			Global.bosses.dodge = true
		2:
			enemy_node.animation_player.play("Smack")
			if Global.playerStats.dodging == false:
				Global.depleteHealth()
		3:
			enemy_node.animation_player.play("Block")
# in this code we need to change it so that after the animation playes the animation player changes the 
# a variable in the combat scene that will disctate what damage in the switch statment it does
