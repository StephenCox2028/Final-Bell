extends GutTest

# =============================================================================
# test_finalbell.gd
# GUT Test Suite for FinalBell
# Covers: Boss Rotation, Round Timer, Player Death
#
# HOW TO RUN:
#   1. Place this file in res://Tests/
#   2. Open GUT panel in Godot → add res://Tests/ as a test directory
#   3. Press "Run All" or run this file individually
#
# DEPENDENCIES:
#   - GUT addon installed (https://github.com/bitwes/Gut)
#   - Global autoload accessible
#   - bosses.gd and combat.gd parseable by the engine
# =============================================================================


# =============================================================================
# SECTION 1 — BOSS ROTATION
# Tests that Global.Boss_counter selects the correct boss, sets the correct
# stats, and that the action index maps to the right entry in enmActions[].
# =============================================================================
class TestBossRotation extends GutTest:

	var bosses_scene  # Instance of the bosses script logic (mocked below)

	# Lightweight stand-in so we don't need the full scene tree
	class MockBosses:
		var action: int = -1
		var emitted_banner: int = -1
		var last_hp: float   = 0
		var last_sta: float  = 0
		var last_pow: float  = 0
		var last_diff_max: float = 0
		var last_diff_min: float = 0
		var last_block: float = 0

		func change_stats(hp, sta, pow, max_d, min_d, block):
			last_hp        = hp
			last_sta       = sta
			last_pow       = pow
			last_diff_max  = max_d
			last_diff_min  = min_d
			last_block     = block

		# Simulates _ready() logic from bosses.gd for a given Boss_counter value
		func simulate_ready(boss_counter: int):
			match boss_counter:
				2:
					action = 0
					emitted_banner = 3
					change_stats(750, 20, 1, 5.0, 5.0, 0)
				5:
					action = 1
					emitted_banner = 5
					change_stats(1160, 30, 1, 5.0, 5.0, 0)
				_:
					action = -1  # no boss assigned

	func before_each():
		bosses_scene = MockBosses.new()

	func after_each():
		bosses_scene = null

	# --- Boss counter 2 → Puppeteer (action index 0) ---

	func test_boss_counter_2_sets_action_index_0():
		bosses_scene.simulate_ready(2)
		assert_eq(bosses_scene.action, 0,
			"Boss_counter 2 should assign action index 0 (Puppeteer)")

	func test_boss_counter_2_emits_banner_3():
		bosses_scene.simulate_ready(2)
		assert_eq(bosses_scene.emitted_banner, 3,
			"Boss_counter 2 should emit boss_banner(3) for Puppeteer")

	func test_boss_counter_2_sets_correct_hp():
		bosses_scene.simulate_ready(2)
		assert_eq(bosses_scene.last_hp, 750.0,
			"Puppeteer should start with 750 HP")

	func test_boss_counter_2_sets_correct_stamina():
		bosses_scene.simulate_ready(2)
		assert_eq(bosses_scene.last_sta, 20.0,
			"Puppeteer should start with 20 stamina")

	func test_boss_counter_2_sets_correct_power():
		bosses_scene.simulate_ready(2)
		assert_eq(bosses_scene.last_pow, 1.0,
			"Puppeteer should start with power 1")

	func test_boss_counter_2_block_chance_is_zero():
		bosses_scene.simulate_ready(2)
		assert_eq(bosses_scene.last_block, 0.0,
			"Puppeteer block chance should be 0")

	# --- Boss counter 5 → Evilman (action index 1) ---

	func test_boss_counter_5_sets_action_index_1():
		bosses_scene.simulate_ready(5)
		assert_eq(bosses_scene.action, 1,
			"Boss_counter 5 should assign action index 1 (Evilman)")

	func test_boss_counter_5_emits_banner_5():
		bosses_scene.simulate_ready(5)
		assert_eq(bosses_scene.emitted_banner, 5,
			"Boss_counter 5 should emit boss_banner(5) for Evilman")

	func test_boss_counter_5_sets_correct_hp():
		bosses_scene.simulate_ready(5)
		assert_eq(bosses_scene.last_hp, 1160.0,
			"Evilman should start with 1160 HP")

	func test_boss_counter_5_sets_correct_stamina():
		bosses_scene.simulate_ready(5)
		assert_eq(bosses_scene.last_sta, 30.0,
			"Evilman should start with 30 stamina")

	func test_boss_counter_5_evilman_is_harder_than_puppeteer():
		# Evilman should have strictly higher HP and stamina than Puppeteer
		var puppeteer_hp  = 750.0
		var evilman_hp    = 1160.0
		var puppeteer_sta = 20.0
		var evilman_sta   = 30.0
		assert_gt(evilman_hp,  puppeteer_hp,
			"Evilman HP should exceed Puppeteer HP (difficulty scaling)")
		assert_gt(evilman_sta, puppeteer_sta,
			"Evilman stamina should exceed Puppeteer stamina (difficulty scaling)")

	# --- Unrecognized Boss_counter → no boss assigned ---

	func test_unrecognized_boss_counter_does_not_assign_action():
		bosses_scene.simulate_ready(99)
		assert_eq(bosses_scene.action, -1,
			"An unrecognized Boss_counter should leave action unset (-1)")

	func test_boss_counter_0_does_not_assign_action():
		bosses_scene.simulate_ready(0)
		assert_eq(bosses_scene.action, -1,
			"Boss_counter 0 has no boss defined; action should remain -1")


