package vehicle

import "core:math"
import rl "vendor:raylib"

car :: struct {
	pos:             rl.Vector2,
	vel:             rl.Vector2,
	rotation:        f32,
	reverse:         bool,
	brake_hold_time: f32,
	drifting:        bool,
}

forward_right :: proc(rotation: f32) -> (rl.Vector2, rl.Vector2) {
	f := rl.Vector2{f32(math.cos(rotation)), f32(math.sin(rotation))}
	return f, rl.Vector2{-f.y, f.x}
}

car_init :: proc(pos: rl.Vector2) -> car {
	return {pos = pos}
}

car_update :: proc(car: ^car, dt: f32) {
	forward, right := forward_right(car.rotation)

	forward_speed := rl.Vector2DotProduct(car.vel, forward)
	side_speed := rl.Vector2DotProduct(car.vel, right)

	braking := rl.IsKeyDown(.SPACE)
	car.drifting = braking

	grip := LATERAL_GRIP
	if braking do grip *= DRIFT_LATERAL_GRIP_FACTOR
	side_speed *= math.exp(-grip * dt)
	car.vel = forward * forward_speed + right * side_speed

	if braking {
		car.brake_hold_time += dt
		s := rl.Vector2Length(car.vel)
		f := math.lerp(
			BRAKE_FORCE_MIN,
			BRAKE_FORCE_MAX,
			min(car.brake_hold_time / BRAKE_RAMP_TIME, 1.0),
		)
		if s > 0 do car.vel -= rl.Vector2Normalize(car.vel) * min(f * dt, s)
	} else do car.brake_hold_time = 0

	steer: f32
	if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) do steer -= 1
	if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) do steer += 1

	speed := rl.Vector2Length(car.vel)
	if math.abs(forward_speed) > STEERING_DEAD_ZONE {
		steering_factor := min(speed / STEERING_FACTOR_THRESHOLD, 1.0)
		high_speed_factor := 1.0 - HIGH_SPEED_FACTOR_REDUCTION * min(speed / MAX_SPEED, 1.0)

		turn := BASE_TURN_SPEED
		if car.drifting do turn *= DRIFT_TURN_BOOST
		car.rotation += steer * turn * steering_factor * high_speed_factor * dt
	}

	if rl.IsKeyPressed(.R) do car.reverse = !car.reverse

	if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W) {
		car.vel += (forward if !car.reverse else -forward) * (ACCELERATION * dt)
	}

	if rl.Vector2Length(car.vel) > MAX_SPEED {
		car.vel = rl.Vector2Normalize(car.vel) * MAX_SPEED
	}

	car.vel *= DRAG
	car.pos += car.vel * dt
}

car_draw :: proc(car: car) {
	forward, right := forward_right(car.rotation)
	rl.DrawTriangle(
		car.pos + forward * 18,
		car.pos - forward * 18 * 0.6 - right * 10,
		car.pos - forward * 18 * 0.6 + right * 10,
		rl.RED if !car.drifting else rl.ORANGE,
	)
	rl.DrawLineV(car.pos, car.pos + forward * 20, rl.WHITE)
}
