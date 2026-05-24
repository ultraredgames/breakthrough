// Stop adding effects when we reach that count.
#macro EFFECT_COUNT_THRESHOLD 64

// The random interval range of test effects.
#macro EFFECT_INTERVAL_RANDOM irandom_range(30, 360)

// The interval between spawning another batch of effects, in frames.
#macro ORCHESTRATOR_INTERVAL 30

// We need something in this scope to get meaningful logs.
__name = "obj_state_test_effects";
arbitrary_value = 42;

// Show debug messages in the game itself.
show_debug_log(true);

// Predictable results are boring.
randomize();

// Add main "orchestrator" effect, which runs all our anonymous effect tests.
obj_effects.add_named("orchestrator", self, function() {
    if (obj_effects.get_count() >= EFFECT_COUNT_THRESHOLD) {
        // Effect count threshold reached, do nothing but keep running.
        show_debug_message(
            $"|ORCHESTRATOR| Effect threshold reached, slowing down...");
        return true;
    }

    // TEST - Empty scope.
    obj_effects.add({}, function() {
        show_debug_message(
            $"|EFFECTS     | Empty scope: {self}");
        return false;
    }, EFFECT_INTERVAL_RANDOM);

    // TEST - Undefined scope.
    obj_effects.add(undefined, function() {
        show_debug_message(
            $"|EFFECTS     | Undefined scope: {self}");
        return false;
    }, EFFECT_INTERVAL_RANDOM);

    // TEST - Self scope.
    obj_effects.add(self, function() {
        show_debug_message(
            $"|EFFECTS     | Self scope: {self}");
        return false;
    }, EFFECT_INTERVAL_RANDOM);

    // TEST - Other scope.
    obj_effects.add(other, function() {
        show_debug_message(
            $"|EFFECTS     | Other scope: {self}");
        return false;
    }, EFFECT_INTERVAL_RANDOM);

    // TEST - Global scope.
    // obj_effects.add(global, function() {
    //     show_debug_message(
    //         $"|EFFECTS     | Global scope: {self}");
    //     return false;
    // }, EFFECT_INTERVAL_RANDOM);

    // TEST - Simple scope.
    obj_effects.add({
        __name: "simple_scope"
    }, function() {
        show_debug_message(
            $"|EFFECTS     | Simple scope: {self}");
        return false;
    }, EFFECT_INTERVAL_RANDOM);

    // TEST - Step method from scope.
    obj_effects.add({
        __name: "step_from_scope",
        step: function() {
            show_debug_message(
                $"|EFFECTS     | Step method from scope: {self}");
            return false;
        }
    }, undefined, EFFECT_INTERVAL_RANDOM);

    // TEST - Step method from scope, replace.
    obj_effects.add({
        __name: "step_from_scope_replace",
        step: function() {
            show_debug_message(
                $"|EFFECTS     | Step method from scope (base): {self}");
            return false;
        }
    }, function() {
        show_debug_message(
            $"|EFFECTS     | Step method from scope, replace: {self}");
        return false;
    }, EFFECT_INTERVAL_RANDOM);

    // TEST - Step method from scope, inherit.
    obj_effects.add({
        __name: "step_from_scope_inherit",
        step: function() {
            show_debug_message(
                $"|EFFECTS     | Step method from scope, inherit (base): {self}");
            return false;
        }
    }, function() {
        var _keep_going = step();
        show_debug_message(
            $"|EFFECTS     | Step method from scope, inherit (derived): {self}");
        return _keep_going;
    }, EFFECT_INTERVAL_RANDOM);

    // TEST - Abstract base effect scope.
    obj_effects.add(new Effect(), function() {
        show_debug_message(
            $"|EFFECTS     | Abstract base effect scope: {self}");
        return false;
    }, EFFECT_INTERVAL_RANDOM);

    // TEST - Animation scope, undefined context.
    obj_effects.add(new Animation(1, {
        a: { from: 0, to: -1 },
        b: { from: 0, to: 1 }
    }), function() {
        var _keep_going = step();
        show_debug_message(
            $"|ANIMATIONS  | Animation scope, undefined context: {self}");
        return _keep_going;
    }, EFFECT_INTERVAL_RANDOM);

    // TEST - Animation scope, empty context.
    obj_effects.add(new Animation(1, {
        a: { from: 0, to: -1 },
        b: { from: 0, to: 1 }
    }, {}), function() {
        var _keep_going = step();
        show_debug_message(
            $"|ANIMATIONS  | Animation scope, empty context: {self}");
        return _keep_going;
    }, EFFECT_INTERVAL_RANDOM);

    // TEST - Animation scope, self context.
    obj_effects.add(new Animation(1, {
        a: { from: 0, to: -1 },
        b: { from: 0, to: 1 }
    }, self), function() {
        var _keep_going = step();
        show_debug_message(
            $"|ANIMATIONS  | Animation scope, self context: {self}");
        return _keep_going;
    }, EFFECT_INTERVAL_RANDOM);

    // TEST - Animation scope, other context.
    obj_effects.add(new Animation(1, {
        a: { from: 0, to: -1 },
        b: { from: 0, to: 1 }
    }, other), function() {
        var _keep_going = step();
        show_debug_message(
            $"|ANIMATIONS  | Animation scope, other context: {self}");
        return _keep_going;
    }, EFFECT_INTERVAL_RANDOM);

    // TEST - Animation scope, global context.
    // obj_effects.add(new Animation(1, {
    //     a: { from: 0, to: -1 },
    //     b: { from: 0, to: 1 }
    // }, global), function() {
    //     var _keep_going = step();
    //     show_debug_message(
    //         $"|ANIMATIONS  | Animation scope, global context: {self}");
    //     return _keep_going;
    // }, EFFECT_INTERVAL_RANDOM);

    // TEST - Animation scope, simple context.
    obj_effects.add(new Animation(1, {
        a: { from: 0, to: -1 },
        b: { from: 0, to: 1 }
    }, {
        __name: "__simple_context"
    }), function() {
        var _keep_going = step();
        show_debug_message(
            $"|ANIMATIONS  | Animation scope, simple context: {self}");
        return _keep_going;
    }, EFFECT_INTERVAL_RANDOM);

    // Orchestrator effect runs forever.
    return true;
}, false, ORCHESTRATOR_INTERVAL);

// TEST - Named effect, preserve.
obj_effects.add_named("named_effect_preserve", {
    __name: "named_effect_original"
}, function() {
    show_debug_message(
        $"|EFFECTS     | Named effect, preserve: {self}");
    return true;
}, false, EFFECT_INTERVAL_RANDOM);

// TEST - Named effect, preserve.
obj_effects.add_named("named_effect_preserve", {
    __name: "named_effect_replaced"
}, function() {
    show_debug_message(
        $"|EFFECTS     | Named effect, preserve: {self}");
    return true;
}, false, EFFECT_INTERVAL_RANDOM);

// TEST - Named effect, replace.
obj_effects.add_named("named_effect_replace", {
    __name: "named_effect_original"
}, function() {
    show_debug_message(
        $"|EFFECTS     | Named effect, replace: {self}");
    return true;
}, true, EFFECT_INTERVAL_RANDOM);

// TEST - Named effect, replace.
obj_effects.add_named("named_effect_replace", {
    __name: "named_effect_replaced"
}, function() {
    show_debug_message(
        $"|EFFECTS     | Named effect, replace: {self}");
    return true;
}, true, EFFECT_INTERVAL_RANDOM);
