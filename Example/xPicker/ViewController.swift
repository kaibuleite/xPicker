//
//  ViewController.swift
//  xPicker
//
//  Created by 177955297@qq.com on 06/15/2021.
//  Copyright (c) 2021 177955297@qq.com. All rights reserved.
//

import xKit
import xPicker

class ViewController: xViewController {
    
    // MARK: - IBOutlet Property
    @IBOutlet weak var contentLbl: UILabel!
    
    // MARK: - Picker
    let pickerDate = xDatePickerViewController.xDefaultViewController()
    let pickerData1 = xDataPickerViewController.xDefaultViewController()
    let pickerData2 = xDataPickerViewController.xDefaultViewController()
    let pickerMutableData = xMutableDataPickerViewController.xDefaultViewController()
     
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPicker()
    }
    override func addChildren() {
        self.xAddChild(viewController: self.pickerDate, in: self.view)
        self.xAddChild(viewController: self.pickerData1, in: self.view)
        self.xAddChild(viewController: self.pickerData2, in: self.view)
        self.xAddChild(viewController: self.pickerMutableData, in: self.view)
    }
     
    // MARK: - 初始化Picker
    /// 初始化Picker
    func initPicker()
    {
        self.pickerDate.addChooseItem {
            [unowned self] (timestamp) in
            self.contentLbl.text = "\(timestamp)".xToDateString(format: "yyyy-MM-dd HH:m:ss")
        }
        self.pickerData1.addChooseItem {
            [unowned self] (list) in
            let strArr = list.map { return "\($0.name)" }
            self.contentLbl.text = strArr.joined(separator: " ")
        }
        self.pickerData2.addChooseItem {
            [unowned self] (list) in
            let strArr = list.map { return "\($0.name)" }
            self.contentLbl.text = strArr.joined(separator: " ")
        }
        self.pickerMutableData.addChooseItem {
            [unowned self] (list) in
            let strArr = list.map { return "\($0.name)" }
            self.contentLbl.text = strArr.joined(separator: " ")
        }
    }
    
    // MARK: - 日期选择器
    @IBAction func datePickerBtnClick()
    {
        print("\(#function) in \(type(of: self))")
        self.pickerDate.model = .dateAndTime
        self.pickerDate.minDate = .init()
//        self.pickerDate.maxDate
        self.pickerDate.display(title: "选择日期")
    }
    
    // MARK: - 数据选择器
    @IBAction func dataPicker1BtnClick()
    {
        print("\(#function) in \(type(of: self))")
        let arr = ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉"]
        var list = [xDataPickerModel]()
        for (i, obj) in arr.enumerated() {
            list.append(.init(id: "\(i)", name: obj))
        }
        self.pickerData1.reload(titles: ["选择水果"], dataArray: [list])
        self.pickerData1.sureBtn.backgroundColor = .xNewRandom()
        self.pickerData1.sureBtn.setTitleColor(.white, for: .normal)
        self.pickerData1.display()
    }
    @IBAction func dataPicker2BtnClick()
    {
        print("\(#function) in \(type(of: self))")
        let arr1 = ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍈", "🍒", "🍑", "🍍", "🥝", "🥑"]
        let arr2 = ["🍅", "🍆", "🥒", "🥕", "🌶", "🥔", "🌽", "🍠", "🥜"]
        let arr3 = ["🍯", "🥐", "🍞", "🥖", "🧀", "🥚", "🥓", "🥞", "🍗", "🍖"]
        var list1 = [xDataPickerModel]()
        var list2 = [xDataPickerModel]()
        var list3 = [xDataPickerModel]()
        for (i, obj) in arr1.enumerated() { list1.append(.init(id: "\(i)", name: obj)) }
        for (i, obj) in arr2.enumerated() { list2.append(.init(id: "\(i)", name: obj)) }
        for (i, obj) in arr3.enumerated() { list3.append(.init(id: "\(i)", name: obj)) }
        self.pickerData2.reload(titles: ["选择水果", "选择蔬菜", "选择食物"],
                                dataArray: [list1, list2, list3])
        self.pickerData2.cancelBtn.backgroundColor = .groupTableViewBackground
        self.pickerData2.cancelBtn.setTitleColor(.red, for: .normal)
        self.pickerData2.sureBtn.backgroundColor = .xNewRandom()
        self.pickerData2.sureBtn.setTitleColor(.white, for: .normal)
        self.pickerData2.display()
    }
    
    // MARK: - 可变数据选择器
    @IBAction func mutableDataPickerBtnClick()
    {
        print("\(#function) in \(type(of: self))")
        
        let province1 = xMutableDataPickerModel.init(id: "1", name: "北京市")
        let city1 = xMutableDataPickerModel.init(id: "1_1", name: "市辖区")
        city1.childList.append(.init(id: "1_1_1", name: "东城区"))
        city1.childList.append(.init(id: "1_1_2", name: "西城区"))
        city1.childList.append(.init(id: "1_1_3", name: "朝阳区"))
        province1.childList = [city1]
        
        let province2 = xMutableDataPickerModel.init(id: "2", name: "山西省")
        let city2_1 = xMutableDataPickerModel.init(id: "2_1", name: "太原市")
        city2_1.childList.append(.init(id: "2_1_1", name: "小店区"))
        city2_1.childList.append(.init(id: "2_1_2", name: "迎泽区"))
        city2_1.childList.append(.init(id: "2_1_3", name: "晋源区"))
        city2_1.childList.append(.init(id: "2_1_3", name: "阳曲县"))
        let city2_2 = xMutableDataPickerModel.init(id: "2_2", name: "大同市")
        city2_2.childList.append(.init(id: "2_2_1", name: "城区"))
        city2_2.childList.append(.init(id: "2_2_2", name: "矿区"))
        province2.childList = [city2_1, city2_2]
        
        let province3 = xMutableDataPickerModel.init(id: "3", name: "福建省")
        let city3 = xMutableDataPickerModel.init(id: "3_1", name: "泉州市")
        city3.childList.append(.init(id: "3_1_1", name: "晋江市"))
        city3.childList.append(.init(id: "3_1_2", name: "鲤城区"))
        city3.childList.append(.init(id: "3_1_3", name: "丰泽区"))
        province3.childList = [city3]
        
        let list = [province1, province2, province3]
        self.pickerMutableData.reload(title: "请选择城市", dataArray: list)
        self.pickerMutableData.display()
    }

}

