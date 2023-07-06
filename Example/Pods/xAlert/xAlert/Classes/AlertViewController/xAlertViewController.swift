//
//  xAlertViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/18.
//

import xKit
import xExtension

open class xAlertViewController: xViewController {

    // MARK: - Enum
    /// 弹窗显示动画样式
    public enum xAlertDisplayAnimeType {
        /// 淡化
        case fade
        /// 缩放
        case scale
        /// 随机
        case random
    }
    
    // MARK: - IBOutlet Property
    /// 弹窗容器
    @IBOutlet public weak var content: UIView!
    
    // MARK: - Override Property
    open override var typeEmoji: String { return "🎈" }
    
    // MARK: - Public Property
    public var isAutoDismiss = true
    
    // MARK: - Override Func
    open override class func xDefaultViewController() -> Self {
        let vc = Self.xNew(xib: nil)
        return vc
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
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
    open func display(animeType : xAlertDisplayAnimeType = .fade,
                      isSpring : Bool = true)
    {
        // 保存数据
        self.view.isHidden = false
        switch animeType {
        case .fade:
            self.content.alpha = 0
            self.content.transform = .identity
            UIView.animate(withDuration: 0.25, animations: {
                self.content.alpha = 1
            })
        case .scale:
            self.content.alpha = 1
            self.content.transform = .init(scaleX: 0, y: 0)
            if isSpring {
                let damping = CGFloat(0.7)  // 弹性阻尼，越小效果越明显
                let velocity = CGFloat(10) // 弹性修正速度，越大修正越快
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .curveEaseInOut, animations: {
                    self.content.transform = .identity
                })
            }
            else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.content.transform = .identity
                })
            }
        case .random:   // 随机递归
            let type = self.getRandmAnimeType()
            self.display(animeType: type, isSpring: isSpring)
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
    open func dismiss(animeType : xAlertDisplayAnimeType = .fade)
    {
        switch animeType {
        case .fade:
            UIView.animate(withDuration: 0.25, animations: {
                self.content.alpha = 0
            }, completion: {
                (finish) in
                self.view.isHidden = true
            })
        case .scale:
            UIView.animate(withDuration: 0.25, animations: {
                self.content.transform = .init(scaleX: 0, y: 0)
            }, completion: {
                (finish) in
                self.view.isHidden = true
            })
        case .random:   // 随机递归
            let type = self.getRandmAnimeType()
            self.dismiss(animeType: type)
        }
    }

    // MARK: - Private Func
    /// 获取随机动画类型
    private func getRandmAnimeType() -> xAlertDisplayAnimeType
    {
        var arr = [xAlertDisplayAnimeType]()
        arr = [.fade, .scale]
        let idx = arc4random() % UInt32(arr.count)
        let ret = arr[Int(idx)]
        return ret
    }
    
}
