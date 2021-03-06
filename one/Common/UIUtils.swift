import UIKit

public func setAnchor(anchorPoint: CGPoint, forView: UIView) {
    let oldOrigin = forView.frame.origin
    forView.layer.anchorPoint = anchorPoint
    let newOrigin = forView.frame.origin
    var transition: CGPoint = .zero
    transition.x = newOrigin.x - oldOrigin.x
    transition.y = newOrigin.y - oldOrigin.y
    forView.center = CGPoint(x: forView.center.x - transition.x, y: forView.center.y - transition.y)
}

public func delay(_ delayTime: Double, closure: @escaping () -> ()) {
    let time = DispatchTime.now() + delayTime
    DispatchQueue.main.asyncAfter(deadline: time, execute: closure)
}

public func viewFromNib<T: UIView>(_ nibName: String) -> T {
    return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! T
}

public func registerNibWithName(_ nibName: String, tableView: UITableView) {
    tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    
}

public func registerNibWithName(_ nibName: String, collectionView: UICollectionView, kind: String) {
    collectionView.register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: nibName)
}

public func registerCellWithClass(_ clazz: AnyClass, tableView: UITableView) {
    tableView.register(clazz, forCellReuseIdentifier: "\(clazz.self)")
}

public func registerNibWithName(_ nibName: String, collectionView: UICollectionView) {
    collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
}

public func dequeueReusableCell(withIdentifier: String, tableView: UITableView) -> UITableViewCell? {
    if let cell = tableView.dequeueReusableCell(withIdentifier: withIdentifier) {
        return cell
    } else {
        registerNibWithName(withIdentifier, tableView: tableView)
        return tableView.dequeueReusableCell(withIdentifier: withIdentifier)
    }
}

public func getCuttingImage(_ size: CGSize, direction: UIRectCorner, cornerRadii: CGFloat, borderWidth: CGFloat, borderColor: UIColor, backgroundColor: UIColor) -> UIImage? {
    let width = size.width
    let height = size.height

    // ?????????CoreGraphics????????????????????????
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
    guard let currentContext = UIGraphicsGetCurrentContext() else {
        UIGraphicsEndImageContext()
        return nil
    }
    currentContext.setFillColor(backgroundColor.cgColor)// ??????????????????
    currentContext.setStrokeColor(borderColor.cgColor)// ??????????????????
    
    // ????????????
    if direction == UIRectCorner.allCorners {
        currentContext.move(to: CGPoint(x: width - borderWidth, y: cornerRadii + borderWidth))// ???????????????
        currentContext.addArc(tangent1End: CGPoint(x: width - borderWidth, y: height - borderWidth), tangent2End: CGPoint(x: width - cornerRadii - borderWidth, y: height - borderWidth), radius: cornerRadii)
        currentContext.addArc(tangent1End: CGPoint(x: borderWidth, y: height - borderWidth), tangent2End: CGPoint(x: borderWidth, y: height - cornerRadii - borderWidth), radius: cornerRadii)
        currentContext.addArc(tangent1End: CGPoint(x: borderWidth, y: borderWidth), tangent2End: CGPoint(x: width - borderWidth, y: borderWidth), radius: cornerRadii)
        currentContext.addArc(tangent1End: CGPoint(x: width - borderWidth, y: borderWidth), tangent2End: CGPoint(x: width - borderWidth, y:  cornerRadii + borderWidth), radius: cornerRadii)
    } else {
        currentContext.move(to: CGPoint.init(x: cornerRadii + borderWidth, y: borderWidth))// ???????????????
        if direction.contains(UIRectCorner.topLeft) {
            currentContext.addArc(tangent1End: CGPoint(x: borderWidth, y: borderWidth), tangent2End: CGPoint(x: borderWidth, y: cornerRadii + borderWidth), radius: cornerRadii)
        } else {
            currentContext.addLine(to: CGPoint.init(x: borderWidth, y: borderWidth))
        }
        if direction.contains(UIRectCorner.bottomLeft) {
            currentContext.addArc(tangent1End: CGPoint(x: borderWidth, y: height - borderWidth), tangent2End: CGPoint(x: borderWidth + cornerRadii, y: height - borderWidth), radius: cornerRadii)
        } else {
            currentContext.addLine(to: CGPoint(x: borderWidth, y: height - borderWidth))
        }
        if direction.contains(UIRectCorner.bottomRight) {
            currentContext.addArc(tangent1End: CGPoint(x: width - borderWidth, y: height - borderWidth), tangent2End: CGPoint(x: width - borderWidth, y: height - borderWidth - cornerRadii), radius: cornerRadii)
        } else {
            currentContext.addLine(to: CGPoint(x: width - borderWidth, y: height - borderWidth))
        }
        if direction.contains(UIRectCorner.topRight) {
            currentContext.addArc(tangent1End: CGPoint(x: width - borderWidth, y: borderWidth), tangent2End: CGPoint(x: width - borderWidth - cornerRadii, y: borderWidth), radius: cornerRadii)
        } else {
            currentContext.addLine(to: CGPoint(x: width - borderWidth, y: borderWidth))
        }
        currentContext.addLine(to: CGPoint(x: borderWidth + cornerRadii, y: borderWidth))
    }
    currentContext.drawPath(using: .fillStroke)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
}

func getTopViewController(base: UIViewController? = appDelegate.window?.rootViewController) -> UIViewController? {
    if let draw = base as? DrawerViewController {
        return getTopViewController(base: draw.tabbarVc)
    } else if let nav = base as? UINavigationController {
        return getTopViewController(base: nav.visibleViewController)
    } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
        return getTopViewController(base: selected)
    } else if let presented = base?.presentedViewController {
        return getTopViewController(base: presented)
    }
    
    return base
}

//public func getTargetControllerInNavStacks(target: AnyClass) -> UIViewController? {
//    let stackVcs: [UIViewController] = rootNavigationController?.children ?? []
//    for vc in stackVcs {
//        if vc.isKind(of: target) {
//            return vc
//        }
//    }
//    return nil
//}

public func getLabelHeight(text: String, font: UIFont, width: CGFloat, lineSpacing: CGFloat) -> CGFloat {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    if lineSpacing > 0.0 {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = .center
        label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: style])
    } else {
        label.text = text
    }
    label.sizeToFit()
    return label.frame.height
}

public func pt(_ px: CGFloat) -> CGFloat {
    return SCREEN_WIDTH * (px/375)
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
