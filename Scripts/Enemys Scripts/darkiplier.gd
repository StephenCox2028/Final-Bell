func Actions(enemy_node):

	var action = randi_range(1, 3)
	print(enemy_node.health, enemy_node.stamina, enemy_node.power)
	match action:
		1:
			enemy_node.animation_player.play("blackdodge")# change the animation player to also change their hittability
			Global.bosses.dodge = true
		2:
			enemy_node.animation_player.play("blacksmack")
			if Global.playerStats.dodging == false:
				Global.depleteHealth()
		3:
			enemy_node.animation_player.play("blackblock")
