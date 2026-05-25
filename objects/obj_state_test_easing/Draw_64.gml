// The vertical position of the pager.
#macro PAGER_Y 24

// The width and height of the graphs, in pixels.
#macro GRAPH_SIZE 256

// The width of the margins between graphs, in pixels.
#macro GRAPH_MARGIN 48

// The size of the arrows on the graph axes.
#macro GRAPH_AXIS_ARROW_SIZE 12

// The vertical offset between a graph's origin and its label, in pixels.
#macro GRAPH_LABEL_OFFSET 4

// Draw pager.
var _half_room_width = room_width / 2;
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_center);
draw_text_transformed(
    _half_room_width, PAGER_Y,
    $"{current_page + 1}/{array_length(easing_pages)}",
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

// Compute origin of first graph.
// FIXME - Need a vec struct.
var _origin = {
    x: GRAPH_MARGIN,
    y: GRAPH_SIZE + (room_height - GRAPH_SIZE) / 2
};

// Draw graphs for the easing functions in the current page.
draw_set_halign(fa_center);
var _easing_func_names = easing_pages[current_page];
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

        var _easing_func = struct_get(global.Easing, _easing_func_name);
        if (_easing_func) {
            // Plot easing function.
            var _prev_point = _origin;
            for (var _x = 0; _x < GRAPH_SIZE; ++_x) {
                var _y = lerp(0, GRAPH_SIZE, _easing_func(_x / GRAPH_SIZE));
                // FIXME - Need a vec struct.
                var _current_point = { x: _origin.x + _x, y: _origin.y - _y };
                draw_line(
                    _prev_point.x, _prev_point.y,
                    _current_point.x, _current_point.y);
                _prev_point = _current_point;
            }
        }
    }

    // Move to origin of next graph.
    _origin.x += GRAPH_SIZE + GRAPH_MARGIN;
}
