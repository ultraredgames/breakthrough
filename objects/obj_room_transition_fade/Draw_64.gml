var _alpha = elapsed / duration;
if (_alpha < 1) {
	// Compute current alpha from fade direction.
	if (fade_direction == FadeDirection.In) {
		_alpha = 1 - _alpha;
	}
	// Apply fade effect.
	var _previous_alpha = draw_get_alpha();
	draw_set_alpha(_alpha);
	draw_rectangle_color(
		0, 0, display_get_gui_width(), display_get_gui_height(),
		fade_color, fade_color, fade_color, fade_color, false);
	draw_set_alpha(_previous_alpha);
	// One more frame has elapsed.
	++elapsed;
} else {
	// Fade effect has finished.
	if (fade_direction == FadeDirection.In) {
		instance_destroy();
	} else {
		// Prepare for second phase in next room.
		elapsed = 0;
		fade_direction = FadeDirection.In;
		room_goto(room_index);
	}
}
