//
//  ViewController.swift
//  ios_Homework2
//
//  Created by Rafał Kwiatkowski on 20/03/2019.
//  Copyright © 2019 Rafał Kwiatkowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var scrollView: InfiniteCityScrollView { return view as! InfiniteCityScrollView }
    var moon: MoonView?
    var moonPositionFromOffsetX: CGFloat = 100
    var grabOffset = CGVector()
    
    override func loadView() {
        self.view = InfiniteCityScrollView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        moon = MoonView(frame: CGRect(origin: CGPoint(x: self.scrollView.contentOffset.x + moonPositionFromOffsetX, y: 50), size: CGSize(width: 100, height: 100)))
        view.addSubview(moon!)
        let moveMoonGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        moon!.addGestureRecognizer(moveMoonGesture)
        scrollView.sendSubviewToBack(moon!)
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calculateMoonPosFromOffset()

    }
    
    private func positionMoon(){
        moon?.center.x = scrollView.contentOffset.x + moonPositionFromOffsetX
    }
    
    private func calculateMoonPosFromOffset() {
        moonPositionFromOffsetX = moon!.center.x - scrollView.contentOffset.x
    }

    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer){
        guard let moon = gesture.view else { return }
        
        switch gesture.state {
        case .began:
            let grabPoint = gesture.location(in: view)
            let circleCenter = moon.center
            grabOffset = CGVector(dx: grabPoint.x - circleCenter.x, dy: grabPoint.y - circleCenter.y)
            self.view.bringSubviewToFront(moon)
            UIView.animate(withDuration: 0.2) {
                moon.alpha = 0.5
                moon.transform = .init(scaleX: 1.2, y: 1.2)
            }
        case .changed:
            let touchLocation = gesture.location(in: self.view)
            moon.center = CGPoint(x: touchLocation.x - grabOffset.dx, y: touchLocation.y - grabOffset.dy)
        case .ended, .cancelled:
            calculateMoonPosFromOffset()
            UIView.animate(withDuration: 0.2, animations: {
                moon.alpha = 1
                moon.transform = .identity
            }, completion: {_ in self.scrollView.sendSubviewToBack(moon)})
            
        default:
            break
        }
    
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        positionMoon()
    }
}


