// Movement Logic
if (keyboard_check(vk_left)) {
	// This check is to make sure the bat doesn't go out of the room to the left
	if (x > sprite_get_xoffset(sprite_index) + spd)	{
		x -= spd;
	} else {
        x = sprite_get_xoffset(sprite_index); // Clamp the bat to the leftmost side
	}
}
if keyboard_check(vk_right) {
	// This check is to make sure the bat doesn't go out of the room to the right
    if (x < room_width - sprite_get_xoffset(sprite_index) - spd) {
		x += spd;
	} else {
		x = room_width - sprite_get_xoffset(sprite_index);
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
// Move the ball object with the bat if the ball isn't moving yet
with (obj_ball) {
	if (!go) {
		x = other.x;
	}
}