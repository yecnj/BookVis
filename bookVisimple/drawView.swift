//
//  drawView.swift
//  bookVisimple
//
//  Created by ivader on 2018. 7. 6..
//  Copyright © 2018년 yeonj. All rights reserved.
//

import UIKit
class DrawingView : UIImageView {
    var lastPoint : CGPoint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        super.touchesEstimatedPropertiesUpdated(touches)
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            drawLine(from: lastPoint, to: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    func drawLine(from lastPoint : CGPoint, to newPoint : CGPoint) {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.image?.draw(in: self.bounds)
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: lastPoint)
        context?.addLine(to: newPoint)
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(10)
        context?.setStrokeColor(UIColor(displayP3Red: 0.97, green: 1, blue: 0, alpha: 0.15).cgColor)
        
        context?.strokePath()
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func clear() {
        self.image = nil
    }
}
