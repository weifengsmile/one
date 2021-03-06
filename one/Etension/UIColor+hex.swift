//
//  UIColor+hex
//  diyplayer
//
//  Created by sidney on 2019/7/3.
//  Copyright © 2019年 sidney. All rights reserved.
//
import UIKit

extension UIColor {
    static func colorWithHexString(_ color: String, alpha: CGFloat = 1) -> UIColor {
        var cString: NSString = color.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() as NSString
        if (cString.length < 6) {
            return UIColor.clear
        }
        
        if (cString.hasPrefix("0X")) {
            cString = cString.substring(from: 2) as NSString
        }
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: 1) as NSString
        }
        
        if (cString.length != 6) {
            return UIColor.clear
        }
        
        var range: NSRange = NSRange(location: 0, length: 2)
        //r
        let rString: String = cString.substring(with: range)
        //g
        range.location = 2
        let gString: String = cString.substring(with: range)
        //b
        range.location = 4
        let bString: String = cString.substring(with: range)
        
        var red: UInt64 = 0
        var green: UInt64 = 0
        var blue: UInt64 = 0
        Scanner(string: rString).scanHexInt64(&red)
        Scanner(string: gString).scanHexInt64(&green)
        Scanner(string: bString).scanHexInt64(&blue)
        
        return UIColor(red: (CGFloat(red) / 255.0), green: (CGFloat(green) / 255.0), blue: (CGFloat(blue) / 255.0), alpha: alpha)
    }
}

extension UIColor {
    
    static func tabbarColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark ? UIColor.white : UIColor.main
            }
        }
        else { return UIColor.main }
    }
    
    static var main: UIColor {
        // #FF6E82
        // #0396FF
        return colorWithHexString("#0396FF")
    }
    
    /// #8a8a8a
    static var tabBarGray: UIColor {
        return colorWithHexString("#8a8a8a")
    }

    /// #dddddd
    static var tableLineColor: UIColor {
        return colorWithHexString("#dddddd")
    }
    
    /// #aaaaaa
    static var gray4: UIColor {
        return colorWithHexString("#F5F5F5")
    }
    
    static var titleGray: UIColor {
        return colorWithHexString("#212121")
    }
    
    static var noteBlueIcon: UIColor {
        return colorWithHexString("#6c99af")
    }
    
    static var noteTextRed: UIColor {
        return colorWithHexString("#ff4848")
    }
    
    static var noteTextGray: UIColor {
        return colorWithHexString("3f3f3f")
    }
    
    static var scheduleMapBkg: UIColor {
        return colorWithHexString("#000000", alpha: 0.1)
    }
    
    static var scheduleMapPositionBkg: UIColor {
        return colorWithHexString("#212121", alpha: 0.7)
    }
    
    static var scheduleMapBorderGray: UIColor {
        return colorWithHexString("#6c99af")
    }
    
    /// #dddddd
    static var tableLine: UIColor {
        return colorWithHexString("#dddddd")
    }
    
    /// #ffffff
    static var white1: UIColor {
        return colorWithHexString("#ffffff")
    }
    
    /// #000000 0.2
    static var mask: UIColor {
        return colorWithHexString("#000000", alpha: 0.2)
    }
    
    /// #aaaaaa
    static var disabledGray: UIColor {
        return colorWithHexString("#aaaaaa")
    }
    
    static var mainBkg: UIColor {
        return colorWithHexString("#453936")
    }
    
    static var cardColor1: UIColor {
        return colorWithHexString("#343a40")
    }
    
    static var cardColor2: UIColor {
        return colorWithHexString("#adb5bd")
    }
    
    static var gray1: UIColor {
        return colorWithHexString("#F0F0F0")
    }
}
