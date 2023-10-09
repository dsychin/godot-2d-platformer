extends GutTest

var Scene: PackedScene = load("res://main.tscn")
var _scene: Node = null
var _player: CharacterBody2D = null
var _sender = InputSender.new(Input)

func before_each():
	_scene = add_child_autofree(Scene.instantiate())
	_player = _scene.get_node("Player")
	await wait_frames(1)

func after_each():
	_sender.release_all()
	_sender.clear()

func test_player_moves_right():
	var initialPosition = _player.global_position
	await _sender.action_down("ui_right").hold_for(.2).idle

	assert_gt(_player.global_position.x, initialPosition.x)

func test_player_moves_left():
	var initialPosition = _player.global_position
	await _sender.action_down("ui_left").hold_for(.2).idle

	assert_lt(_player.global_position.x, initialPosition.x)
