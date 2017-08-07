//
//  ViewController.swift
//  StateAnimator
//
//  Created by Tim Palade on 8/3/17.
//  Copyright © 2017 Tim Palade. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    //Define states for first view
    
    func firstView_setCollapsed(currentState: ComponentState) -> [Transition] {
        
        let transition = Transition(endState: {
            self.firstView.snp.remakeConstraints({ (make) in
                make.center.equalTo(self.view)
                make.height.equalTo(self.view.bounds.height/1.8)
                make.width.equalTo(self.view.bounds.width * 3/4)
            })
            
            self.firstView.layer.shadowColor = UIColor.black.cgColor
            self.firstView.layer.shadowOffset = CGSize(width: 0, height: 4)
            self.firstView.layer.shadowOpacity = 0.4
            self.firstView.layer.shadowRadius = CGFloat(5)
            
            self.firstView.layer.cornerRadius = 4
        }, animationDetails: AnimationDetails(duration: 0.2, curve: .easeOut))
        
        return [transition]
    }
    
    func firstView_setExpanded(currentState: ComponentState) -> [Transition] {
        
        let move_transition = Transition(endState: {
            self.firstView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.view).inset(100)
                make.centerX.equalTo(self.view)
                make.height.equalTo(self.view.bounds.height/1.8)
                make.width.equalTo(self.view.bounds.width * 3/4)
            })
            
            self.firstView.layer.shadowColor = UIColor.black.cgColor
            self.firstView.layer.shadowOffset = CGSize(width: 0, height: 20)
            self.firstView.layer.shadowOpacity = 0.4
            self.firstView.layer.shadowRadius = CGFloat(20)
            
            self.firstView.layer.cornerRadius = 4
            
        }, animationDetails: AnimationDetails(duration: 0.1, curve: .easeInOut))
        
        
        return [move_transition]
    }
    
    func firstView_setFullyExpanded(currentState: ComponentState) -> [Transition] {
        
        let move_transition = Transition(endState: {
            self.firstView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.view)
                make.left.right.equalTo(self.view)
                make.height.equalTo(200)
            })
            
            self.firstView.layer.shadowColor = UIColor.clear.cgColor
            self.firstView.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.firstView.layer.shadowOpacity = 0.0
            self.firstView.layer.shadowRadius = CGFloat(0)
            
            self.firstView.layer.cornerRadius = 0
            
        }, animationDetails: AnimationDetails(duration: 0.2, curve: .easeInOut))
        
        
        return [move_transition]
    }
    
    //Define states for the second view
    
    func secondView_setCollapsed(currentState: ComponentState) -> [Transition] {
        
        let transition = Transition(endState: {
            self.secondView.snp.remakeConstraints({ (make) in
                make.center.equalTo(self.view)
                make.height.equalTo(self.view.bounds.height/1.8)
                make.width.equalTo(self.view.bounds.width * 3/4)
            })
            
            self.secondView.layer.cornerRadius = 4
            self.secondView.animateToState(state: .collapsed)
            
        }, animationDetails: AnimationDetails(duration: 0.22, curve: .linear))
        
        return [transition]
    }
    
    func secondView_setExpanded(currentState: ComponentState) -> [Transition] {
        let transition = Transition(endState: {
            self.secondView.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(self.view)
                make.top.equalTo(self.view).inset(140)
                make.height.equalTo(self.view.bounds.height/1.5)
                make.width.equalTo(self.view.bounds.width * 9/10)
            })
            
            self.secondView.layer.cornerRadius = 10
            self.secondView.animateToState(state: .expanded)
            
        }, animationDetails: AnimationDetails(duration: 0.2, curve: .easeInOut))
        
        return [transition]
    }
    
    func secondView_setFullyExpanded(currentState: ComponentState) -> [Transition] {
        
        let transition = Transition(endState: {
            self.secondView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.view).inset(200)
                make.left.right.bottom.equalTo(self.view)
            })
            
            self.secondView.layer.cornerRadius = 0
            self.secondView.animateToState(state: .fullyExpanded)
            
        }, animationDetails: AnimationDetails(duration: 0.2, curve: .easeInOut))
        
        return [transition]
    }
    
    
    let firstView = UIView()
    let secondView = BackView()
    
    
    enum ComponentState {
        case expanded
        case collapsed
        case fullyExpanded
        case notSet
    }
    
    var currentState: ComponentState = .notSet
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        firstView.backgroundColor = UIColor.clear
        secondView.backgroundColor = UIColor.white
        
        view.addSubview(secondView)
        view.addSubview(firstView)
        
        setConstraints()
        
        let childView = UIImageView()
        childView.image = UIImage(named: "newYork")
        childView.contentMode = .center
        childView.clipsToBounds = true
        childView.layer.masksToBounds = true
        childView.layer.cornerRadius = 4
        
        firstView.clipsToBounds = false
        firstView.addSubview(childView)
        childView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.firstView)
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    func tapped(_ sender: Any) {
        debugPrint("tapped")
        
        if currentState == .collapsed {
            animateToState(state: .expanded)
        }
        else if currentState == .expanded {
            if counter % 2 == 0 {
               animateToState(state: .fullyExpanded)
            }
            else {
                animateToState(state: .collapsed)
            }
            counter += 1
        }
        else if currentState == .fullyExpanded {
            animateToState(state: .expanded)
        }
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

