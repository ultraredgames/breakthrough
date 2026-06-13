// Spawn 8 duplicate ball objects.
repeat (8) {
	instance_create_layer(obj_ball.x, obj_ball.y, layer, obj_ball_duplicate);
}
//audio_play_sound(snd_powerup, 0, false);
instance_destroy();
