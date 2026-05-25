// Draw the current effect count.
draw_set_color(c_white);
draw_set_font(fnt_game);
draw_set_halign(fa_left);
draw_text(TILE_SIZE, room_height - TILE_SIZE * 2,
    $"RUNNING EFFECTS: {obj_effects.get_count()}");
