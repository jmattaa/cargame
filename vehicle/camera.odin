package vehicle

import rl "vendor:raylib"

camera_follow :: proc(cam: ^rl.Camera2D, pos: rl.Vector2, dt: f32) {
	cam.target += (pos - cam.target) * CAMERA_SMOOTHNESS * dt
}
