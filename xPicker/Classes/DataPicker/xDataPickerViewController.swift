//
//  xDataPickerViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/18.
//

import UIKit
import xAlert

public class xDataPickerViewController: xPushAlertViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Handler
    /// 选择数据回调
    public typealias xHandlerChooseData = ([xDataPickerModel]) -> Void
    /// 完成回调
    public typealias xHandlerChooseDateCompleted = () -> Void
    
    // MARK: - IBOutlet Property
    /// 标题标签
    @IBOutlet weak var titleLbl: UILabel!
    /// 选择器
    @IBOutlet weak var picker: UIPickerView!
    
    // MARK: - Private Property
    /// 数据源
    private var dataArray = [[xDataPickerModel]]()
    /// 每一列选中的行
    private var columnChooseRowArray = [Int]()
    /// 回调
    private var chooseHandler : xHandlerChooseData?
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
        let vc = xDataPickerViewController.xNew(storyboard: "xDataPickerViewController")
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
        var arr = [xDataPickerModel]()
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
    ///   - isSpring: 是否开启弹性动画
    ///   - handler1: 选中数据
    ///   - handler2: 弹窗消失
    public func display(title : String,
                        isSpring : Bool = true,
                        choose handler1 : @escaping xHandlerChooseData,
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
    public func reload(dataArray : [[xDataPickerModel]])
    {
        guard dataArray.count > 0 else {
            print("⚠️ 没有数据，不加载")
            return
        }
        self.picker.dataSource = self
        self.picker.delegate = self
        // 重新加载
        self.dataArray = dataArray
        self.columnChooseRowArray = .init(repeating: 0, count: dataArray.count)
        self.picker.reloadAllComponents()
        // 重置状态
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
    
    // MARK: - UIPickerViewDelegate
    /// 选中某列某行
    public func pickerView(_ pickerView: UIPickerView,
                           didSelectRow row: Int,
                           inComponent component: Int)
    {
        self.columnChooseRowArray[component] = row
    }
    
}
