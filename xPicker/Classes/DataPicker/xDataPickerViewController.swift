//
//  xDataPickerViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/18.
//

import xKit
import xAlert

public class xDataPickerViewController: xPushAlertViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Handler
    /// 选择数据回调
    public typealias xHandlerChooseData = ([xDataPickerModel]) -> Void
    
    // MARK: - IBOutlet Property
    /// 标题标签
    @IBOutlet weak var titleStackView: UIStackView!
    /// 选择器
    @IBOutlet weak var picker: UIPickerView!
    /// 取消按钮
    @IBOutlet public weak var cancelBtn: xButton!
    /// 确定按钮
    @IBOutlet public weak var sureBtn: xButton!
    
    // MARK: - Public Property
    /// 字体
    public var itemFont = UIFont.systemFont(ofSize: 15)
    /// 高度
    public var itemHeight = CGFloat(44)
    /// 行数
    public var itemNumberOfLines = 1
    /// 对齐方式
    public var itemTextAlignment = NSTextAlignment.center
    
    // MARK: - Private Property
    /// 数据源
    var dataArray = [[xDataPickerModel]]()
    /// 每一列选中的行
    var chooseRowArray = [Int]()
    // 回调
    var chooseHandler : xHandlerChooseData?
    
    // MARK: - 内存释放
    deinit {
        self.chooseHandler = nil
        self.picker.dataSource = nil
        self.picker.delegate = nil
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
        
        var list = [xDataPickerModel]()
        for (i, itemArr) in self.dataArray.enumerated() {
            guard let row = self.chooseRowArray.xObject(at: i) else { continue }
            guard let item = itemArr.xObject(at: row) else { continue }
            list.append(item)
        }
        self.chooseHandler?(list)
        self.dismiss()
    }

    // MARK: - Public Func
    /// 添加回调
    public func addChooseItem(handler : @escaping xDataPickerViewController.xHandlerChooseData)
    {
        self.chooseHandler = handler
    }
    /// 重新加载数据
    public func reload(titles : [String],
                       dataArray : [[xDataPickerModel]])
    {
        guard dataArray.count > 0 else {
            print("⚠️ 没有数据，不加载")
            return
        }
        self.picker.dataSource = self
        self.picker.delegate = self
        // 移除旧标题
        for view in self.titleStackView.arrangedSubviews {
            self.titleStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        // 添加新标题
        for title in titles {
            let lbl = UILabel()
            lbl.text = title
            lbl.font = .systemFont(ofSize: 16, weight: .medium)
            lbl.textAlignment = .center
            self.titleStackView.addArrangedSubview(lbl)
        }
        self.titleStackView.setNeedsLayout()
        self.titleStackView.layoutIfNeeded()
        // 重新加载
        self.dataArray = dataArray
        self.chooseRowArray = .init(repeating: 0, count: dataArray.count)
        // 重置状态
        self.picker.reloadAllComponents()
        for i in 0 ..< dataArray.count {
            self.picker.selectRow(0, inComponent: i, animated: false)
        }
    }
    
    // MARK: - UIPickerViewDataSource
    /// 几列
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return self.dataArray.count
    }
    /// 每列有几行
    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int
    {
        var count = self.dataArray.count
        guard let itemArr = self.dataArray.xObject(at: component) else { return count }
        count = itemArr.count
        return count
    }
    /// 为指定的列和行赋值
    public func pickerView(_ pickerView: UIPickerView,
                           titleForRow row: Int,
                           forComponent component: Int) -> String?
    {
        var title = ""
        guard let itemArr = self.dataArray.xObject(at: component) else { return title }
        guard let item = itemArr.xObject(at: row) else { return title }
        title = item.name
        return title
    }
    
    /// 跟Cell类似
    public func pickerView(_ pickerView: UIPickerView,
                           viewForRow row: Int,
                           forComponent component: Int,
                           reusing view: UIView?) -> UIView
    {
        var lbl = view as? UILabel
        if lbl == nil {
            lbl = UILabel()
            lbl?.font = self.itemFont
            lbl?.numberOfLines = self.itemNumberOfLines
            lbl?.textAlignment = self.itemTextAlignment
        }
        lbl?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return lbl!
    }
    
    // MARK: - UIPickerViewDelegate
    /// 设置行高
    public func pickerView(_ pickerView: UIPickerView,
                           rowHeightForComponent component: Int) -> CGFloat
    {
        return self.itemHeight
    }
    /// 选中某列某行
    public func pickerView(_ pickerView: UIPickerView,
                           didSelectRow row: Int,
                           inComponent component: Int)
    {
        self.chooseRowArray[component] = row
    }
    
}