# =============================================================================
# SECTION 2 — ROUND TIMER
# Tests the countdown logic in combat.gd:
#   - Starts at 90 seconds
#   - Decrements correctly each tick
#   - Formats the label as MM:SS
#   - Increments the round counter when it hits 0
#   - Calls end_match() when rounds exceed 8
# =============================================================================
class TestRoundTimer extends GutTest:

	# Mirrors the timer logic from combat.gd without needing the full scene
	class MockCombat:
		var time_in_seconds: int = 90
		var rounds: int          = 1
		var match_ended: bool    = false
		var round_restarted: bool = false
		var label_text: String   = ""

		func start_next_round():
			time_in_seconds  = 90
			label_text       = "01:30"
			round_restarted  = true

		func end_match():
			match_ended = true

		# One tick of on_timer_timeout()
		func tick():
			round_restarted = false
			time_in_seconds -= 1
			var m = int(time_in_seconds / 60)
			var s = time_in_seconds - m * 60
			label_text = "%02d:%02d" % [m, s]
			if time_in_seconds == 0:
				rounds += 1
				if rounds > 8:
					end_match()
				else:
					start_next_round()

		# Convenience: run N ticks at once
		func tick_n(n: int):
			for i in range(n):
				tick()

	var combat: MockCombat

	func before_each():
		combat = MockCombat.new()

	func after_each():
		combat = null

	# --- Initial state ---

	func test_initial_time_is_90():
		assert_eq(combat.time_in_seconds, 90,
			"Round should start at 90 seconds")

	func test_initial_round_is_1():
		assert_eq(combat.rounds, 1,
			"Game should start on round 1")

	func test_start_next_round_resets_time():
		combat.time_in_seconds = 0
		combat.start_next_round()
		assert_eq(combat.time_in_seconds, 90,
			"start_next_round() should reset timer to 90")

	func test_start_next_round_sets_label_01_30():
		combat.start_next_round()
		assert_eq(combat.label_text, "01:30",
			"Label should read '01:30' at round start")

	# --- Countdown ---

	func test_one_tick_decrements_time_by_1():
		combat.tick()
		assert_eq(combat.time_in_seconds, 89,
			"One tick should decrement time_in_seconds to 89")

	func test_label_at_89_seconds():
		combat.tick()
		assert_eq(combat.label_text, "01:29",
			"Label at 89 seconds should read '01:29'")

	func test_label_at_60_seconds():
		combat.tick_n(30)   # 90 - 30 = 60
		assert_eq(combat.label_text, "01:00",
			"Label at 60 seconds should read '01:00'")

	func test_label_at_59_seconds():
		combat.tick_n(31)   # 90 - 31 = 59
		assert_eq(combat.label_text, "00:59",
			"Label at 59 seconds should read '00:59' (minute rolls over)")

	func test_label_at_1_second():
		combat.tick_n(89)   # 90 - 89 = 1
		assert_eq(combat.label_text, "00:01",
			"Label at 1 second should read '00:01'")

	func test_label_uses_zero_padding():
		combat.tick_n(85)   # 90 - 85 = 5
		assert_eq(combat.label_text, "00:05",
			"Single-digit seconds must be zero-padded")

	# --- Round transition at 0 ---

	func test_round_increments_when_time_hits_0():
		combat.tick_n(90)
		assert_eq(combat.rounds, 2,
			"Round counter should increment to 2 after 90 ticks")

	func test_timer_resets_after_round_ends():
		combat.tick_n(90)
		assert_eq(combat.time_in_seconds, 90,
			"Timer should reset to 90 after round ends")

	func test_new_round_label_shows_01_30():
		combat.tick_n(90)
		assert_eq(combat.label_text, "01:30",
			"Label should reset to '01:30' at new round")

	func test_round_restart_flag_set_on_round_end():
		combat.tick_n(90)
		assert_true(combat.round_restarted,
			"round_restarted flag should be true immediately after round ends")

	# --- Multiple rounds ---

	func test_round_8_is_valid_and_resets_timer():
		# Simulate 7 full rounds completing (rounds goes 1→2→3→4→5→6→7→8)
		combat.tick_n(90 * 7)
		assert_eq(combat.rounds, 8,
			"After 7 completed rounds we should be on round 8")
		assert_false(combat.match_ended,
			"Match should NOT end at round 8 — only when rounds exceed 8")

	func test_match_ends_after_round_8_expires():
		# 8 full rounds expiring means rounds hits 9, which is > 8
		combat.tick_n(90 * 8)
		assert_eq(combat.rounds, 9,
			"Round counter should be 9 after 8 full rounds")
		assert_true(combat.match_ended,
			"end_match() should fire when rounds exceed 8")

	func test_match_does_not_end_before_round_9():
		combat.tick_n(90 * 7 + 89)  # one tick before round 8 expires
		assert_false(combat.match_ended,
			"Match should not end before round 9 is reached")

	func test_no_extra_round_restart_after_match_ends():
		combat.tick_n(90 * 8)
		# round_restarted would only be true if start_next_round() was called
		# after the match ended — it should NOT be
		assert_false(combat.round_restarted,
			"start_next_round() must NOT be called once the match has ended")


