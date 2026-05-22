// Run all our test effects within this timeframe.
#macro EFFECT_INTERVAL_MIN 30
#macro EFFECT_INTERVAL_MAX 360
#macro EFFECT_INTERVAL_RANDOM irandom_range(EFFECT_INTERVAL_MIN, EFFECT_INTERVAL_MAX)

// Stop adding effects when we reach that count.
#macro EFFECT_COUNT_THRESHOLD 64

// Spawn another batch of effects after this interval, in frames.
#macro ORCHESTRATOR_INTERVAL 30

// We need something in this scope to get meaningful logs.
__name = "obj_state_test_effects";
arbitrary_value = 42;

// Maintain a global effect count accessible from any scope.
global.effect_count = 0;

// Show debug messages in the game itself.
show_debug_log(true);

// Predictable results are boring.
randomise();

// Add main "orchestrator" effect, which runs all the test effects.
obj_effects.add(self, function() {
    if (global.effect_count >= EFFECT_COUNT_THRESHOLD) {
        // Effect count threshold reached, do nothing but keep running.
        show_debug_message(
            $"|ORCHESTRATOR| Effect threshold reached, slowing down...");
        return true;
    }

    // TEST - Empty scope.
    obj_effects.add({}, function() {
        show_debug_message(
            $"|EFFECTS| Empty scope: {self}");
        --global.effect_count;
        return false;
    }, EFFECT_INTERVAL_RANDOM);
    ++global.effect_count;

    // TEST - Undefined scope.
    obj_effects.add(undefined, function() {
        show_debug_message(
            $"|EFFECTS| Undefined scope: {self}");
        --global.effect_count;
        return false;
    }, EFFECT_INTERVAL_RANDOM);
    ++global.effect_count;

    // TEST - Self scope.
    obj_effects.add(self, function() {
        show_debug_message(
            $"|EFFECTS| Self scope: {self}");
        --global.effect_count;
        return false;
    }, EFFECT_INTERVAL_RANDOM);
    ++global.effect_count;

    // TEST - Other scope.
    obj_effects.add(other, function() {
        show_debug_message(
            $"|EFFECTS| Other scope: {self}");
        --global.effect_count;
        return false;
    }, EFFECT_INTERVAL_RANDOM);
    ++global.effect_count;

    // TEST - Global scope.
    obj_effects.add(global, function() {
        show_debug_message(
            $"|EFFECTS| Global scope: {self}");
        --global.effect_count;
        return false;
    }, EFFECT_INTERVAL_RANDOM);
    ++global.effect_count;

    // TEST - Simple scope.
    obj_effects.add({
        __name: "simple_scope"
    }, function() {
        show_debug_message(
            $"|EFFECTS| Simple scope: {self}");
        --global.effect_count;
        return false;
    }, EFFECT_INTERVAL_RANDOM);
    ++global.effect_count;

    // TEST - Step method from scope.
    obj_effects.add({
        __name: "step_from_scope",
        step: function() {
            show_debug_message(
                $"|EFFECTS| Step method from scope: {self}");
            --global.effect_count;
            return false;
        }
    }, undefined, EFFECT_INTERVAL_RANDOM);
    ++global.effect_count;

    // TEST - Step method from scope, replace.
    obj_effects.add({
        __name: "step_from_scope_replace",
        step: function() {
            show_debug_message(
                $"|EFFECTS| Step method from scope (base): {self}");
            --global.effect_count;
            return false;
        }
    }, function() {
        show_debug_message(
            $"|EFFECTS| Step method from scope, replace: {self}");
        --global.effect_count;
        return false;
    }, EFFECT_INTERVAL_RANDOM);
    ++global.effect_count;

    // TEST - Step method from scope, inherit.
    obj_effects.add({
        __name: "step_from_scope_inherit",
        step: function() {
            show_debug_message(
                $"|EFFECTS| Step method from scope, inherit (base): {self}");
            --global.effect_count;
            return false;
        }
    }, function() {
        var _keep_going = step();
        show_debug_message(
            $"|EFFECTS| Step method from scope, inherit (derived): {self}");
        return _keep_going;
    }, EFFECT_INTERVAL_RANDOM);
    ++global.effect_count;

    // TEST - Effect base scope.
    obj_effects.add(new Effect(), function() {
        show_debug_message(
            $"|EFFECTS| Abstract base effect scope: {self}");
        --global.effect_count;
        return false;
    }, EFFECT_INTERVAL_RANDOM);
    ++global.effect_count;

    // Orchestrator effect runs forever.
    return true;
}, ORCHESTRATOR_INTERVAL);
++global.effect_count;
