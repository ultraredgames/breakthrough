// Bounce
vspeed *= -1; // Reverse the vertical speed
var _s = speed; // Store the current speed
var _dir = point_direction(other.x, other.y + 32, x, y);
var _dist = point_distance(x, y, other.x, other.y + 32)
motion_add(_dir, _dist / 5); // Add to direction based on position of bounce
speed = _s; // Maintain speed
//audio_play_sound(snd_bounce, 0, false);