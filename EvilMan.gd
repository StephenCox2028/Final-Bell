func Actions(boss_node):
	var action = randi_range(1, 7)
	match action:# these play anmations but we dont gottem yet
		1:
			boss_node.animation_player.play("Evilbwah")
			if Global.playerStats.dodging == false:
				Global.depleteHealth()
				Global.depleteHealth()
		2:
			boss_node.get_node("AnimatedSprite2D").play("EvilBlock")
		3:
			boss_node.get_node("AnimatedSprite2D").play("EvileIdle")
		4:
			boss_node.animation_player.play("Evilbonk")
			if Global.playerStats.dodging == false:
				Global.depleteHealth()
				Global.depleteHealth()
		5:
			boss_node.get_node("AnimatedSprite2D").play("EvilCross")
			if Global.playerStats.dodging == false:
				Global.depleteHealth()
		6:
			boss_node.get_node("AnimatedSprite2D").play("EvilJab")
			if Global.playerStats.dodging == false:
				Global.depleteHealth()
		7:
			boss_node.get_node("AnimatedSprite2D").play("EvilHook")
			if Global.playerStats.dodging == false:
				Global.depleteHealth()
