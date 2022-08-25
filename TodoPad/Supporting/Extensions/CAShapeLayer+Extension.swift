//
//  CAShapeLayer+Extension.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-25.
//

import UIKit

extension CAShapeLayer {
    
    func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor, view: UIView) {
        
       // TODO - Phone flip screen looks ugly right now
        var diameter = CGFloat(300)//CGFloat(414)*(120/207)//*0.6
        while diameter+25 > view.width { diameter -= 40 }
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: diameter/2, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        self.path = circularPath.cgPath
        self.fillColor = fillColor.cgColor
        self.strokeColor = strokeColor.cgColor
        self.lineWidth = 25
        self.lineCap = .butt
    }
}
