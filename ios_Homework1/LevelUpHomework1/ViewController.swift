//
//  ViewController.swift
//  LevelUpHomework1
//
//  Created by Rafał Kwiatkowski on 12/03/2019.
//  Copyright © 2019 Rafał Kwiatkowski. All rights reserved.
//

import UIKit

class ViewController : UIViewController, UIGestureRecognizerDelegate {
    
    let numberOfTapsToSpawnCircle = 2
    let numberOfTapsToRemoveCircle = 3
    let circleSize: CGFloat = 100
    var originCenter = CGPoint()
    
    var grabOffSets: [UIView : CGVector] = [:]
    
    let scaleUp = CGAffineTransform(scaleX: 1.25, y: 1.25)
    let scaleDown = CGAffineTransform(scaleX: 0.01, y: 0.01)
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.numberOfTapsRequired = numberOfTapsToSpawnCircle
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        let spawnedView = createCircle()
        spawnedView.center = tap.location(in: view)
        view.addSubview(spawnedView)
        spawnAnimation(view: spawnedView)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        spawnedView.addGestureRecognizer(longPress)
        let tripleTap = UITapGestureRecognizer(target: self, action: #selector(handleTripleTap(_:)))
        tripleTap.numberOfTapsRequired = numberOfTapsToRemoveCircle
        spawnedView.addGestureRecognizer(tripleTap)
        
    }
    
    private func createCircle() -> UIView {
        
        let spawnedView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: circleSize, height: circleSize)))
        spawnedView.backgroundColor = UIColor.randomBrightColor()
        spawnedView.layer.cornerRadius = circleSize * 0.5
        return spawnedView
    }
    
    @objc func handleLongPress(_ longPress: UILongPressGestureRecognizer){
        guard longPress.view != nil else {return}
        let circle = longPress.view!
        let translation = longPress.location(in: self.view)
        
        switch longPress.state {
        case .began:
            pickUpAnimation(view: circle)
            let grabOffSet = CGVector.init(dx: translation.x - circle.center.x, dy: translation.y - circle.center.y)
            self.grabOffSets[circle] = grabOffSet
            self.originCenter = circle.center
        case .changed:
            guard let grabOffSet = grabOffSets[circle] else {return}
            let newCenter = CGPoint(x: translation.x - grabOffSet.dx, y: translation.y - grabOffSet.dy)
            circle.center = newCenter
        case .ended, .cancelled:
            dropAnimation(view: circle)
            grabOffSets[circle] = nil
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if( gestureRecognizer is UITapGestureRecognizer && otherGestureRecognizer is UITapGestureRecognizer){
            if (gestureRecognizer as! UITapGestureRecognizer).numberOfTapsRequired == 2 &&
                (otherGestureRecognizer as! UITapGestureRecognizer).numberOfTapsRequired == 3{
                return true
            }
            
        }
        return false
    }
    
    @objc func handleTripleTap(_ tripleTap: UITapGestureRecognizer){
        guard tripleTap.view != nil else {return}
        let circle = tripleTap.view!
        removeAnimation(view: circle)
    }
    
    private func spawnAnimation(view: UIView){
        view.transform = .init(scaleX: 0.1, y: 0.1)
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            view.transform = self.scaleUp
        }
        animator.addCompletion { (position) in
            if position == .end {
                view.transform = .identity
            }
        }
        animator.startAnimation()
    }
    
    private func removeAnimation(view: UIView){
        let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut)
        animator.addAnimations {
            UIView.animateKeyframes(withDuration: 0.4, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                    view.transform = self.scaleUp
                })
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                    view.transform = self.scaleDown
                })
            }, completion: { (completed) in
                view.removeFromSuperview()
            })
        }
        animator.startAnimation()
    }
    
    private func pickUpAnimation(view: UIView){
        UIView.animate(withDuration: 0.3) {
            view.alpha = 0.5
            view.transform = self.scaleUp
        }
    }
    
    private func dropAnimation(view: UIView){
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
            view.transform = .identity        }
    }
    
    
}
extension CGFloat {
    static func random() -> CGFloat {
        return random(min: 0.0, max: 1.0)
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(max > min)
        return min + ((max - min) * CGFloat(arc4random()) / CGFloat(UInt32.max))
    }
}

extension UIColor {
    static func randomBrightColor() -> UIColor {
        return UIColor(hue: .random(),
                       saturation: .random(min: 0.5, max: 1.0),
                       brightness: .random(min: 0.7, max: 1.0),
                       alpha: 1.0)
    }
}
