//
//  xDatePickerViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/18.
//

import xKit
import xAlert

public class xDatePickerViewController: xPushAlertViewController {

    // MARK: - Handler
    /// 选择日期回调
    public typealias xHandlerChooseDate = (Double) -> Void

    // MARK: - IBOutlet Property
    /// 标题标签
    @IBOutlet public weak var titleLbl: UILabel!
    /// 选择器
    @IBOutlet weak var picker: UIDatePicker!
    /// 取消按钮
    @IBOutlet public weak var cancelBtn: xButton!
    /// 确定按钮
    @IBOutlet public weak var sureBtn: xButton!
    
    // MARK: - Public Property
    /// 最晚日期
    public var maxDate : Date?
    /// 最早日期
    public var minDate : Date?
    /// 日期模式
    public var model = UIDatePicker.Mode.date
    
    // MARK: - Private Property
    /// 回调
    var chooseHandler : xHandlerChooseDate?
    
    // MARK: - 内存释放
    deinit {
        self.chooseHandler = nil
    }
    
    // MARK: - Public Override Func
    public override class func xDefaultViewController() -> Self {
        let vc = Self.xNew(storyboard: nil)
        return vc
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
    }
    
    // MARK: - IBAction Func
    @IBAction func sureBtnClick(_ sender: UIButton) {
        print("\(#function) in \(type(of: self))")
        
        let date = self.picker.date
        let timeStamp = date.timeIntervalSince1970
        self.chooseHandler?(timeStamp)
        self.dismiss()
    }
    
    // MARK: - Public Func
    /// 添加回调
    public func addChooseItem(handler : @escaping xDatePickerViewController.xHandlerChooseDate)
    {
        self.chooseHandler = handler
    }
    /// 显示选择器
    public func display(title : String,
                        date : Date = .init(),
                        isSpring : Bool = true)
    {
        // 保存数据
        self.titleLbl.text = title
        self.picker.date = date
        
        self.picker.maximumDate = self.maxDate
        self.picker.minimumDate = self.minDate
        self.picker.datePickerMode = self.model
        // 执行动画
        super.display(isSpring: isSpring)
    }
    
}
