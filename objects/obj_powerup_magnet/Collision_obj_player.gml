// Ball passes through bricks whilst destroying them.
obj_ball.magnet = true;
obj_ball.image_blend = c_lime;
obj_ball.alarm[0] = 60 * 10;
//audio_play_sound(snd_powerup, 0, false);
instance_destroy();
