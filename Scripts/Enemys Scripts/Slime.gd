func Actions(enemy_node):

	var action = randi_range(1, 3)
	print(enemy_node.health, enemy_node.stamina, enemy_node.power)
	match action:
		1:
			enemy_node.animation_player.play("Temp Dodge")# change the animation player to also change their hittability
			Global.bosses.dodge = true
		2:
			enemy_node.animation_player.play("TempSmack")
			if Global.playerStats.dodging == false:
				Global.depleteHealth()
			print(Global.getPlayerHealth())
		3:
			enemy_node.animation_player.play("Tempblock")
