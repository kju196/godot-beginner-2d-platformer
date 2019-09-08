extends "res://src/actors/Actor.gd"


export var stomp_impulse: = 600.0


func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_linear_velocity = calculate_stomp_velocity(_linear_velocity, stomp_impulse)


func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	die()


func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _linear_velocity.y < 0
	var direction: = get_direction()
	_linear_velocity = calculate_move_velocity(_linear_velocity, direction, speed, is_jump_interrupted)


func die() -> void:
	PlayerData.deaths += 1
	queue_free()


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y = speed.y * direction.y if direction.y != 0 else out.y
	out.y = 0.0 if is_jump_interrupted else out.y
	return out


func calculate_stomp_velocity(linear_velocity: Vector2, stomp_impulse: float) -> Vector2:
	var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
	return Vector2(linear_velocity.x, stomp_jump)
