package main

import "vehicle"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(800, 450, "cargame")
	rl.SetTargetFPS(60)
	rl.SetExitKey(rl.KeyboardKey.ESCAPE)

	car := vehicle.car_init(rl.Vector2{400, 300})

	dt: f32 = 0
	for !rl.WindowShouldClose() {
		dt = rl.GetFrameTime()
		vehicle.car_update(&car, dt)

		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)
		vehicle.car_draw(car)
		rl.EndDrawing()
	}
}
