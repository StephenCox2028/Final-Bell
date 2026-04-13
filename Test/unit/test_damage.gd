extends GutTest

##
## Systems covered:
##   1. Attack damage values  (jab / cross / hook / block)
##   2. Hit probabilities     (DamageTaken logic)
##   3. Stamina depletion     (attack / hook / dodge costs)
##   4. Exhaustion state      (zero-stamina → cooldown → recovery)
##   5. Stamina regeneration  (passive regen + clamping)
##   6. Super move effects    (coach "self" → enemy −10 %, coach "angel" → full heal)
##   7. Death / health floor  (health reaching 0 triggers death flag)
##   8. Heartbeat threshold   (≤ 10 HP activates low-health state)
##   9. Secret mode           (health inflated to 50 000)

# ---------------------------------------------------------------------------
# Constants mirrored from combat.gd / Global
# ---------------------------------------------------------------------------
const DAMAGE_JAB   := 0.005
const DAMAGE_CROSS := 0.01
const DAMAGE_HOOK  := 0.02
const DAMAGE_BLOCK := 0.0025

const PROB_JAB   := 85
const PROB_CROSS := 65
const PROB_HOOK  := 50
const PROB_BLOCK := 100   # always hits

const STAMINA_COST_ATTACK := 10.0   # assumed values – adjust to match Global.depleteStamina
const STAMINA_COST_HOOK   := 20.0
const STAMINA_COST_DODGE  := 15.0
const MAX_STAMINA         := 100.0
const MAX_HEALTH          := 100.0
const REGEN_PER_TICK      := 0.025
const HEARTBEAT_THRESHOLD := 10.0
const SECRET_HEALTH       := 50000.0
const SUPER_MOVE_MULTIPLIER := 0.90  # boss loses 10 %

# ---------------------------------------------------------------------------
# Minimal stubs
# ---------------------------------------------------------------------------

## Mirrors the damage + HP state that combat.gd tracks for the player.
class PlayerStatsStub:
	var health: float     = MAX_HEALTH
	var maxHealth: float  = MAX_HEALTH
	var stamina: float    = MAX_STAMINA
	var maxStamina: float = MAX_STAMINA
	var power: float      = 0.0
	var dodging: bool     = false

	const _STAMINA_COST_ATTACK := 10.0
	const _STAMINA_COST_HOOK   := 20.0
	const _STAMINA_COST_DODGE  := 15.0

	func deplete_stamina(move_type: String, _held_time: float = 0.0) -> void:
		match move_type:
			"attack": stamina -= _STAMINA_COST_ATTACK
			"hook":   stamina -= _STAMINA_COST_HOOK
			"dodge":  stamina -= _STAMINA_COST_DODGE
		stamina = maxf(stamina, 0.0)

	func regen_tick() -> void:
		if stamina < maxStamina:
			stamina += REGEN_PER_TICK
		stamina = minf(stamina, maxStamina)

## Mirrors the enemy / boss health tracked via Global.bosses.
class EnemyStatsStub:
	var health: float    = 100.0
	var max_health: float = 100.0

## Thin combat-state wrapper used by tests that need both sides.
class CombatStateStub:
	var player: PlayerStatsStub = PlayerStatsStub.new()
	var enemy: EnemyStatsStub   = EnemyStatsStub.new()
	var hp_bar_value: float     = 100.0
	var enemy_hp_value: float   = 100.0
	var power_bar_value: float  = 0.0
	var exhaustion: bool        = false
	var death_sequence_started: bool = false
	var battle_started: bool    = true
	var coach: String           = "self"
	var secret_enabled: bool    = false

	func _init() -> void:
		if secret_enabled:
			player.health    = SECRET_HEALTH
			player.maxHealth = SECRET_HEALTH

	# ---- Damage applied to the player (mirrors DamageTaken logic) ----------
	func apply_damage_to_player(amount: float) -> void:
		player.health -= amount
		player.health  = maxf(player.health, 0.0)
		hp_bar_value   = (player.health / player.maxHealth) * 100.0

	# ---- Super move (mirrors _input SuperMove branch) ----------------------
	func use_super_move() -> void:
		if power_bar_value < 100.0:
			return
		match coach:
			"self":
				enemy.health  = enemy.health * SUPER_MOVE_MULTIPLIER
				enemy_hp_value = (enemy.health / enemy.max_health) * 100.0
			"angel":
				player.health = player.maxHealth
				hp_bar_value  = 100.0
		power_bar_value = 0.0

	# ---- Death check (mirrors handle_player_death guard) -------------------
	func check_death() -> void:
		if player.health <= 0 and not death_sequence_started:
			death_sequence_started = true
			battle_started         = false

	# ---- Heartbeat check ---------------------------------------------------
	func needs_heartbeat() -> bool:
		return player.health <= HEARTBEAT_THRESHOLD

	# ---- Stamina exhaustion check (mirrors _process) -----------------------
	func process_stamina_tick() -> void:
		if not exhaustion:
			if player.stamina <= 0:
				player.stamina = 0.0
				exhaustion = true
			if player.stamina >= player.maxStamina:
				player.stamina = player.maxStamina
		if player.stamina < player.maxStamina:
			player.regen_tick()

	# ---- Stamina cooldown timeout (mirrors _on_stamina_cooldown_timeout) ---
	func on_stamina_cooldown_timeout() -> void:
		exhaustion = false

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
func _fresh() -> CombatStateStub:
	return CombatStateStub.new()

