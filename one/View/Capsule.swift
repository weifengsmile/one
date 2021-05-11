//
//  Capsule.swift
//  one
//
//  Created by sidney on 2021/5/9.
//

import UIKit

class Capsule: UIView {
    
    var text = ""
    var textColor = UIColor.lightText
    var bkgColor = UIColor.white
    var borderColor = UIColor.white
    
    convenience init(text: String, bkgColor: UIColor, borderColor: UIColor, textColor: UIColor) {
        self.init()
        self.text = text
        self.bkgColor = bkgColor
        self.textColor = textColor
        self.borderColor = borderColor
    }
    
    override func draw(_ rect: CGRect) {
        let width = self.layer.bounds.width
        let height = self.layer.bounds.height
        let circleRadius = height / 2
        let path = UIBezierPath()
        let leftTop = CGPoint(x: circleRadius, y: 0)
        let rightTop = CGPoint(x: width - circleRadius, y: 0)
        let leftCenter = CGPoint(x: leftTop.x, y: height / 2)
        let rightCenter = CGPoint(x: rightTop.x, y: height / 2)
        let leftBottom = CGPoint(x: leftTop.x, y: height)
        path.move(to: leftTop)
        path.addLine(to: rightTop)
        // 左手坐标系，与数学常见坐标系的y轴方向相反
        path.addArc(withCenter: rightCenter, radius: circleRadius, startAngle: .pi * 3 / 2, endAngle: .pi / 2, clockwise: true)
        path.addLine(to: leftBottom)
        path.addArc(withCenter: leftCenter, radius: circleRadius, startAngle: .pi / 2, endAngle: .pi * 3 / 2, clockwise: true)
        path.close()
        path.lineWidth = 1
        borderColor.setStroke()
        path.stroke()
        bkgColor.setFill()
        path.fill()
        
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        self.backgroundColor = .clear
    }
}