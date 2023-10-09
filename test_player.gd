extends GutTest

var Scene: PackedScene = load("res://main.tscn")
var _scene: Node = null
var _player: CharacterBody2D = null
var _sender = InputSender.new(Input)

func before_each():
	_scene = add_child_autofree(Scene.instantiate())
	_player = _scene.get_node("Player")
	await wait_frames(2)

func after_each():
	_sender.release_all()
	_sender.clear()

func test_player_should_be_on_floor():
	assert_true(_player.is_on_floor())

func test_player_moves_right():
	var initialPosition = _player.global_position
	await _sender.action_down("ui_right").hold_for(.2).idle

	assert_gt(_player.global_position.x, initialPosition.x)

func test_player_moves_left():
	var initialPosition = _player.global_position
	await _sender.action_down("ui_left").hold_for(.2).idle

	assert_lt(_player.global_position.x, initialPosition.x)

func test_player_jumps():
	await _sender.action_down("ui_accept").hold_for(.1).idle

	assert_lt(_player.velocity.y, 0.0)

func test_player_should_have_idle_animation():
	await wait_seconds(.1)

	assert_eq("idle", _player.get_node("AnimatedSprite2D").get_animation())

func test_player_should_have_run_animation():
	await _sender.action_down("ui_right").hold_for(.2).idle

	assert_eq("run", _player.get_node("AnimatedSprite2D").get_animation())

func test_player_should_have_jump_animation():
	await _sender.action_down("ui_accept").hold_for(.2).idle

	assert_eq("jump", _player.get_node("AnimatedSprite2D").get_animation())

func test_player_should_face_left():
	await _sender.action_down("ui_left").hold_for(.2).idle

	assert_true(_player.get_node("AnimatedSprite2D").flip_h)