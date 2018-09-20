# StateAnimator

![asset](https://user-images.githubusercontent.com/17644241/29022279-e8406798-7b68-11e7-8511-5f38ef99b2a7.gif)

## Purpose
More complex animations between the states of a component, like a button, can be cumbersome to create in Swift. The code is usually spread around multiple animation blocks. This is an attempt to modularize the code, and make writing complex animations simpler. Note: It still needs some work to hide some of the complexity. 

## How does it work? 

### Basic idea

The states of a __View__ are made up of the states of its __Subviews__. For example, think of the states of a button. One state can have a blue label, and a black outer border, while another state of the same button can have a red label and a white outer border. In a more mathematical notation that would translate to:

State_1 = Subcomp_1_state_1 + Subcomp_2_state_1 + ...

State_2 = Subcomp_1_state_2 + Subcomp_2_state_2 + ...

"+" denotes composition.

We need a way to encapsulate this information. What is there to encapsulate? First, the information about each __Subviews__ for a certain __View__ state. And then the information about a __View__ state. 

I chose to encapsulate the information about a __Subviews__ in a 'Transition' struct:

```swift
struct Transition {
    let beforeTransition: (() -> ())?
    let afterTransition:  (() -> ())?
    let endState: () -> ()
    let animationDetails: AnimationDetails
}
```

The naming might be a bit confusing, I am sorry for that. The most important piece of info in a 'Transition' is the endState. The endState describes the look of that subcomponent for a certain __View__ state. For example: If we have a __View__ state, let's call it View_State_1, then the endState should contain the information about how that __Subviews__ is supposed to look like when the view is in View_State_1. 

Once the __Subviews__ states are defined for a certain __View__ state, then we can put them together to describe the state of the __View__. So we can form a collection of 'Transition' structs and call that the __View__ state. Maybe a bit of notation will make it clearer: 

Subview_State_1 = Transition1
Subview_State_2 = Transition2

View_State = [Transition1, Transition2]

Once we have 2 __View__ states, say View_State_1 and View_State_2, we can animate the transition between View_State_1 and View_State_2. 

Before the animation takes place, each __View__ state needs to be converted into an __Animator__. This is an internal detail, which should be hidden in the future. But it is good to know about it if you want to understand how this works.

```swift
struct Animator {
    let beforeTransitions: [() -> ()]
    let propertyAnimator: UIViewPropertyAnimator
}
```

__Animators__ are then passed to the __StateAnimator__, who starts the animation immediately.

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
