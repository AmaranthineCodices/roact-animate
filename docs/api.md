## Library functions
These functions are members of the `RoactAnimate` table that is returned by the root module.

### RoactAnimate.Animate
```lua
RoactAnimate.Animate(value: Value<T>, tweenInfo: TweenInfo, goal: T)
```
`Animate` creates a new `Animation` that animates `value` to `goal`, using `tweenInfo` to control the motion of the animation.

This function has a shorthand: the `RoactAnimate` table itself may be substituted for `RoactAnimate.Animate`.

### RoactAnimate.Sequence
```lua
RoactAnimate.Sequence(animations: Array<Animation>) -> Animation
```
`Sequence` creates a new `Animation` that plays its child animations in sequential order.

### RoactAnimate.Parallel
```lua
RoactAnimate.Parallel(animations: Array<Animation>) -> Animation
```
`Parallel` creates a new `Animation` that plays all of its child animations at once.

### RoactAnimate.Prepare
```lua
RoactAnimate.Prepare<T>(value: Value<T>, goal: T) -> Animation
```
`Prepare` creates a new `Animation` that instantly completes when played. Use it to reset a `Value` to a starting point prior to an animation.

### RoactAnimate.Value
`Value` represents an animateable Lua value. You can create a `Value` with `Value.new`; this constructor takes a starting value as its only argument.

```lua
Value.new<T>(defaultValue: T) -> Value<T>
```

### Built-in animated components
Roact-Animate supplies the following class names as built-in animated components:

* RoactAnimate.Frame
* RoactAnimate.ScrollingFrame
* RoactAnimate.TextLabel
* RoactAnimate.TextButton
* RoactAnimate.TextBox
* RoactAnimate.ImageLabel
* RoactAnimate.ImageButton

### RoactAnimate.makeAnimatedComponent
```lua
makeAnimatedComponent(className: string) -> Component
```

`makeAnimatedComponent` makes an animatable component from a class name. The component can then be used in `createElement` as any other animated component. This function is provided to allow you to fill in gaps in Roact-Animate's coverage.

!!! warning
    `makeAnimatedComponent` should not be called in `render`; this can cause serious performance loss. Make sure you only run `makeAnimatedComponent` once; don't repeatedly call it every time you re-render.

## Animation
An `Animation` is created by calling `Animate`, `Sequence`, `Parallel`, or `Prepare`.

### Animation:Start
```lua
Animation:Start()
```

Starts playing the animation. If an animation was already using a `Value` before, that animation is cancelled.