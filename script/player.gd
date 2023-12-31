extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var anim_vec: Vector2
@onready var anim_player = $Barbarian/AnimationPlayer
@onready var anim_tree = $AnimationTree

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Start animation
	if Input.is_action_just_pressed("attack"):
		anim_tree.active = false
		anim_player.play("1H_Melee_Attack_Chop")
		await anim_player.animation_finished
		anim_tree.active = true

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		anim_tree.active = false
		velocity.y += JUMP_VELOCITY
		anim_player.play("Jump_Full_Short")
		await anim_player.animation_finished
		anim_tree.active = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	anim_vec.x = direction.x
	anim_vec.y = direction.z
	anim_vec = anim_vec.normalized()

	anim_tree["parameters/blend_position"] = anim_vec

	move_and_slide()
