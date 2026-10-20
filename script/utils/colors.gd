extends Node

enum Palette {
	WHITE,
	YELLOW,
	GREEN,
	BLUE,
	ORANGE,
	RED,
	PURPLE,
	GRAY
}

const COLORS: Dictionary = {
	Palette.WHITE: Color("#f0f0eb"),
	Palette.YELLOW: Color("#ffff8f"),
	Palette.GREEN: Color("#7be098"),
	Palette.BLUE: Color("#849ad8"),
	Palette.ORANGE: Color("#e8b382"),
	Palette.RED: Color("#d8828e"),
	Palette.PURPLE: Color("#a776c1"),
	Palette.GRAY: Color("#545155"),
}

func get_random_color() -> Color:
	var random := randi_range(0, Palette.size() - 1)
	return COLORS[random]

func get_color(color: Palette) -> Color:
	return COLORS[color]
