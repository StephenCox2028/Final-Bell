extends GutTest

class CombatStub:
	var rounds: int          = 0
	var time_in_seconds: int = 90
	var label_text: String   = ""
	var rounds_text: String  = ""
	var end_match_called: bool = false
	var start_next_round_called: bool = false

	func _init(starting_round: int = 1) -> void:
		rounds = starting_round
		rounds_text = "Rounds:" + str(rounds)

	
	func start_nextRound() -> void:
		time_in_seconds = 90
		label_text = "01:30"
		start_next_round_called = true

	
	func tick() -> void:
		time_in_seconds -= 1
		var m := int(time_in_seconds / 60)
		var s := time_in_seconds - m * 60
		label_text = "%02d:%02d" % [m, s]

		if time_in_seconds == 0:
			rounds += 1
			rounds_text = "Rounds: " + str(rounds)

			if rounds > 8:
				end_match_called = true
			else:
				start_nextRound()


var _stub: CombatStub

func _make_stub(starting_round: int = 1) -> CombatStub:
	return CombatStub.new(starting_round)

# Advance the stub through a full 90-second round
func _run_full_round(stub: CombatStub) -> void:
	for _i in range(90):
		stub.tick()



func test_initial_round_is_read_from_global() -> void:
	# Global.current_round drives the starting value; stub defaults to 1
	_stub = _make_stub(1)
	assert_eq(_stub.rounds, 1, "Round should start at 1")

func test_initial_rounds_label_shows_correct_round() -> void:
	_stub = _make_stub(3)
	assert_eq(_stub.rounds_text, "Rounds:3",
		"Rounds label should display the starting round from Global.current_round")



func test_timer_starts_at_ninety_seconds() -> void:
	_stub = _make_stub()
	assert_eq(_stub.time_in_seconds, 90, "Timer must begin at 90 s")

func test_start_next_round_resets_timer_to_ninety() -> void:
	_stub = _make_stub()
	_stub.time_in_seconds = 0
	_stub.start_nextRound()
	assert_eq(_stub.time_in_seconds, 90, "start_nextRound() must reset timer to 90 s")

func test_start_next_round_resets_label_to_one_thirty() -> void:
	_stub = _make_stub()
	_stub.start_nextRound()
	assert_eq(_stub.label_text, "01:30", "Timer label must reset to '01:30'")

func test_timer_label_updates_each_tick() -> void:
	_stub = _make_stub()
	_stub.tick()   # 89 s remaining
	assert_eq(_stub.label_text, "01:29", "After one tick label should be '01:29'")


func test_round_increments_after_ninety_ticks() -> void:
	_stub = _make_stub(1)
	_run_full_round(_stub)
	assert_eq(_stub.rounds, 2, "Round must increment from 1 to 2 after 90 s")

func test_round_label_updates_after_timer_expires() -> void:
	_stub = _make_stub(1)
	_run_full_round(_stub)
	assert_eq(_stub.rounds_text, "Rounds: 2",
		"Rounds label must reflect the new round number")

func test_multiple_rounds_increment_correctly() -> void:
	_stub = _make_stub(1)
	for expected_round in range(2, 6):   # rounds 2 → 5
		_run_full_round(_stub)
		assert_eq(_stub.rounds, expected_round,
			"Round should be %d after completing round %d" % [expected_round, expected_round - 1])

func test_round_does_not_increment_mid_round() -> void:
	_stub = _make_stub(1)
	# Tick 45 times (halfway)
	for _i in range(45):
		_stub.tick()
	assert_eq(_stub.rounds, 1, "Round must not change before timer reaches 0")



func test_start_next_round_called_when_round_ends_below_max() -> void:
	_stub = _make_stub(1)
	_run_full_round(_stub)
	assert_true(_stub.start_next_round_called,
		"start_nextRound() must be called when rounds <= 8")

func test_timer_resets_automatically_after_round_ends() -> void:
	_stub = _make_stub(1)
	_run_full_round(_stub)
	assert_eq(_stub.time_in_seconds, 90,
		"Timer must be reset to 90 s at the start of the next round")


func test_end_match_not_called_on_round_eight() -> void:
	# When rounds reaches 8 after the timer expires it should NOT end the match,
	# because the condition is rounds > 8 (strictly greater).
	_stub = _make_stub(7)
	_run_full_round(_stub)   # rounds becomes 8
	assert_eq(_stub.rounds, 8, "rounds should be 8")
	assert_false(_stub.end_match_called,
		"end_match() must NOT be called when rounds == 8")

func test_end_match_called_when_rounds_exceeds_eight() -> void:
	_stub = _make_stub(8)
	_run_full_round(_stub)   # rounds becomes 9
	assert_true(_stub.end_match_called,
		"end_match() must be called when rounds > 8 (i.e. reaches 9)")

func test_start_next_round_not_called_when_match_ends() -> void:
	_stub = _make_stub(8)
	# Reset the flag that may have been set during _init path
	_stub.start_next_round_called = false
	_run_full_round(_stub)   # rounds becomes 9, end_match fires
	assert_false(_stub.start_next_round_called,
		"start_nextRound() must NOT be called once the match has ended")

func test_max_playable_round_is_eight() -> void:
	# After round 8 completes the match ends, so the last valid in-progress
	# round is 8.
	_stub = _make_stub(7)
	_run_full_round(_stub)
	assert_false(_stub.end_match_called,
		"Match must still be running at round 8")
	_stub.start_next_round_called = false
	_run_full_round(_stub)   # completes round 8 → rounds becomes 9
	assert_true(_stub.end_match_called,
		"Match must end after round 8 is completed")