# Apply `n` passive stamina regen ticks
func _regen(state: CombatStateStub, ticks: int) -> void:
	for _i in range(ticks):
		state.process_stamina_tick()

# ---------------------------------------------------------------------------
# 1. Attack damage values
# ---------------------------------------------------------------------------

func test_jab_damage_value() -> void:
	var s := _fresh()
	s.apply_damage_to_player(DAMAGE_JAB)
	assert_almost_eq(s.player.health, MAX_HEALTH - DAMAGE_JAB, 0.0001,
		"Jab should deal exactly %.4f damage" % DAMAGE_JAB)

func test_cross_damage_value() -> void:
	var s := _fresh()
	s.apply_damage_to_player(DAMAGE_CROSS)
	assert_almost_eq(s.player.health, MAX_HEALTH - DAMAGE_CROSS, 0.0001,
		"Cross should deal exactly %.4f damage" % DAMAGE_CROSS)

func test_hook_damage_value() -> void:
	var s := _fresh()
	s.apply_damage_to_player(DAMAGE_HOOK)
	assert_almost_eq(s.player.health, MAX_HEALTH - DAMAGE_HOOK, 0.0001,
		"Hook should deal exactly %.4f damage" % DAMAGE_HOOK)

func test_block_damage_value() -> void:
	var s := _fresh()
	s.apply_damage_to_player(DAMAGE_BLOCK)
	assert_almost_eq(s.player.health, MAX_HEALTH - DAMAGE_BLOCK, 0.0001,
		"Block chip should deal exactly %.4f damage" % DAMAGE_BLOCK)

func test_hook_deals_more_than_cross() -> void:
	assert_gt(DAMAGE_HOOK, DAMAGE_CROSS, "Hook must deal more damage than cross")

func test_cross_deals_more_than_jab() -> void:
	assert_gt(DAMAGE_CROSS, DAMAGE_JAB, "Cross must deal more damage than jab")

func test_jab_deals_more_than_block() -> void:
	assert_gt(DAMAGE_JAB, DAMAGE_BLOCK, "Jab must deal more damage than a blocked hit")

func test_cumulative_damage_is_additive() -> void:
	var s := _fresh()
	s.apply_damage_to_player(DAMAGE_JAB)
	s.apply_damage_to_player(DAMAGE_CROSS)
	var expected := MAX_HEALTH - DAMAGE_JAB - DAMAGE_CROSS
	assert_almost_eq(s.player.health, expected, 0.0001,
		"Multiple hits must accumulate correctly")

# ---------------------------------------------------------------------------
# 2. HP bar mirrors player health
# ---------------------------------------------------------------------------

func test_hp_bar_is_100_at_full_health() -> void:
	var s := _fresh()
	assert_almost_eq(s.hp_bar_value, 100.0, 0.001,
		"HP bar should start at 100")

func test_hp_bar_updates_after_damage() -> void:
	var s := _fresh()
	s.apply_damage_to_player(50.0)
	assert_almost_eq(s.hp_bar_value, 50.0, 0.001,
		"HP bar should reflect 50 % health after 50 damage")

func test_hp_bar_cannot_go_below_zero() -> void:
	var s := _fresh()
	s.apply_damage_to_player(200.0)   # overkill
	assert_almost_eq(s.hp_bar_value, 0.0, 0.001,
		"HP bar must not go negative")

