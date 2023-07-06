//
//  xChooseMapNavigationActionSheet.swift
//  xSDK
//
//  Created by Mac on 2020/10/5.
//

import UIKit
import MapKit

/// 第三方地图导航配置 参考资料 https://www.jianshu.com/p/8ca1f116ed80?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation
public class xMapNavigationConfig: NSObject {
    
    // MARK: - Enum
    /// 当前坐标系类型
    public enum MapCoordinateType {
        /// 高德地图 GCJ-02坐标系
        case Gaode
        /// 百度地图 BD-09坐标系
        case Baidu
        /// 腾讯地图 GCJ-02坐标系
        case Tengxun
        /// 苹果地图 WGS-84
        case Apple
        /// GPS        WGS-84
        case GPS
        
        /// 坐标系名称
        public var name : String {
            switch self {
            case .Gaode, .Tengxun:
                return "GCJ-02"
            case .Baidu:
                return "BD-09"
            default:
                return "WGS-84"
            }
        }
        /*
         WGS-84 - 世界大地测量系统
         WGS-84（World Geodetic System, WGS）是使用最广泛的坐标系，也是世界通用的坐标系，GPS设备得到的经纬度就是在WGS84坐标系下的经纬度。通常通过底层接口得到的定位信息都是WGS84坐标系。

         GCJ-02 - 国测局坐标
         GCJ-02（G-Guojia国家，C-Cehui测绘，J-Ju局），又被称为火星坐标系，是一种基于WGS-84制定的大地测量系统，由中国国测局制定。此坐标系所采用的混淆算法会在经纬度中加入随机的偏移。国家规定，中国大陆所有公开地理数据都需要至少用GCJ-02进行加密，也就是说我们从国内公司的产品中得到的数据，一定是经过了加密的。绝大部分国内互联网地图提供商都是使用GCJ-02坐标系，包括高德地图，谷歌地图中国区等。

         BD-09 - 百度坐标系
         BD-09（Baidu, BD）是百度地图使用的地理坐标系，其在GCJ-02上多增加了一次变换，用来保护用户隐私。从百度产品中得到的坐标都是BD-09坐标系。
         */
    }
    
    // MARK: - Public Property
    /// 当前坐标系
    public var currentCoordinateType = MapCoordinateType.Apple
}

public class xChooseMapNavigationActionSheet: NSObject {
    
    /*
        需要配置url白名单
     <?xml version="1.0" encoding="UTF-8"?>
     <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
     <plist version="1.0">
     <array>
         <string>iosamap</string>
         <string>baidumap</string>
         <string>qqmap</string>
     </array>
     </plist>
     */
    
