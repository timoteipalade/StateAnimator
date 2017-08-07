# StateAnimator

## Purpose
An example to demonstrate that complex animations can be expressed and composed unsing a simple API. 

## How does it work? 

### Basic idea
The fundamental idea is that the states of the component are made up of the states of the subcomponents. Thus to define a component state, one needs to define the state of its subcomponents. Example:

State_1 = Subcomp_1_state_1 + Subcomp_2_state_1 + ...

State_2 = Subcomp_1_state_2 + Subcomp_2_state_2 + ...
...

"+" denotes composition.

The transitions between these states should be animated. Therefore more information, than just the state is required. Animation details are also required. 

### Implementation details

The 'Transition' struct captures all the state and state transition information. 

```
struct Transition {
    let beforeTransition: (() -> ())?
    let afterTransition:  (() -> ())?
    let endState: () -> ()
    let animationDetails: AnimationDetails
}
```

A Subcomponent State is defined by a 'Transition' object. A Component State is defined by an array of 'Transition' objects (all the states of the subcomponents). 

Component States, that is arrays of transitions, are then converted to Animators. 

```
struct Animator {
    let beforeTransitions: [() -> ()]
    let propertyAnimator: UIViewPropertyAnimator
}
```

(This particular implementation uses the UIViewPropertyAnimator to handle the actual animations.)

Animators can then be used to animate the transition between states. Here is some sample code of how that is done. 

```
    func generateState(state: ComponentState) -> [Transition]{
        
        switch state {
        case .collapsed:
            return self.firstView_setCollapsed(currentState: currentState) + self.secondView_setCollapsed(currentState: currentState)
        case .expanded:
            return self.firstView_setExpanded(currentState: currentState) + self.secondView_setExpanded(currentState: currentState)
        case .fullyExpanded:
            return self.firstView_setFullyExpanded(currentState: currentState) + self.secondView_setFullyExpanded(currentState: currentState)
        case .notSet:
            return []
        }
        
    }
    
    //To Do: Cache animators that have already been generated.
    func generateAnimators(state: ComponentState) -> [Animator] {
        
        return StateAnimator.generateAnimators(state: generateState(state: state), parentView: self.view)
    }
func animateToState(state: ComponentState) {
        guard state != currentState else {
            return
        }
    
        StateAnimator.animate(animators: generateAnimators(state: state))
        
        currentState = state
    }
```




# Installation

Requires cocoapods. Run ```pod install```