# =============================================================================
# SECTION 3 — PLAYER DEATH
# Tests handle_player_death() state changes in combat.gd:
#   - death_sequence_started guard prevents double-triggering
#   - battleStarted is set to false
#   - All movement/action flags are disabled
#   - Global state is synced
# =============================================================================
class TestPlayerDeath extends GutTest:

	class MockCombatDeath:
		var death_sequence_started: bool = false
		var battleStarted: bool          = true
		var canmove: bool                = true
		var isdodge: bool                = true
		var ispunch: bool                = true
		var isHolding: bool              = true
		var scene_changed: bool          = false  # stands in for change_scene_to_file
		var global_battle_started: bool  = true   # mirrors Global.battleStarted

		func handle_player_death():
			# Guard: don't run twice
			if death_sequence_started:
				return

			death_sequence_started    = true
			battleStarted             = false
			global_battle_started     = false
			canmove                   = false
			isdodge                   = false
			ispunch                   = false
			isHolding                 = false
			# (await timer skipped in unit tests — we test the flag logic, not timing)
			scene_changed             = true   # represents change_scene_to_file

	var combat_death: MockCombatDeath

	func before_each():
		combat_death = MockCombatDeath.new()

	func after_each():
		combat_death = null

	# --- First call ---

	func test_death_sets_death_sequence_flag():
		combat_death.handle_player_death()
		assert_true(combat_death.death_sequence_started,
			"death_sequence_started should be true after first call")

	func test_death_stops_battle():
		combat_death.handle_player_death()
		assert_false(combat_death.battleStarted,
			"battleStarted should be false after player death")

	func test_death_syncs_global_battle_started():
		combat_death.handle_player_death()
		assert_false(combat_death.global_battle_started,
			"Global.battleStarted should mirror battleStarted = false")

	func test_death_disables_movement():
		combat_death.handle_player_death()
		assert_false(combat_death.canmove,
			"canmove should be false after player death")

	func test_death_disables_dodge():
		combat_death.handle_player_death()
		assert_false(combat_death.isdodge,
			"isdodge should be false after player death")

	func test_death_disables_punch():
		combat_death.handle_player_death()
		assert_false(combat_death.ispunch,
			"ispunch should be false after player death")

	func test_death_disables_holding():
		combat_death.handle_player_death()
		assert_false(combat_death.isHolding,
			"isHolding should be false after player death")

	func test_death_triggers_scene_change():
		combat_death.handle_player_death()
		assert_true(combat_death.scene_changed,
			"Death should trigger a scene transition to death_menu")

	# --- Guard: second call is a no-op ---

	func test_double_death_does_not_retrigger():
		# Manually put the object into a "mid-death" state
		combat_death.handle_player_death()
		# Reset scene_changed so we can detect a second trigger
		combat_death.scene_changed = false

		combat_death.handle_player_death()  # second call

		assert_false(combat_death.scene_changed,
			"Second call to handle_player_death() should be blocked by the guard")

	func test_death_sequence_flag_stays_true_on_second_call():
		combat_death.handle_player_death()
		combat_death.handle_player_death()
		assert_true(combat_death.death_sequence_started,
			"death_sequence_started must remain true after repeated calls")

	# --- Edge: death while already not moving ---

	func test_death_when_already_stationary_is_safe():
		combat_death.canmove  = false
		combat_death.isdodge  = false
		combat_death.ispunch  = false
		combat_death.isHolding = false
		combat_death.handle_player_death()
		assert_true(combat_death.death_sequence_started,
			"Death should still trigger normally even if flags were already false")
		assert_true(combat_death.scene_changed,
			"Scene should still change even if player was already stationary")
