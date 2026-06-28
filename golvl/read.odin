package golvl

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

// reading the .golvl files exported by https://github.com/jmattaa/golvl
// my golvl level editor 🔥🔥🔥🔥

lvl :: struct {
	width:  int,
	height: int,
	data:   []i32,
}

read :: proc(fpath: string) -> lvl {
	level := lvl{}

	data, err := os.read_entire_file(fpath, context.allocator)
	if err != nil {
		fmt.printf("failed to read %s: %s\n", fpath, err)
		return lvl{}
	}
	defer delete(data, context.allocator)

	text := string(data)
	lines := strings.split_lines(text)
	defer delete(lines)

	ok: bool
	level.width, ok = strconv.parse_int(lines[0], 10)
	if !ok {
		return lvl{}
	}

	level.height, ok = strconv.parse_int(lines[1], 10)
	if !ok {
		return lvl{}
	}

	level.data = make([]i32, level.width * level.height)

	for y in 0 ..< level.height {
		line := lines[y + 2]

		if len(line) != level.width {
			fmt.printf("invalid row %d\n", y)
			delete(level.data)
			return lvl{}
		}

		for x in 0 ..< level.width {
			c := line[x]
			level.data[y * level.width + x] = i32(c - '0')
		}
	}

	return level
}

free :: proc(level: lvl) {
    delete(level.data)
}
