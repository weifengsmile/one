//
//  Animation2TableViewCell.swift
//  one
//
//  Created by sidney on 2021/3/29.
//

import UIKit

class Animation2TableViewCell: AnimationTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.text = "旋转+缩小"
        tips = "CGAffineTransform.identity.rotated.scaledBy"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func start() {
        UIView.animate(withDuration: 3) {
            self.targetView.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi / 3)).scaledBy(x: 0.8, y: 0.8)
        } completion: { (result) in
            
        }

    }
    
    override func reset() {
        self.targetView.transform = .identity
    }
}
