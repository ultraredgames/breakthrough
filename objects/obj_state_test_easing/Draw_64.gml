// The vertical position of the pager.
#macro PAGER_Y 32

// The vertical position of the footer.
#macro FOOTER_Y (room_height - 48)

// The full width of a graph, including the animated ball.
#macro GRAPH_FULL_WIDTH 260

// The width and height of a graph, in pixels.
#macro GRAPH_SIZE 236

// The width of the margins between graphs, in pixels.
#macro GRAPH_MARGIN 45

// The size of the arrows on the graph axes.
#macro GRAPH_AXIS_ARROW_SIZE 12

// The vertical offset between a graph's origin and its label, in pixels.
#macro GRAPH_LABEL_OFFSET 4

// The horizontal offset between a graph's right side and its associated
// animated ball.
#macro GRAPH_BALL_OFFSET 16

// Draw pager.
var _half_room_width = room_width / 2;
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_center);
draw_text_transformed(
    _half_room_width, PAGER_Y,
    $"{__current_page_index + 1}/{array_length(__easing_pages)}",
    2, 2, 0);

// Draw pager arrows.
var _half_pager_width = string_width(" 99/99 ");
draw_set_color(c_yellow);
draw_set_halign(fa_right);
draw_text_transformed(
    _half_room_width - _half_pager_width, PAGER_Y,
    "<", 2, 2, 0);
draw_set_halign(fa_left);
draw_text_transformed(
    _half_room_width + _half_pager_width, PAGER_Y,
    ">", 2, 2, 0);

// Draw footer.
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text_transformed(
    _half_room_width, FOOTER_Y,
    $"Running Effects: {obj_effects.get_count()}",
    1.5, 1.5, 0);

// Compute origin of first graph.
// FIXME - Need a vec struct.
var _origin = {
    x: GRAPH_MARGIN,
    y: GRAPH_SIZE + (room_height - GRAPH_SIZE) / 2
};

// Draw graphs for the easing functions in the current page.
var _easing_func_names = __easing_pages[__current_page_index];
for (var _i = 0; _i < array_length(_easing_func_names); ++_i) {
    var _easing_func_name = _easing_func_names[_i];
    if (!is_undefined(_easing_func_name)) {
        // Draw graph axes.
        draw_set_color(c_dkgray);
        draw_arrow(
            _origin.x, _origin.y,
            _origin.x + GRAPH_SIZE, _origin.y,
            GRAPH_AXIS_ARROW_SIZE);
        draw_arrow(
            _origin.x, _origin.y,
            _origin.x, _origin.y - GRAPH_SIZE,
            GRAPH_AXIS_ARROW_SIZE);

        // Draw graph label.
        draw_set_color(c_white);
        draw_text(
            _origin.x + GRAPH_SIZE / 2, _origin.y + 4,
            _easing_func_name);

        // Fetch current easing function by name.
        var _easing_func = global.Easing[$ _easing_func_name];
        var _variables = __animated_variables[$ $"animation.{_i}"];
        if (_easing_func && _variables) {
            // Plot easing function.
            var _prev_point = _origin;
            for (var _x = 0; _x < GRAPH_SIZE; ++_x) {
                // Highlight current point in the graph.
                var _color = merge_color(
                    c_blue, c_white,
                    global.Easing.out_expo(
                        abs(_x - _variables.x.value) * 4 / GRAPH_SIZE));

                var _y = lerp(0, GRAPH_SIZE, _easing_func(_x / GRAPH_SIZE));
                // FIXME - Need a vec struct.
                var _current_point = {
                    x: _origin.x + _x,
                    y: _origin.y - _y
                };
                draw_line_color(
                    _prev_point.x, _prev_point.y,
                    _current_point.x, _current_point.y,
                    _color, _color);
                _prev_point = _current_point;
            }

            // Draw animated ball at its current vertical position.
            draw_sprite_ext(
                spr_ball, 0, _origin.x + GRAPH_SIZE + GRAPH_BALL_OFFSET,
                _origin.y - _variables.y.value, 1, 1, 0, c_aqua, 1);
        }
    }

    // Move to origin of next graph.
    _origin.x += GRAPH_FULL_WIDTH + GRAPH_MARGIN;
}
