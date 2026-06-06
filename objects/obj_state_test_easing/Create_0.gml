// The duration of the animations, in frames.
#macro ANIMATION_DURATION 120

// The delay before animations restart, in frames.
#macro ANIMATION_DELAY 60

// The easing functions to plot, split into pages of three.
__easing_pages = [
    [undefined, "linear", undefined],
    ["in_sine", "out_sine", "in_out_sine"],
    ["in_quad", "out_quad", "in_out_quad"],
    ["in_cubic", "out_cubic", "in_out_cubic"],
    ["in_quart", "out_quart", "in_out_quart"],
    ["in_quint", "out_quint", "in_out_quint"],
    ["in_expo", "out_expo", "in_out_expo"],
    ["in_circ", "out_circ", "in_out_circ"],
    ["in_back", "out_back", "in_out_back"],
    ["in_elastic", "out_elastic", "in_out_elastic"],
    ["in_bounce", "out_bounce", "in_out_bounce"]
];

// The variables that will be animated according to the currently
// displayed page of easing function graphs.
__animated_variables = {};

// Switch to the first page.
__current_page_index = 0;
__switch_to_page(__current_page_index);

/**
 * Switches display to specified page.
 * @param {real} page_index The zero-based index of the page to switch to.
 */
function __switch_to_page(page_index)
{
    var _page_count = array_length(__easing_pages);
    if (!_page_count) {
        // Nothing to display, bail out.
        return;
    }

    // Wrap page index around if needed.
    var _index = page_index;
    if (_index < 0) {
        _index = _page_count - 1;
    } else if (_index >= _page_count) {
        _index = 0;
    }
    __current_page_index = _index;

    // Run animations.
    var _easing_func_names = __easing_pages[__current_page_index];
    for (var _i = 0; _i < array_length(_easing_func_names); ++_i) {
        var _easing_func_name = _easing_func_names[_i];
        var _animation_name = $"animation.{_i}";
        if (!is_undefined(_easing_func_name)) {
            // Animate the current easing function, replacing the previous
            // animation if necessary.
            __run_animation(_animation_name, _easing_func_name);
        } else {
            // Nothing to animate here, but we still have to discard the
            // existing animation or delay effect.
            obj_effects.remove(_animation_name);
            __animated_variables[$ _animation_name] = undefined;
        }
    }
}

/**
 * Animates specified easing function.
 * @param {string} animation_name   The name of the animation.
 * @param {string} easing_func_name The name of the easing function to animate.
 */
function __run_animation(animation_name, easing_func_name)
{
    // Animate a single point on both axes.
    var _easing_func = global.Easing[$ easing_func_name];
    var _variables = {
        x: { from: 0, to: GRAPH_SIZE },
        y: { from: 0, to: GRAPH_SIZE, easing: _easing_func }
    };

    // Replace existing animation and animate current easing function.
    obj_effects.add_named(animation_name, new Animation(
        ANIMATION_DURATION, _variables, {
            animation_name,
            easing_func_name
        }), function() {
            var _keep_going = step();
            if (!_keep_going) {
                // Animation ends this frame, restart it after delay.
                obj_effects.add_named(
                    context.animation_name, context, function() {
                        obj_state_test_easing.__run_animation(
                            animation_name, easing_func_name);
                        return false;
                    }, true, ANIMATION_DELAY);
            }
            return _keep_going;
        }, true);
    __animated_variables[$ animation_name] = _variables;
}