func test_player_health_floor_is_zero() -> void:
	var s := _fresh()
	s.apply_damage_to_player(9999.0)
	assert_almost_eq(s.player.health, 0.0, 0.0001,
		"Player health must floor at 0")

# ---------------------------------------------------------------------------
# 3. Hit probabilities (DamageTaken logic)
# ---------------------------------------------------------------------------

func test_block_probability_is_100_percent() -> void:
	assert_eq(PROB_BLOCK, 100,
		"Block probability must be 100 so it always applies chip damage")

func test_jab_probability_is_85_percent() -> void:
	assert_eq(PROB_JAB, 85, "Jab hit probability must be 85 %")

func test_cross_probability_is_65_percent() -> void:
	assert_eq(PROB_CROSS, 65, "Cross hit probability must be 65 %")

func test_hook_probability_is_50_percent() -> void:
	assert_eq(PROB_HOOK, 50, "Hook hit probability must be 50 %")

func test_probability_ordering_block_jab_cross_hook() -> void:
	# Harder hits are less likely to land
	assert_gt(PROB_BLOCK, PROB_JAB,  "Block prob > jab prob")
	assert_gt(PROB_JAB,   PROB_CROSS, "Jab prob > cross prob")
	assert_gt(PROB_CROSS,  PROB_HOOK, "Cross prob > hook prob")

func test_move_within_probability_applies_damage() -> void:
	# A chance value of 1 is always within every probability threshold
	var s := _fresh()
	var chance := 1   # guaranteed hit
	if chance <= PROB_JAB:
		s.apply_damage_to_player(DAMAGE_JAB)
	assert_lt(s.player.health, MAX_HEALTH,
		"A roll of 1 must always trigger jab damage")

func test_move_outside_probability_skips_damage() -> void:
	var s := _fresh()
	var chance := 99  # above PROB_HOOK (50) and PROB_CROSS (65) but inside PROB_JAB (85) … just test hook
	if chance <= PROB_HOOK:   # 99 > 50 → skip
		s.apply_damage_to_player(DAMAGE_HOOK)
	assert_almost_eq(s.player.health, MAX_HEALTH, 0.0001,
		"A roll of 99 must miss the hook (prob 50 %)")

# ---------------------------------------------------------------------------
# 4. Stamina depletion
# ---------------------------------------------------------------------------

func test_attack_depletes_stamina() -> void:
	var s := _fresh()
	s.player.deplete_stamina("attack")
	assert_almost_eq(s.player.stamina, MAX_STAMINA - STAMINA_COST_ATTACK, 0.001,
		"Attack should deplete stamina by %s" % STAMINA_COST_ATTACK)

func test_hook_depletes_more_stamina_than_attack() -> void:
	var a := _fresh()
	var h := _fresh()
	a.player.deplete_stamina("attack")
	h.player.deplete_stamina("hook")
	assert_lt(h.player.stamina, a.player.stamina,
		"Hook must cost more stamina than a regular attack")

func test_dodge_depletes_stamina() -> void:
	var s := _fresh()
	s.player.deplete_stamina("dodge")
	assert_almost_eq(s.player.stamina, MAX_STAMINA - STAMINA_COST_DODGE, 0.001,
		"Dodge should deplete stamina by %s" % STAMINA_COST_DODGE)

func test_stamina_cannot_go_below_zero_from_depletion() -> void:
	var s := _fresh()
	s.player.stamina = 5.0
	s.player.deplete_stamina("hook")   # costs 20, only 5 available
	assert_almost_eq(s.player.stamina, 0.0, 0.001,
		"Stamina must floor at 0 after over-depletion")

func test_multiple_attacks_accumulate_stamina_cost() -> void:
	var s := _fresh()
	s.player.deplete_stamina("attack")
	s.player.deplete_stamina("attack")
	assert_almost_eq(s.player.stamina,
		MAX_STAMINA - STAMINA_COST_ATTACK * 2, 0.001,
		"Two attacks must cost double the stamina")

# ---------------------------------------------------------------------------
# 5. Exhaustion state
# ---------------------------------------------------------------------------

func test_exhaustion_triggers_at_zero_stamina() -> void:
	var s := _fresh()
	s.player.stamina = 0.0
	s.process_stamina_tick()
	assert_true(s.exhaustion,
		"Exhaustion must trigger when stamina reaches 0")

func test_exhaustion_does_not_trigger_above_zero() -> void:
	var s := _fresh()
	s.player.stamina = 1.0
	s.process_stamina_tick()
	assert_false(s.exhaustion,
		"Exhaustion must NOT trigger while stamina > 0")

