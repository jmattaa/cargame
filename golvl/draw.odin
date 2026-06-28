package golvl

import rl "vendor:raylib"

COLORS := []rl.Color{rl.BLUE, rl.RED, rl.GREEN}

draw :: proc(lvl: lvl) {
	for y := 0; y < lvl.height; y += 1 {
		for x := 0; x < lvl.width; x += 1 {
			if lvl.data[y * lvl.width + x] == 0 do continue
			color := COLORS[lvl.data[y * lvl.width + x] - 1]
			rl.DrawRectangle(i32(x * 16), i32(y * 16), 16, 16, color)
		}
	}
}
