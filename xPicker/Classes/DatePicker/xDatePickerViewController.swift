//
//  xDatePickerViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/18.
//

import UIKit
import xAlert

public class xDatePickerViewController: xPushAlertViewController {

    // MARK: - Handler
    /// 选择日期回调
    public typealias xHandlerChooseDate = (Double) -> Void
    /// 完成回调
    public typealias xHandlerChooseDateCompleted = () -> Void

    // MARK: - IBOutlet Property
    /// 标题标签
    @IBOutlet weak var titleLbl: UILabel!
    /// 选择器
    @IBOutlet weak var picker: UIDatePicker!
    
    // MARK: - Public Property
    /// 最晚日期
    public var maxDate : Date?
    /// 最早日期
    public var minDate : Date?
    /// 日期模式
    public var model = UIDatePicker.Mode.date
    
    // MARK: - Private Property
    /// 回调
    private var chooseHandler : xHandlerChooseDate?
    private var completedHandler : xHandlerChooseDateCompleted?
    
    // MARK: - 内存释放
    deinit {
        self.chooseHandler = nil
        self.completedHandler = nil
    }
    
    // MARK: - Public Override Func
    public override class func xDefaultViewController() -> Self {
        let vc = xDatePickerViewController.xNew(storyboard: "xDatePickerViewController")
        return vc as! Self
    }
    public override func dismiss() {
        super.dismiss()
        self.completedHandler?()
    }
    
    // MARK: - IBAction Func
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        self.dismiss()
    }
    @IBAction func sureBtnClick(_ sender: UIButton) {
        let date = self.picker.date
        let timeStamp = date.timeIntervalSince1970
        self.chooseHandler?(timeStamp)
        self.dismiss()
    }
    
    // MARK: - Public Func
    /// 显示选择器
    /// - Parameters:
    ///   - title: 标题
    ///   - date: 当前时间
    ///   - isSpring: 是否开启弹性动画
    ///   - handler1: 选中数据
    ///   - handler2: 弹窗消失
    public func display(title : String,
                        date : Date = .init(),
                        isSpring : Bool = true,
                        choose handler1 : @escaping xHandlerChooseDate,
                        completed handler2 : xHandlerChooseDateCompleted? = nil)
    {
        // 保存数据
        self.titleLbl.text = title
        self.picker.date = date
        self.chooseHandler = handler1
        self.completedHandler = handler2
        
        self.picker.maximumDate = self.maxDate
        self.picker.minimumDate = self.minDate
        self.picker.datePickerMode = self.model
        // 执行动画
        super.display(isSpring: isSpring)
    }
    
}