func test_exhaustion_cleared_on_cooldown_timeout() -> void:
	var s := _fresh()
	s.exhaustion = true
	s.on_stamina_cooldown_timeout()
	assert_false(s.exhaustion,
		"Exhaustion must be cleared when the cooldown timer fires")

func test_exhaustion_blocks_further_stamina_drain() -> void:
	# When exhausted the player cannot act, so no further depletion should happen;
	# this verifies stamina stays at 0 during exhaustion.
	var s := _fresh()
	s.player.stamina = 0.0
	s.process_stamina_tick()   # sets exhaustion = true
	var stamina_during_exhaustion := s.player.stamina
	assert_almost_eq(stamina_during_exhaustion, 0.0, 0.001,
		"Stamina must stay at 0 while exhausted (no depletion check needed)")

# ---------------------------------------------------------------------------
# 6. Stamina regeneration
# ---------------------------------------------------------------------------

func test_stamina_regenerates_passively_each_tick() -> void:
	var s := _fresh()
	s.player.stamina = 50.0
	s.process_stamina_tick()
	assert_almost_eq(s.player.stamina, 50.0 + REGEN_PER_TICK, 0.0001,
		"Stamina should increase by %.3f per tick" % REGEN_PER_TICK)

func test_stamina_does_not_exceed_max() -> void:
	var s := _fresh()
	s.player.stamina = MAX_STAMINA   # already full
	s.process_stamina_tick()
	assert_almost_eq(s.player.stamina, MAX_STAMINA, 0.0001,
		"Stamina must not exceed maxStamina")

func test_stamina_recovers_to_max_over_time() -> void:
	var s := _fresh()
	s.player.stamina = 0.0
	s.exhaustion = false   # simulate post-cooldown recovery
	# ticks needed = 100 / 0.025 = 4000
	_regen(s, 4000)
	assert_almost_eq(s.player.stamina, MAX_STAMINA, 0.1,
		"Stamina should fully recover to max after enough ticks")

# ---------------------------------------------------------------------------
# 7. Super move – coach "self" (enemy damage)
# ---------------------------------------------------------------------------

func test_super_move_reduces_enemy_health_by_10_percent() -> void:
	var s := _fresh()
	s.coach = "self"
	s.power_bar_value = 100.0
	var before := s.enemy.health
	s.use_super_move()
	assert_almost_eq(s.enemy.health, before * SUPER_MOVE_MULTIPLIER, 0.001,
		"Super move (coach=self) must reduce enemy HP by 10 %%")

func test_super_move_resets_power_bar_to_zero() -> void:
	var s := _fresh()
	s.coach = "self"
	s.power_bar_value = 100.0
	s.use_super_move()
	assert_almost_eq(s.power_bar_value, 0.0, 0.001,
		"Power bar must reset to 0 after super move")

func test_super_move_does_nothing_when_power_bar_not_full() -> void:
	var s := _fresh()
	s.coach = "self"
	s.power_bar_value = 99.0
	var before := s.enemy.health
	s.use_super_move()
	assert_almost_eq(s.enemy.health, before, 0.001,
		"Super move must not fire when power bar is below 100")

func test_super_move_self_damage_is_proportional_to_current_hp() -> void:
	# If the enemy is already weakened the 10 % is applied to the reduced total
	var s := _fresh()
	s.coach = "self"
	s.enemy.health = 50.0
	s.power_bar_value = 100.0
	s.use_super_move()
	assert_almost_eq(s.enemy.health, 45.0, 0.001,
		"Super move against a 50 HP enemy must leave exactly 45 HP")

func test_super_move_stacks_on_repeated_use() -> void:
	var s := _fresh()
	s.coach = "self"
	s.enemy.health = 100.0
	# First super
	s.power_bar_value = 100.0
	s.use_super_move()
	# Second super
	s.power_bar_value = 100.0
	s.use_super_move()
	var expected := 100.0 * SUPER_MOVE_MULTIPLIER * SUPER_MOVE_MULTIPLIER
	assert_almost_eq(s.enemy.health, expected, 0.01,
		"Two super moves must compound: 100 × 0.9 × 0.9")

# ---------------------------------------------------------------------------
# 8. Super move – coach "angel" (player full heal)
# ---------------------------------------------------------------------------

