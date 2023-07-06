//
//  xChoosePhotoActionSheet.swift
//  xSDK
//
//  Created by Mac on 2020/9/17.
//

import UIKit
import xKit

public class xChoosePhotoActionSheet: NSObject {

    // MARK: - 内存释放
    deinit {
        print("💥 照片选择器")
    }
    
    // MARK: - 显示提示照片选择提示弹窗
    /// 开启照片选择提示栏
    /// - Parameters:
    ///   - viewController: 要显示的视图控制器
    ///   - albumTitle: 相册标题
    ///   - cameraTitle: 相机标题
    ///   - cancelTitle: 取消标题
    ///   - allowsEditing: 是否开启编辑模式（裁剪成方形）
    ///   - handler: 选择照片回调
    public static func display(from viewController : UIViewController,
                               albumTitle : String = "相册",
                               cameraTitle : String = "相机",
                               cancelTitle : String = "取消",
                               allowsEditing : Bool,
                               choose handler : @escaping xImagePickerController.xHandlerChoosePhoto)
    {
        let actionSheet = UIAlertController.init(title: nil,
                                                 message: nil,
                                                 preferredStyle: .actionSheet)
        // 相机
        let camera = UIAlertAction.init(title: cameraTitle, style: .default) {
            (sender) in
            let picker = xImagePickerController()
            picker.allowsEditing = allowsEditing
            picker.displayCamera(from: viewController, choose: handler)
        }
        actionSheet.addAction(camera)
        // 相册
        let album = UIAlertAction.init(title: albumTitle, style: .default) {
            (sender) in
            let picker = xImagePickerController()
            picker.allowsEditing = allowsEditing
            picker.displayAlbum(from: viewController, choose: handler)
        }
        actionSheet.addAction(album)
        // 取消
        let cancel = UIAlertAction.init(title: cancelTitle, style: .cancel, handler : nil)
        actionSheet.addAction(cancel)
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}