    // MARK: - 显示选择菜单
    /// 显示选择菜单
    /// - Parameters:
    ///   - viewController: 父控制器
    ///   - appName: App名称
    ///   - poiName: 目的地名称
    ///   - destinationGCJ: 目的地坐标(高德、腾讯地图坐标系)
    ///   - destinationBD: 目的地坐标(百度地图坐标系)
    ///   - destinationWGS: 目的地坐标(苹果地图坐标系)
    public static func display(from viewController : UIViewController,
                               appName : String,
                               poiName : String,
                               destinationGCJ: CLLocationCoordinate2D,
                               destinationBD: CLLocationCoordinate2D,
                               destinationWGS: CLLocationCoordinate2D)
    {
        /* 可以用高德地图自带的方法转换坐标系 */
        // let amapcoord = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: 39.989612, longitude: 116.480972), AMapCoordinateType)
        
        let alert = UIAlertController.init(title: "选择", message: nil, preferredStyle: .actionSheet)
        // 高德地图 https://lbs.amap.com/api/amap-mobile/guide/ios/navi
        if UIApplication.shared.canOpenURL(URL.init(string: "iosamap://")!) {
            let gaode = UIAlertAction.init(title: "高德地图", style: .default) {
                (sender) in
                self.openAMap(appName: appName, poiName: poiName, destination: destinationGCJ)
            }
            alert.addAction(gaode)
        }
        // 百度地图 https://lbsyun.baidu.com/index.php?title=uri/api/ios
        if UIApplication.shared.canOpenURL(URL.init(string: "baidumap://")!) {
            let baidu = UIAlertAction.init(title: "百度地图", style: .default) {
                (sender) in
                self.openBaiduMap(appName: appName, poiName: poiName, destination: destinationBD)
            }
            alert.addAction(baidu)
        }
        // 腾讯地图 https://lbs.qq.com/webApi/uriV1/uriGuide/uriWebRoute
        if UIApplication.shared.canOpenURL(URL.init(string: "qqmap://")!) {
            let baidu = UIAlertAction.init(title: "腾讯地图", style: .default) {
                (sender) in
                self.openTengxunMap(appName: appName, poiName: poiName, destination: destinationGCJ)
            }
            alert.addAction(baidu)
        }
        // 苹果自带地图
        let apple = UIAlertAction.init(title: "苹果地图", style: .default) {
            (sender) in
            self.openAppleMap(appName: appName, poiName: poiName, destination: destinationWGS)
        }
        alert.addAction(apple)
        // 取消
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 高德地图
    /// 打开高德地图 https://lbs.amap.com/api/amap-mobile/guide/ios/navi
    public static func openAMap(appName : String,
                                poiName : String,
                                destination : CLLocationCoordinate2D)
    {
        // 拼接导航信息
        var urlStr = "iosamap://navi?"
        urlStr += "sourceApplication=\(appName)" + "&"
        urlStr += "poiname=\(poiName)" + "&"
        urlStr += "lat=\(destination.latitude)" + "&"
        urlStr += "lon=\(destination.longitude)" + "&"
        /* 导航方式（0 速度快；1 费用少；2路程短... */
        urlStr += "style=2" + "&"
        /* dev=0 是否偏移(0:lat和lon是已经加密后的,不需要国测加密;1:需要国测加密) */
        urlStr += "dev=0"
        // 转码
        let chaset = CharacterSet.urlQueryAllowed
        guard let str = urlStr.addingPercentEncoding(withAllowedCharacters: chaset) else { return }
        guard let url = URL.init(string: str) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - 百度地图
    /// 打开百度地图 https://lbsyun.baidu.com/index.php?title=uri/api/ios
    public static func openBaiduMap(appName : String,
                                    poiName : String,
                                    destination : CLLocationCoordinate2D)
    {
        // 拼接导航信息
        var urlStr = "baidumap://map/direction?"
        urlStr += "origin=我的位置" + "&"
        urlStr += "destination=latlng:\(destination.latitude),\(destination.longitude)" + "|"
        urlStr += "name=\(poiName)" + "&"
        urlStr += "mode=driving" + "&" // 开车
        urlStr += "src=ios.\(appName).openBaiduMap" + "&"
        /* 坐标系  coord_type 允许的值为 bd09ll、gcj02、wgs84 */
        urlStr += "coord_type=bd09ll"
        // 转码
        let chaset = CharacterSet.urlQueryAllowed
        guard let str = urlStr.addingPercentEncoding(withAllowedCharacters: chaset) else { return }
        guard let url = URL.init(string: str) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - 腾讯地图
    /// 打开腾讯地图 https://lbs.qq.com/webApi/uriV1/uriGuide/uriWebRoute
    public static func openTengxunMap(appName : String,
                                      poiName : String,
                                      destination : CLLocationCoordinate2D)
    {
        // 拼接导航信息
        var urlStr = "qqmap://map/routeplan?"
        urlStr += "to=\(poiName)" + "&"
        urlStr += "tocoord=\(destination.latitude),\(destination.longitude)" + "&"
        urlStr += "type=driving" + "&" // 开车
        /* 导航方式（0较快捷 1无高速 2距离 */
        urlStr += "policy=2" + "&"
        urlStr += "referer=\(appName)" + "&"
        /* 坐标系 1 GPtocoord 2 腾讯坐标（默认） */
        urlStr += "coord_type=2"
        // 转码
        let chaset = CharacterSet.urlQueryAllowed
        guard let str = urlStr.addingPercentEncoding(withAllowedCharacters: chaset) else { return }
        guard let url = URL.init(string: str) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - 苹果地图
    /// 打开苹果地图
    public static func openAppleMap(appName : String,
                                    poiName : String,
                                    destination : CLLocationCoordinate2D)
    {
        // 设置起点和终点
        let currentLoc = MKMapItem.forCurrentLocation()
        let toPlace = MKPlacemark.init(coordinate: destination, addressDictionary: nil)
        let toLoc = MKMapItem.init(placemark: toPlace)
        toLoc.name = poiName
        // 跳转地图
        /*
         *调用app自带导航，需要传入一个数组和一个字典，数组中放入MKMapItem，
         字典中放入对应键值

         MKLaunchOptionsDirectionsModeKey   开启导航模式
         MKLaunchOptionsDirectionsModeDriving   开车
         MKLaunchOptionsDirectionsModeWalking   步行
         
         MKLaunchOptionsMapTypeKey  地图模式
         MKMapTypeStandard = 0, 标准
         MKMapTypeSatellite,    卫星
         MKMapTypeHybrid        混合
         
         MKLaunchOptionsShowsTrafficKey 是否显示交通信息
         */
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                       MKLaunchOptionsMapTypeKey: 0,
                       MKLaunchOptionsShowsTrafficKey: true] as [String : Any]
        MKMapItem.openMaps(with: [currentLoc, toLoc],
                           launchOptions: options)
    }
    
}
