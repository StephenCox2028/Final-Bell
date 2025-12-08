var phase_2_initialized = false  # Prevent repeated phase 2 setup


func Actions(boss_node):
	print(Global.bosses.health, Global.bosses.stamina, Global.bosses.power)
	var combat_scene = boss_node.get_parent()
	var clock_timer = combat_scene.get_node("Timer")
	var action
	var half_hp = Global.enemy_max / 2
	
	# Check for phase transition
	if Global.bosses.phase == 1 and Global.bosses.health <= half_hp:
		if not phase_2_initialized:
			transition_to_phase_2(boss_node, clock_timer)
		return  # Exit early during transition
	
	# Phase 1 actions
	if Global.bosses.phase == 1:
		action = randi_range(1, 6)
		match action:
			1:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer1Idle")
			2:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer1left_punch")
			3:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer1Block")
			4:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer1right_punch")
			5:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer1left_hook")
			6:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer1right_hook")
	
	# Phase 2 actions
	elif Global.bosses.phase == 2:
		action = randi_range(1, 4)
		match action:
			1:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer2Idle")
			2:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer2Jab")
			3:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer2Block")
			4:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer2Cross")

func transition_to_phase_2(boss_node, clock_timer):
	if phase_2_initialized:
		return  # Already transitioned
	
	var sprite = boss_node.get_node("AnimatedSprite2D")
	
	Global.bosses.phase = 2
	Global.bosses.power *= 1.5
	clock_timer.stop()
	
	# Add debug prints
	print("Starting phase 2 transition")
	print("Available animations: ", sprite.sprite_frames.get_animation_names())
	
	sprite.play("Puppeteer2ThrowP1")
	print("Playing ThrowP1")
	await sprite.animation_finished
	
	sprite.play("Puppeteer2ThrowP2")
	print("Playing ThrowP2")
	await sprite.animation_finished
	
	sprite.play("Puppeteer2Walk-In")
	print("Playing Walk-In")
	await sprite.animation_finished
	
	print("Phase 2 transition complete")
	clock_timer.start()
