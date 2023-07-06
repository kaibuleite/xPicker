//
//  xMutableDataPickerViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/19.
//

import xKit
import xAlert

public class xMutableDataPickerViewController: xPushAlertViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Handler
    /// 选择数据回调
    public typealias xHandlerChooseMutableData = ([xMutableDataPickerModel]) -> Void
    
    // MARK: - IBOutlet Property
    /// 标题标签
    @IBOutlet public weak var titleLbl: UILabel!
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
    var dataArray = [xMutableDataPickerModel]()
    /// 每一列选中的行
    var chooseRowArray = [Int]()
    /// 最短数据长度
    var minDataLength = Int.max
    /// 最长数据长度
    var maxDataLength = Int.zero
    // 回调
    var chooseHandler : xHandlerChooseMutableData?
    
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
    @IBAction public func sureBtnClick(_ sender: UIButton) {
        print("\(#function) in \(type(of: self))")
        
        var itemArr = self.dataArray
        var list = [xMutableDataPickerModel]()
        for row in self.chooseRowArray {
            guard let item = itemArr.xObject(at: row) else { continue }
            itemArr = item.childList
            list.append(item)
        }
        self.chooseHandler?(list)
        self.dismiss()
    }

    // MARK: - Public Func
    /// 添加回调
    public func addChooseItem(handler : @escaping xMutableDataPickerViewController.xHandlerChooseMutableData)
    {
        self.chooseHandler = handler
    } 
    /// 重新加载数据
    public func reload(title : String,
                       dataArray : [xMutableDataPickerModel])
    {
        guard dataArray.count > 0 else {
            print("⚠️ 没有数据，不加载")
            return
        }
        self.picker.dataSource = self
        self.picker.delegate = self
        self.titleLbl.text = title
        // 清空数据
        self.minDataLength = Int.max
        self.maxDataLength = Int.zero
        // 数据预处理
        self.forEach(dataArray: dataArray, column: 0)
        if self.minDataLength != self.maxDataLength {
            print("⚠️ 数据长度不一致，[\(self.minDataLength), \(self.maxDataLength)]")
        }
        self.dataArray = dataArray
        self.chooseRowArray = .init(repeating: 0, count: self.minDataLength)
        // 重置状态
        self.picker.reloadAllComponents()
        for i in 0 ..< self.minDataLength {
            self.picker.selectRow(0, inComponent: i, animated: false)
        }
    }

    // MARK: - Private Func
    /// 遍历数据
    func forEach(dataArray : [xMutableDataPickerModel],
                 column : Int)
    {
        for (i, model) in dataArray.enumerated() {
            model.column = column
            model.row = i
            if model.childList.count > 0 {
                // 子集不为空，继续遍历
                let list = model.childList
                self.forEach(dataArray: list, column: column + 1)
            } else {
                // 子集为空，计算数据长度
                let length = column + 1
                if length > self.maxDataLength {
                    self.maxDataLength = length
                }
                if length < self.minDataLength {
                    self.minDataLength = length
                }
            }
        }
    }
    
    // MARK: - UIPickerViewDataSource
    /// 几列
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return self.minDataLength
    }
    /// 每列有几行
    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int
    {
        var itemArr = self.dataArray
        var count = self.dataArray.count
        for (i, chooseRow) in self.chooseRowArray.enumerated() {
            guard i < component else { break }
            if let item = itemArr.xObject(at: chooseRow) {
                count = item.childList.count
                itemArr = item.childList
            }
        }
        return count
    }
    /// 为指定的列和行赋值
    public func pickerView(_ pickerView: UIPickerView,
                           titleForRow row: Int,
                           forComponent component: Int) -> String?
    {
        var itemArr = self.dataArray
        var title = ""
        for (i, chooseRow) in self.chooseRowArray.enumerated() {
            guard i <= component else { break }
            if let item = itemArr.xObject(at: row) {
                title = item.name
            }
            if let item = itemArr.xObject(at: chooseRow) {
                itemArr = item.childList
            }
        }
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
        // 重新加载数据
        self.chooseRowArray[component] = row
        // 重置状态
        for i in component + 1 ..< self.minDataLength {
            self.chooseRowArray[i] = 0
            self.picker.reloadComponent(i)
            self.picker.selectRow(0, inComponent: i, animated: false)
        }
    }
    
}
