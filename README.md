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

```swift
struct Transition {
    let beforeTransition: (() -> ())?
    let afterTransition:  (() -> ())?
    let endState: () -> ()
    let animationDetails: AnimationDetails
}
```

A __Subcomponent State__ is defined by a 'Transition' object. A __Component State__ is defined by an array of 'Transition' objects. 

Subcomponent State Example: 
```swift
    //return [Transition] for easy composition like: [Transition] + [Transition]
    func firstView_setCollapsed(currentState: ComponentState) -> [Transition] {
        
        let transition = Transition(endState: {
            self.firstView.snp.remakeConstraints({ (make) in
               //...
            })
            
            self.firstView.layer. ... = ...
       
        }, animationDetails: AnimationDetails(duration: 0.2, curve: .easeOut))
        
        return [transition]
    }
```

Component State Example: 

```swift
    func generateState(state: ComponentState) -> [Transition]{
        
        switch state {
        case .collapsed:
            //self.firstView_setCollapsed(currentState: currentState) returns [Transition]
            //so does self.secondView_setCollapsed(currentState: currentState) 
            return self.firstView_setCollapsed(currentState: currentState) + self.secondView_setCollapsed(currentState: currentState)
        ...
    }
```

__Component States__, that is arrays of transitions, are then converted to __Animators__. 

```swift
struct Animator {
    let beforeTransitions: [() -> ()]
    let propertyAnimator: UIViewPropertyAnimator
}
```

(This particular implementation uses the UIViewPropertyAnimator to handle the actual animations.)

__Animators__ can then be used to animate the transition between states. Here is some sample code of how that is done. 

```swift
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

Whenever a transition is necessary the animateToState method is called. 

# Installation

Requires cocoapods. Run ```pod install```
