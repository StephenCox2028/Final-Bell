func Actions(enemy_node):

	var action = randi_range(2, 2)
	match action:
		1:
			enemy_node.animation_player.play("Temp Dodge")# change the animation player to also change their hittability
			Global.bosses.dodge = true
		2:
			enemy_node.animation_player.play("TempSmack")
			if Global.playerStats.dodging == false:
				Global.depleteHealth()
				
		3:
			enemy_node.animation_player.play("Tempblock")
