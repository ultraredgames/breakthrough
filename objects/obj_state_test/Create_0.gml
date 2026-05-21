// Run all our effects within this timeframe.
#macro INTERVAL_MIN 30
#macro INTERVAL_MAX 360

// We need something in this scope to get meaningful logs.
__name = "obj_state_test";
arbitrary_value = 42;

// Maintain a global effect count accessible from any scope.
global.effects_count = 0;

// Show debug messages in the game itself.
show_debug_log(true);

// TEST - Empty scope.
obj_effects.add({}, function() {
    show_debug_message(
        $"|EFFECTS| Empty scope: {self}");
    --global.effects_count;
    return false;
}, irandom_range(INTERVAL_MIN, INTERVAL_MAX));
++global.effects_count;

// TEST - Undefined scope.
obj_effects.add(undefined, function() {
    show_debug_message(
        $"|EFFECTS| Undefined scope: {self}");
    --global.effects_count;
    return false;
}, irandom_range(INTERVAL_MIN, INTERVAL_MAX));
++global.effects_count;

// TEST - Self scope.
obj_effects.add(self, function() {
    show_debug_message(
        $"|EFFECTS| Self scope: {self}");
    --global.effects_count;
    return false;
}, irandom_range(INTERVAL_MIN, INTERVAL_MAX));
++global.effects_count;

// TEST - Other scope.
obj_effects.add(other, function() {
    show_debug_message(
        $"|EFFECTS| Other scope: {self}");
    --global.effects_count;
    return false;
}, irandom_range(INTERVAL_MIN, INTERVAL_MAX));
++global.effects_count;

// TEST - Global scope.
obj_effects.add(global, function() {
    show_debug_message(
        $"|EFFECTS| Global scope: {self}");
    --global.effects_count;
    return false;
}, irandom_range(INTERVAL_MIN, INTERVAL_MAX));
++global.effects_count;

// TEST - Simple scope.
obj_effects.add({
    __name: "simple_scope"
}, function() {
    show_debug_message(
        $"|EFFECTS| Simple scope: {self}");
    --global.effects_count;
    return false;
}, irandom_range(INTERVAL_MIN, INTERVAL_MAX));
++global.effects_count;

// TEST - Step method from scope.
obj_effects.add({
    __name: "step_from_scope",
    step: function() {
        show_debug_message(
            $"|EFFECTS| Step method from scope: {self}");
        --global.effects_count;
        return false;
    }
}, undefined, irandom_range(INTERVAL_MIN, INTERVAL_MAX));
++global.effects_count;

// TEST - Step method from scope, replace.
obj_effects.add({
    __name: "step_from_scope_replace",
    step: function() {
        show_debug_message(
            $"|EFFECTS| Step method from scope (base): {self}");
        --global.effects_count;
        return false;
    }
}, function() {
    show_debug_message(
        $"|EFFECTS| Step method from scope, replace: {self}");
    --global.effects_count;
    return false;
}, irandom_range(INTERVAL_MIN, INTERVAL_MAX));
++global.effects_count;

// TEST - Step method from scope, inherit.
obj_effects.add({
    __name: "step_from_scope_inherit",
    step: function() {
        show_debug_message(
            $"|EFFECTS| Step method from scope, inherit (base): {self}");
        --global.effects_count;
        return false;
    }
}, function() {
    var _result = step();
    show_debug_message(
        $"|EFFECTS| Step method from scope, inherit (derived): {self}");
    return _result;
}, irandom_range(INTERVAL_MIN, INTERVAL_MAX));
++global.effects_count;

// TEST - Effect base scope.
obj_effects.add(new Effect(), function() {
    show_debug_message(
        $"|EFFECTS| Abstract base effect scope: {self}");
    --global.effects_count;
    return false;
}, irandom_range(INTERVAL_MIN, INTERVAL_MAX));
++global.effects_count;
