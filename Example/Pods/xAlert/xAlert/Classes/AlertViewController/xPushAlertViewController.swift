//
//  xPushAlertViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/18.
//

import xKit
import xExtension

open class xPushAlertViewController: xViewController {
    
    // MARK: - IBOutlet Property
    /// 弹窗容器
    @IBOutlet public weak var content: UIView!
    /// 弹窗容器底部距离
    @IBOutlet public weak var contentBottomLayout: NSLayoutConstraint!
    
    // MARK: - Override Property
    open override var typeEmoji: String { return "🎉" }
    
    // MARK: - Public Property
    public var isAutoDismiss = true
    
    // MARK: - Override Func
    open override class func xDefaultViewController() -> Self {
        let vc = Self.xNew(xib: nil)
        return vc
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.isHidden = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isAutoDismiss {
            self.dismiss()
        }
    }
    
    // MARK: - 显示弹窗
    /// 显示弹窗
    /// - Parameters:
    ///   - animeType: 动画类型
    ///   - isSpring: 是否开启弹性动画
    open func display(isSpring : Bool = true)
    {
        let screenH = UIScreen.main.bounds.height
        if self.content.isEqual(self.contentBottomLayout.firstItem) {
            self.contentBottomLayout.constant = screenH
        }
        else {
            self.contentBottomLayout.constant = -screenH
        }
        self.view.layoutIfNeeded()
        self.view.isHidden = false
        if isSpring {
            let damping = CGFloat(0.75)  // 弹性阻尼,越小效果越明显
            let velocity = CGFloat(0) // 弹性初始速度,越大一开始变动越快
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .curveEaseInOut, animations: {
                self.contentBottomLayout.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        else {
            UIView.animate(withDuration: 0.25, animations: {
                self.contentBottomLayout.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - 隐藏弹窗
    /// 背景关闭
    @IBAction func closeBtnClick()
    {
        self.dismiss()
    }
     
    /// 隐藏弹窗
    /// - Parameters:
    ///   - animeType: 动画类型
    open func dismiss()
    {
        let screenH = UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.25, animations: {
            self.contentBottomLayout.constant = screenH
            self.view.layoutIfNeeded()
            
        }, completion: {
            (finish) in
            self.view.isHidden = true
        })
    }
    
}
