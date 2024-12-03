extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var dash_sound = $DashSound
@onready var hurt_sound = $HurtSound
@onready var left_ray_cast = $LeftRayCast
@onready var right_ray_cast = $RightRayCast

var jumpCount = 0
var dashCount = 0

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	var dashVelocity = 0
	var horizontalVelocity = 0
	var facingWallLeftSide = left_ray_cast.is_colliding()
	var facingWallRightSide = right_ray_cast.is_colliding()

	# Add the gravity.
	if is_on_floor():
		jumpCount = 0
		dashCount = 0
	else:
		if velocity.x <= -900 or velocity.x >= 900:
			velocity.y = 0
		else:
			if (facingWallLeftSide or facingWallRightSide) and velocity.y > 0:
				jumpCount = 0
				dashCount = 0
				velocity.y = 50
			else:
				velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jumpCount < 2:
		jump_sound.play()
		if is_on_floor() or facingWallLeftSide or facingWallRightSide:
			jumpCount += 1
		else:
			jumpCount += 2
		velocity.y = JUMP_VELOCITY
		if facingWallLeftSide and not is_on_floor():
			velocity.x = 700
		if facingWallRightSide and not is_on_floor():
			velocity.x = -700
			
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4;
	
	if Input.is_action_just_pressed("dash") and dashCount < 1:
		dash_sound.play()
		dashCount += 1
		if (animated_sprite.flip_h):
			dashVelocity = -900
		else:
			dashVelocity = 900
	
	if (get_node("CollisionShape2D")):
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")

		if direction and (velocity.x >= -SPEED and velocity.x <= SPEED):
			horizontalVelocity = direction * SPEED
		else:
			horizontalVelocity = move_toward(velocity.x, 0, SPEED)
	
	if dashVelocity != 0:
		velocity.x = dashVelocity
	else:
		velocity.x = horizontalVelocity

	move_and_slide()
