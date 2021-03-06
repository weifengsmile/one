//
//  BaseNavigationViewController.swift
//  one
//
//  Created by sidney on 2021/3/21.
//

import UIKit

class BaseNavigationViewController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.green]
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("willshow\(viewControllers.count)")
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("didshow\(viewControllers.count)")
        // 这里也可以根据vc来赋予或者移除右滑返回手势
        // 在首页时，右滑呼出抽屉
        appDelegate.rootVc?.drawerVc.enableOpenLeftVc = viewControllers.count == 1
    }
    
    // 必须在首页禁用边缘手势，否则在呼出抽屉vc后，无法再push其他vc
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return children.count > 1
    }
}
