//
//  DraggableImage.swift
//  weather_app
//
//  Created by Petru-Alexandru Lipici on 10.01.2023.
//

import UIKit

class LongPressDraggableImage: UIImageView, UIGestureRecognizerDelegate {
    
    private var longPressTouchPosition: CGPoint?
    private var canPanImage: Bool {
        longPressTouchPosition != nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        
        addLongPressGesture()
        addPanGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressTriggered(_:)))
        longPressGesture.minimumPressDuration = 0.3
        longPressGesture.cancelsTouchesInView = false
        
        addGestureRecognizer(longPressGesture)
    }
    
    @objc private func longPressTriggered(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            longPressTouchPosition = sender.location(ofTouch: 0, in: self)
        } else if sender.state == .ended {
            longPressTouchPosition = nil
        }
    }
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureTriggered(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    @objc private func panGestureTriggered(_ sender: UIPanGestureRecognizer) {
        guard let initialTouch = longPressTouchPosition else { return }
        
        let location = sender.location(in: superview)
        
        self.frame.origin = CGPoint(x: location.x - initialTouch.x, y: location.y - initialTouch.y)
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard
            gestureRecognizer is UIPanGestureRecognizer,
            !canPanImage
        else { return false }
        
        return true
    }
}
