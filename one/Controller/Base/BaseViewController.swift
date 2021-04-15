//
//  BaseViewController.swift
//  one
//
//  Created by sidney on 2021/3/20.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var navigationView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setCustomNav() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(STATUS_BAR_HEIGHT)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(44)
        }
        navigationView.backgroundColor = UIColor.main
        let leftView = UIView()
        navigationView.addSubview(leftView)
        leftView.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(0)
            maker.width.equalTo(80)
            maker.height.equalTo(44)
        }
        let leftArrowImageView = UIImageView()
        leftArrowImageView.image = UIImage(named: "back")
        leftView.addSubview(leftArrowImageView)
        leftArrowImageView.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.width.equalTo(36)
            maker.height.equalTo(28)
            maker.leading.equalToSuperview().offset(8)
        }
        leftArrowImageView.isUserInteractionEnabled = true
        let backRecognizer = UITapGestureRecognizer(target: self, action: #selector(back))
        leftArrowImageView.addGestureRecognizer(backRecognizer)
        
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = .white
            navigationView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (maker) in
                maker.center.equalToSuperview()
            }
        }
    }
    
    func setNavigation() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.clear // 如果设置了颜色，顶部的Nav Bar就会显示对应的颜色
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("---deinit---:\(self)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("收到了内存警告")
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

