// Debug overlay.
//show_debug_overlay(true);

// Initialize global variables.
global.player_score = 0;
global.player_lives = 3;

if (room == BEGIN_LEVEL) {
	if (!audio_is_playing(snd_mus_omake2)) {
		audio_play_sound(snd_mus_omake2, 0, true, 0.5, 0, 1, 1);
	}
}
