//
//  MainViewController.swift
//  one
//
//  Created by sidney on 5/10/21.
//

import UIKit

// 初始root vc
class MainViewController: UIViewController {

    let tabbarVc = CustomTabBarViewController()
    let leftVc = LeftDrawerViewController()
    let drawerVc = DrawerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("main didload")
        appDelegate.window?.rootViewController = drawerVc
        drawerVc.tabbarVc = tabbarVc
        drawerVc.leftVc = leftVc
        setNotification()
        CacheManager.shared.getRefreshHeaderImages()
    }
    
    @objc func gotoVc(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let vc = dict["vc"] as? UIViewController, let hideAll = dict["hideAll"] as? Bool {
                let drawVc = appDelegate.window?.rootViewController as? DrawerViewController
                drawVc?.closeLeftVcWithoutAnimation()
                if let topVc = getTopViewController() {
                    topVc.pushVc(vc: vc, hideAll: hideAll)
                }
            }
        }
    }
    
    func setNotification() {
        NotificationService.shared.listenGotoVc(target: self, selector: #selector(gotoVc(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("main willappear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("main didappear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        print("main willdisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        print("main diddisappear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        print("main willlayoutsubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("main didlayoutsubviews")
    }
}
