package main

import "vehicle"
import "golvl"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(800, 450, "cargame")
	rl.SetTargetFPS(60)
	rl.SetExitKey(rl.KeyboardKey.ESCAPE)

	car := vehicle.car_init({400, 300})
	cam := rl.Camera2D{
		target = {400, 300},
		offset = {400, 225},
		zoom   = 1,
	}

    lvl := golvl.read("default.golvl")
    defer golvl.free(lvl)

	dt: f32 = 0
	for !rl.WindowShouldClose() {
		dt = rl.GetFrameTime()
		vehicle.car_update(&car, dt)
		vehicle.camera_follow(&cam, car.pos, dt)

		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)
		rl.BeginMode2D(cam)

        golvl.draw(lvl)
		vehicle.car_draw(car)

		rl.EndMode2D()
		rl.EndDrawing()
	}
}
