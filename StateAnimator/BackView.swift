//
//  BackView.swift
//  StateAnimator
//
//  Created by Tim Palade on 8/3/17.
//  Copyright © 2017 Tim Palade. All rights reserved.
//

import UIKit

class BackView: UIView {
    
    //Label state
    
    func label_setCollapsed(currentState: ComponentState) -> [Transition] {
        
        let transition = Transition(endState: {
            
            self.label.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(self)
                make.bottom.equalTo(self).inset(40)
                make.left.equalTo(self).offset(20)
                make.right.equalTo(self).inset(20)
                make.height.equalTo(40)
            })
            
            self.label.alpha = 0.0
            self.label.isHidden = true
            
            self.label.textColor = UIColor.black
            
        }, animationDetails: AnimationDetails(duration: 0.2, curve: .linear))
        
        return [transition]
    }
    
    func label_setExpanded(currentState: ComponentState) -> [Transition] {
        
        let transition = Transition(endState: {
            
            self.label.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(self)
                make.bottom.equalTo(self).inset(40)
                make.left.equalTo(self).offset(20)
                make.right.equalTo(self).inset(20)
                make.height.equalTo(40)
            })
            
            self.label.isHidden = false
            self.label.alpha = 1.0
            
            self.label.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
            
        }, beforeTransition: {self.label.alpha = 0.0}, animationDetails: AnimationDetails(duration: 0.4, curve: .easeInOut))
        
        return [transition]
    }
    
    func label_setFullyExpanded(currentState: ComponentState, completion: @escaping () -> ()) -> [Transition] {
        
        let transition = Transition(endState: {
            let window_center_x = UIApplication.shared.windows.first!.center.x
            self.label.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(window_center_x)
                make.top.equalTo(self).offset(20)
                make.width.equalTo(self.label.frame.width)
                make.height.equalTo(40)
            })
            
            self.label.isHidden = false
            
            self.label.textColor = UIColor.black
            
        }, afterTransition: completion, animationDetails: AnimationDetails(duration: 0.2, curve: .easeInOut))
        
        return [transition]
    }
    
    //textViewState 
    
    func textView_setCollapsed(currentState: ComponentState) -> [Transition] {
        
        let transition = Transition(endState: {
            
            self.textView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.label.snp.bottom).offset(16)
                make.bottom.equalTo(self).inset(10)
                make.left.equalTo(self).offset(20)
                make.right.equalTo(self).inset(20)
            })
            
            self.textView.isHidden = true
            self.textView.alpha = 0.0
            
        }, animationDetails: AnimationDetails(duration: 0.2, curve: .linear))
        
        return [transition]
    }
    
    func textView_setExpanded(currentState: ComponentState) -> [Transition] {
        
        let transition = Transition(endState: {
            
            self.textView.isHidden = true
            self.textView.alpha = 0.0
            
        })
        
        return [transition]
    }
    
    func textView_setFullyExpanded(currentState: ComponentState) -> [Transition] {
        
        let transition = Transition(endState: {
            
            self.textView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.label.snp.bottom).offset(16)
                make.bottom.equalTo(self).inset(10)
                make.left.equalTo(self).offset(20)
                make.right.equalTo(self).inset(20)
            })
            self.textView.isHidden = false
            self.textView.alpha = 1.0
            
        }, animationDetails: AnimationDetails(duration: 0.1, curve: .easeIn))
        
        return [transition]
    }
    
    
    enum ComponentState {
        case collapsed
        case expanded
        case fullyExpanded
        case notSet
    }
    
    var currentState: ComponentState = .notSet
    
    let label = UILabel()
    let textView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        label.textAlignment = .center
        
        label.backgroundColor = UIColor.clear
        label.text = "New York"
        label.font = UIFont.systemFont(ofSize: 32, weight: 600)
        
        self.addSubview(textView)
        textView.text = "Lorem ipsum dolor sit amet conubia felis eros a. Diam lorem augue. Risus velit ornare duis luctus aenean id leo posuere non donec libero. Eget vel ultricies. Class elit tristique. Lectus etiam in amet vel cursus vivamus condimentum nunc. Auctor ac neque. A nec et. Etiam ornare natoque nunc nec id. Vel sociis odit auctor metus pede proin et in non convallis ultricies."

        textView.isEditable = false
        
        setConstraints()
    }
    
    func generateState(state: ComponentState) -> [Transition]{
        
        switch state {
        case .collapsed:
            return self.label_setCollapsed(currentState: currentState) + self.textView_setCollapsed(currentState: currentState)
        case .expanded:
            return self.label_setExpanded(currentState: currentState) + self.textView_setExpanded(currentState: currentState)
        case .fullyExpanded:
            return self.label_setFullyExpanded(currentState: currentState, completion: {
                StateAnimator.animate(animators: StateAnimator.generateAnimators(state: self.textView_setFullyExpanded(currentState: self.currentState), parentView: self))
            })
        case .notSet:
            return []
        }
        
    }
    
    //To Do: Cache animators that have already been generated.
    func generateAnimators(state: ComponentState) -> [Animator] {
        
        return StateAnimator.generateAnimators(state: generateState(state: state), parentView: self)
    }
    
    func setConstraints() {
        
        //Initial state is the collapsed state
        for state in StateAnimator.generateStates(transitions: generateState(state: .collapsed)) {
            state()
        }
        
        currentState = .collapsed
    }
    
    func animateToState(state: ComponentState) {
        guard state != currentState else {
            return
        }
        
        StateAnimator.animate(animators: generateAnimators(state: state))
        
        currentState = state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
