// Movement logic
if (keyboard_check(vk_left)) {
	// This check is to make sure the player doesn't go out of the room to the left
	if (x > sprite_get_xoffset(sprite_index) + GAME_AREA_LEFT + spd)	{
		x -= spd;
	} else {
		// Clamp the player to the leftmost side
        x = sprite_get_xoffset(sprite_index) + GAME_AREA_LEFT;
	}
}
if keyboard_check(vk_right) {
	// This check is to make sure the player doesn't go out of the room to the right
    if (x < GAME_AREA_RIGHT - sprite_get_xoffset(sprite_index) - spd) {
		x += spd;
	} else {
		// Clamp the player to the rightmost side
		x = GAME_AREA_RIGHT - sprite_get_xoffset(sprite_index);
	}
}
if (keyboard_check(ord("C"))) {
	// Fast speed
	spd = 10.5;
} else if (keyboard_check(ord("X"))) {
	// Slow speed
	spd = 3.5;
} else {
	// Normal speed
	spd = 7;
}