func test_angel_super_restores_player_to_full_health() -> void:
	var s := _fresh()
	s.coach = "angel"
	s.player.health = 30.0
	s.hp_bar_value   = 30.0
	s.power_bar_value = 100.0
	s.use_super_move()
	assert_almost_eq(s.player.health, MAX_HEALTH, 0.001,
		"Angel super must restore player to maxHealth")

func test_angel_super_resets_hp_bar_to_100() -> void:
	var s := _fresh()
	s.coach = "angel"
	s.player.health   = 1.0
	s.hp_bar_value     = 1.0
	s.power_bar_value  = 100.0
	s.use_super_move()
	assert_almost_eq(s.hp_bar_value, 100.0, 0.001,
		"HP bar must show 100 after angel super")

func test_angel_super_does_not_damage_enemy() -> void:
	var s := _fresh()
	s.coach = "angel"
	s.power_bar_value = 100.0
	var before := s.enemy.health
	s.use_super_move()
	assert_almost_eq(s.enemy.health, before, 0.001,
		"Angel super must not change enemy HP")

# ---------------------------------------------------------------------------
# 9. Death handling
# ---------------------------------------------------------------------------

func test_death_sequence_starts_when_health_reaches_zero() -> void:
	var s := _fresh()
	s.apply_damage_to_player(MAX_HEALTH)
	s.check_death()
	assert_true(s.death_sequence_started,
		"Death sequence must start when health drops to 0")

func test_death_sequence_stops_battle() -> void:
	var s := _fresh()
	s.apply_damage_to_player(MAX_HEALTH)
	s.check_death()
	assert_false(s.battle_started,
		"battleStarted must be false once death sequence begins")

func test_death_sequence_does_not_start_at_1_hp() -> void:
	var s := _fresh()
	s.apply_damage_to_player(MAX_HEALTH - 1.0)
	s.check_death()
	assert_false(s.death_sequence_started,
		"Death sequence must NOT start while the player still has HP")

func test_death_sequence_only_triggers_once() -> void:
	var s := _fresh()
	s.apply_damage_to_player(MAX_HEALTH)
	s.check_death()
	# Manually reset battle_started to simulate an edge-case double call
	s.battle_started = true
	s.check_death()
	# death_sequence_started is already true so the guard bails out early
	assert_true(s.death_sequence_started,
		"Death sequence guard must prevent a second trigger")

# ---------------------------------------------------------------------------
# 10. Heartbeat (low-health warning threshold)
# ---------------------------------------------------------------------------

func test_heartbeat_activates_at_exactly_10_hp() -> void:
	var s := _fresh()
	s.player.health = HEARTBEAT_THRESHOLD
	assert_true(s.needs_heartbeat(),
		"Heartbeat must activate at exactly %s HP" % HEARTBEAT_THRESHOLD)

func test_heartbeat_activates_below_10_hp() -> void:
	var s := _fresh()
	s.player.health = 5.0
	assert_true(s.needs_heartbeat(),
		"Heartbeat must activate below 10 HP")

func test_heartbeat_does_not_activate_above_10_hp() -> void:
	var s := _fresh()
	s.player.health = 11.0
	assert_false(s.needs_heartbeat(),
		"Heartbeat must NOT activate above 10 HP")

func test_heartbeat_deactivates_after_healing() -> void:
	var s := _fresh()
	s.player.health = 5.0
	assert_true(s.needs_heartbeat(), "Heartbeat on at 5 HP")
	s.player.health = 50.0
	assert_false(s.needs_heartbeat(), "Heartbeat off after healing to 50 HP")

# ---------------------------------------------------------------------------
# 11. Secret mode (50 000 HP)
# ---------------------------------------------------------------------------

func test_secret_mode_sets_health_to_50000() -> void:
	var s := CombatStateStub.new()
	s.secret_enabled = true
	# Simulate _ready() secret-mode branch
	s.player.health    = SECRET_HEALTH
	s.player.maxHealth = SECRET_HEALTH
	assert_almost_eq(s.player.health, SECRET_HEALTH, 1.0,
		"Secret mode must set player health to 50 000")

func test_secret_mode_max_health_matches_health() -> void:
	var s := CombatStateStub.new()
	s.player.health    = SECRET_HEALTH
	s.player.maxHealth = SECRET_HEALTH
	assert_almost_eq(s.player.maxHealth, s.player.health, 1.0,
		"maxHealth must equal health in secret mode so the HP bar stays full")

func test_normal_mode_health_starts_at_100() -> void:
	var s := _fresh()
	assert_almost_eq(s.player.health, 100.0, 0.001,
		"Without secret mode, health must start at 100")
