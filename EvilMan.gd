func Actions(boss_node):
	var action = randi_range(1, 4)
	match action:# these play anmations but we dont gottem yet
		1:
			boss_node.animation_player.play("Evilbwah")
			if Global.playerStats.dodging == false:
				Global.depleteHealth()
				Global.depleteHealth()
			pass
		2:
			boss_node.animation_player.play("Evilblock")
			pass
		3:
			boss_node.animation_player.play("Evilpunch")
			pass
			if Global.playerStats.dodging == false:
				Global.depleteHealth()
		4:
			boss_node.animation_player.play("Evilbonk")
			if Global.playerStats.dodging == false:
				Global.depleteHealth()
			pass
