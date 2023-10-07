extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const COYOTE_FRAMES = 6
const ACCELERATION = 0.25
const FRICTION = 0.1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer : Timer = $CoyoteTimer

var last_floor = false
var is_in_coyote = false

func _ready():
	animated_sprite.play("idle")
	coyote_timer.wait_time = COYOTE_FRAMES / 60.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_in_coyote and is_on_floor():
		is_in_coyote = false
	elif not is_in_coyote and last_floor:
		coyote_timer.start()
		is_in_coyote = true

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or is_in_coyote):
		velocity.y = JUMP_VELOCITY
		is_in_coyote = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICTION)
		
	if not is_on_floor():
		animated_sprite.play("jump")
	elif direction:
		animated_sprite.play("run")
	elif is_on_floor():
		animated_sprite.play("idle")
		
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true
		
	last_floor = is_on_floor()
	move_and_slide()


func _on_coyote_timer_timeout():
	is_in_coyote = false
