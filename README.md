# StateAnimator

## Purpose
An example to demonstrate that complex animations can be expressed and composed unsing a simple API. 

## How does it work? 
The fundamental idea is that the states of the component are made up of the states of the subcomponents. Thus to define a component state, one needs to define the state of its subcomponents. Example:

Let's have a component, with 2 subcomponents. Assume that the subcomponents are simple UIViews. We want 2 states for our component. An exanded state and a collapsed state. For the expanded state the 2 subcomponents will have the following properties: 

Expanded state of the component:
UIView_1: height = width = 100, origin = (0,0), backgroundColor: blue, zIndex: 0
UIView_2: height = width = 200, origin = (0,0), backgroundColor: green, zIndex: -1

For the collapsed state they will have these properties: 

Collapsed state of the component:
UIView_1: height = width = 100, origin = (0,0), backgroundColor: blue, zIndex: 0
UIView_2: height = width = 200, origin = (0,0), backgroundColor: green, zIndex: -1

# Installation

Requires cocoapods. Run ```pod install```
