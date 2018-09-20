# StateAnimator

![asset](https://user-images.githubusercontent.com/17644241/29022279-e8406798-7b68-11e7-8511-5f38ef99b2a7.gif)

## Purpose
An example to demonstrate that complex animations can be expressed and composed unsing a simpler API, in Swift. 
Note: Explain the problem that it solves.

## How does it work? 

### Some Definitions

A __Component__ is UIView that contains subviews. (i.e Button)

A __Subcomponent__ is subview of the __Component__. (i.e Label of a Button)

### Basic idea

The states of a __Component__ are made up of the states of its __Subcomponents__. Thus to define a __Component__ state, one needs to define the states of its __Subcomponents__.

State_1 = Subcomp_1_state_1 + Subcomp_2_state_1 + ...

State_2 = Subcomp_1_state_2 + Subcomp_2_state_2 + ...

"+" denotes composition.

### Some Definitions 
A __Subcomponent__ state is defined by a 'Transition' struct.

A __Component__ state is defined by a collection of 'Transition' structs. 

The 'Transition' struct looks like this:

```swift
struct Transition {
    let beforeTransition: (() -> ())?
    let afterTransition:  (() -> ())?
    let endState: () -> ()
    let animationDetails: AnimationDetails
}
```

Once two __Component__ states have been defined, the transition between them can be animated. 

Before the animation takes place, the __Component__ state needs to be converted into an __Animator__, internally.

```swift
struct Animator {
    let beforeTransitions: [() -> ()]
    let propertyAnimator: UIViewPropertyAnimator
}
```

__Animators__ are then passed to the __StateAnimator__, that starts the animation immediately.

For more information please consult the code.

# Installation

Requires cocoapods. Run ```pod install```

# Requirements

iOS 10

# Image Links

New York: http://wallpaperswide.com/new_york_city_buildings-wallpapers.html

Background: http://www.idownloadblog.com/2014/09/10/new-ios-8-wallpapers/

# License

MIT License
