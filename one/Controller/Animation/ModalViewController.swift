//
//  ModalViewController.swift
//  one
//
//  Created by sidney on 2021/4/15.
//

import UIKit

class ModalViewController: BaseViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewTop: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeading: NSLayoutConstraint!
    var newVc = BaseViewController()
    let leftBarViewWidth: CGFloat = 44
    var hasFold = false
    lazy var leftBarView: UIView = {
        let _leftBarView = UIView(frame: CGRect(x: -leftBarViewWidth, y: 0, width: leftBarViewWidth, height: SCREEN_HEIGHT))
        _leftBarView.backgroundColor = .white
        return _leftBarView
    }()
    lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = .black
        btn.setTitle("", for: .normal)
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()
    lazy var leftViewBackBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = .black
        btn.setTitle("", for: .normal)
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "转场方式"
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        setupLeftBar()
        setCustomNav(color: .clear)
        newVc.title = "new"
        newVc.view.backgroundColor = .systemBackground
        newVc.enterType = .present
        newVc.setCustomNav()
    }
    
    func setupLeftBar() {
        leftBarView.alpha = 0
        self.view.addSubview(leftBarView)
        leftBarView.addSubview(leftViewBackBtn)
        leftViewBackBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(STATUS_BAR_HEIGHT + 10)
        }
        let textLabel = UILabel()
        textLabel.text = "毒"
        textLabel.adjustsFontSizeToFitWidth = true
        leftBarView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-44)
        }
    }
    
    override func setStatusBar(color: UIColor = UIColor.main) {
        contentView.addSubview(statusBarView)
        statusBarView.backgroundColor = color
        statusBarView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.height.equalTo(STATUS_BAR_HEIGHT)
        }
    }
    
    override func setCustomNav(color: UIColor = UIColor.main) {
        setStatusBar(color: color)
        contentView.addSubview(navigationView)
        navigationView.snp.makeConstraints { (maker) in
            maker.top.equalTo(statusBarView.snp.bottom)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(44)
        }
        navigationView.backgroundColor = color
        let leftView = UIView()
        navigationView.addSubview(leftView)
        leftView.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(0)
            maker.width.equalTo(80)
            maker.height.equalTo(44)
        }
        leftView.addSubview(backBtn)
        backBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(16)
        }
        backBtn.isUserInteractionEnabled = true
        
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = .black
            navigationView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (maker) in
                maker.center.equalToSuperview()
            }
        }
    }
    
    override func back() {
        if hasFold {
            unFoldContentView()
            return
        }
        super.back()
    }

    @IBAction func coverVertical(_ sender: UIButton) {
        newVc.enterType = .present
        newVc.modalTransitionStyle = .coverVertical
        self.present(newVc, animated: true, completion: nil)
    }
    
    @IBAction func flipHorizontal(_ sender: UIButton) {
        newVc.enterType = .present
        newVc.modalTransitionStyle = .flipHorizontal
        self.present(newVc, animated: true, completion: nil)
    }

    @IBAction func crossDissolve(_ sender: UIButton) {
        newVc.enterType = .present
        newVc.modalTransitionStyle = .crossDissolve
        self.present(newVc, animated: true, completion: nil)
    }
    
    @IBAction func partialCurl(_ sender: UIButton) {
        newVc.enterType = .push
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
//        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(newVc, animated: false)
    }
    
    @IBAction func fromBottom(_ sender: UIButton) {
        newVc.enterType = .push
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(newVc, animated: false)
    }
    @IBAction func fold(_ sender: UIButton) {
        hasFold = true
        self.foldContentView()
    }

    func foldContentView() {
        let oldFrame = self.contentView.frame
        self.contentView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.contentView.frame = oldFrame
//        self.contentView.setNeedsUpdateConstraints()
        leftBarView.alpha = 1
        UIView.animate(withDuration: 0.5) {
            self.leftBarView.frame.origin.x += self.leftBarViewWidth
            self.contentView.frame.origin.x += self.leftBarViewWidth
        } completion: { (result) in
//            let transform3D: CATransform3D = CATransform3DMakeRotation(CGFloat.pi / 2.5, 0, 1, 0)
//            let transform = self.CATransform3DPerspect(t: transform3D, center: .zero, idz: 500)
//            let animation = CABasicAnimation(keyPath: "transform")
//            animation.toValue = NSValue(caTransform3D: transform)
//            animation.duration = 2
//            self.contentView.layer.add(animation, forKey: "transform")
            self.contentView.backgroundColor = .white
            UIView.animate(withDuration: 2) {
                self.contentView.backgroundColor = .lightGray
                let transform3D: CATransform3D = CATransform3DMakeRotation(CGFloat.pi / 2.5, 0, 1, 0)
                self.contentView.layer.transform = self.CATransform3DPerspect(t: transform3D, center: .zero, idz: 600)
            } completion: { (result) in
            }
        }

        
    }
    
    func unFoldContentView() {
        UIView.animate(withDuration: 2) {
            self.contentView.backgroundColor = .white
            let transform3D: CATransform3D = CATransform3DMakeRotation(0, 0, 1, 0)
            self.contentView.layer.transform = self.CATransform3DPerspect(t: transform3D, center: .zero, idz: 600)
        } completion: { (result) in
            UIView.animate(withDuration: 0.5) {
                self.leftBarView.frame.origin.x -= self.leftBarViewWidth
                self.contentView.frame.origin.x -= self.leftBarViewWidth
            } completion: { (result) in
                self.hasFold = false
                self.leftBarView.alpha = 0
            }
        }
    }
    
    func CATransform3DMakePerspective(center:CGPoint, idz:CGFloat) -> CATransform3D {
        let transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0)
        let transback = CATransform3DMakeTranslation(center.x, center.y, 0)
        var scale = CATransform3DIdentity
        scale.m34 = -1.0 / idz
        return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transback)
    }

    func CATransform3DPerspect(t:CATransform3D, center:CGPoint, idz:CGFloat) -> CATransform3D {
        return CATransform3DConcat(t, CATransform3DMakePerspective(center: center, idz: idz))
    }
}
