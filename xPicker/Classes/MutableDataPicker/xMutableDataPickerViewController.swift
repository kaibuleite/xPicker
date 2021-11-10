//
//  xMutableDataPickerViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/19.
//

import UIKit
import xAlert

public class xMutableDataPickerViewController: xPushAlertViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Handler
    /// 选择数据回调
    public typealias xHandlerChooseMutableData = ([xMutableDataPickerModel]) -> Void
    /// 完成回调
    public typealias xHandlerChooseDateCompleted = () -> Void
    
    // MARK: - IBOutlet Property
    /// 标题标签
    @IBOutlet weak var titleLbl: UILabel!
    /// 选择器
    @IBOutlet weak var picker: UIPickerView!
    
    // MARK: - Public Property
    /// 字体
    public var itemFont = UIFont.systemFont(ofSize: 15)
    /// 高度
    public var itemHeight = CGFloat(44)
    /// 行数
    public var itemNumberOfLines = 1
    /// 对齐方式
    public var itemtextAlignment = NSTextAlignment.center
    
    // MARK: - Private Property
    /// 数据源
    private var dataArray = [[xMutableDataPickerModel]]()
    /// 所有数据源
    private var totalDataArray = [xMutableDataPickerModel]()
    /// 每一列选中的行
    private var columnChooseRowArray = [Int]()
    /// 最短数据长度
    private var minDataLength = Int.max
    /// 最长数据长度
    private var maxDataLength = Int.zero
    // 回调
    private var chooseHandler : xHandlerChooseMutableData?
    private var completedHandler : xHandlerChooseDateCompleted?
    
    // MARK: - 内存释放
    deinit {
        self.chooseHandler = nil
        self.completedHandler = nil
        self.picker.dataSource = nil
        self.picker.delegate = nil
    }
    
    // MARK: - Public Override Func
    public override class func xDefaultViewController() -> Self {
        let vc = xMutableDataPickerViewController.xNew(storyboard: "xMutableDataPickerViewController")
        return vc as! Self
    }
    public override func dismiss() {
        super.dismiss()
        self.completedHandler?()
    }
    
    // MARK: - IBAction Func
    @IBAction public func cancelBtnClick(_ sender: UIButton) {
        self.dismiss()
    }
    @IBAction public func sureBtnClick(_ sender: UIButton) {
        var arr = [xMutableDataPickerModel]()
        for (i, list) in self.dataArray.enumerated() {
            let row = self.columnChooseRowArray[i]
            let model = list[row]
            arr.append(model)
        }
        self.chooseHandler?(arr)
        self.dismiss()
    }

    // MARK: - Public Func
    /// 显示选择器
    /// - Parameters:
    ///   - title: 标题
    ///   - springDamping: 弹性阻尼，越小效果越明显
    ///   - springVelocity: 弹性修正速度，越大修正越快
    ///   - handler: 回调
    public func display(title : String,
                        isSpring : Bool = true,
                        choose handler1 : @escaping xHandlerChooseMutableData,
                        completed handler2 : xHandlerChooseDateCompleted? = nil)
    {
        // 保存数据
        self.titleLbl.text = title
        self.chooseHandler = handler1
        self.completedHandler = handler2
        // 执行动画
        super.display(isSpring: isSpring)
    }
    /// 重新加载数据
    public func reload(dataArray : [xMutableDataPickerModel])
    {
        guard dataArray.count > 0 else {
            print("⚠️ 没有数据，不加载")
            return
        }
        self.picker.dataSource = self
        self.picker.delegate = self
        // 清空数据
        self.minDataLength = Int.max
        self.maxDataLength = Int.zero
        self.totalDataArray.removeAll()
        // 数据预处理
        for (i, model) in dataArray.enumerated() {
            model.column = 0
            model.row = i
        }
        // 重新加载
        self.forEach(dataArray: dataArray)
        if self.minDataLength != self.maxDataLength {
            print("⚠️ 数据长度不一致，[\(self.minDataLength), \(self.maxDataLength)]")
        }
        /*
        self.totalDataArray.forEach {
            (model) in
            print("\(model.rowNumber) \(model.name)")
        }*/
        self.columnChooseRowArray = .init(repeating: 0, count: self.minDataLength)
        self.updateDataArray()
        self.picker.reloadAllComponents()
        // 重置状态
        for i in 0 ..< self.minDataLength {
            self.picker.selectRow(0, inComponent: i, animated: false)
        }
    }

    // MARK: - Private Func
    /// 遍历数据
    private func forEach(dataArray : [xMutableDataPickerModel])
    {
        for model in dataArray {
            self.totalDataArray.append(model)
            // 子集不为空，继续遍历
            if model.childList.count > 0 {
                let list = model.childList
                for obj in list {
                    obj.column = model.column + 1
                }
                self.forEach(dataArray: list)
                continue
            }
            // 子集为空，计算数据长度
            let column = model.column + 1  // 技术从0开始算
            if column > self.maxDataLength {
                self.maxDataLength = column
                print("数据最长列更新为\(column) - \(model.name)")
            }
            if column < self.minDataLength {
                self.minDataLength = column
                print("数据最短列更新为\(column) - \(model.name)")
            }
        }
    }
    /// 更新数据源
    public func updateDataArray()
    {
        var ret = [[xMutableDataPickerModel]].init(repeating: .init(),
                                                   count: self.minDataLength)
        for column in 0 ..< self.minDataLength {
            // 获取行编号
            var rowNumber = ""
            for (i, row) in self.columnChooseRowArray.enumerated() {
                guard i < column else { continue }
                rowNumber += "\(row)"
            }
            // 筛选数据
            for model in self.totalDataArray {
                // 同列的数据
                guard column == model.column else { continue }
                if model.rowNumber.hasPrefix(rowNumber) {
                    ret[column].append(model)
                }
            }
        }
        self.dataArray = ret
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
        let list = self.dataArray[component]
        return list.count
    }
    /// 为指定的列和行赋值
    public func pickerView(_ pickerView: UIPickerView,
                           titleForRow row: Int,
                           forComponent component: Int) -> String?
    {
        let list = self.dataArray[component]
        let model = list[row]
        return model.name
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
            lbl?.textAlignment = self.itemtextAlignment
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
        self.columnChooseRowArray[component] = row
        // 重置状态
        for i in component + 1 ..< self.minDataLength {
            self.columnChooseRowArray[i] = 0
            self.picker.selectRow(0, inComponent: i, animated: false)
        }
        // 更新数据源
        self.updateDataArray()
        for i in component + 1 ..< self.minDataLength {
            self.picker.reloadComponent(i)
        }
    }
    
}
