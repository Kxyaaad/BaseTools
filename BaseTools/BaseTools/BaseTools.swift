//
//  BaseTools.swift
//  BaseTools
//
//  Created by SanDisk on 2019/3/29.
//  Copyright © 2019 SanDisk. All rights reserved.
//

import Foundation
import UIKit
var Activity : UIActivityIndicatorView!
var ActivityBGV : UIView!
var ImageReview : UIImageView!
var ImageScView : UIScrollView!
let Defaults = UserDefaults.standard
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let navHeight = UIApplication.shared.statusBarFrame.height

public class baseTools:UIViewController, UIScrollViewDelegate {
    
    /* 自定义方法 */
    
    public class func getLabelHegit(str: String, font: UIFont, width: CGFloat)-> CGFloat {
        let statusLabelText: NSString = str as NSString
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let dic =  NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic   as?  [NSAttributedString.Key : AnyObject], context: nil).size
        return strSize.height
    }
    
    
    //MARK:时间戳转换时间
    public enum types {
        case zhongwen, xiaoshudian, henxian
    }
    public class func timeStampToString(timeStamp:String, type:types)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        switch type {
        case .zhongwen:
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
        case .xiaoshudian:
            dfmatter.dateFormat="yyyy.MM.dd"
        case .henxian:
            dfmatter.dateFormat="yyyy-MM-dd"
        }
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        return dfmatter.string(from: date as Date)
    }
    
    /* 时间转时间戳 */
    public class func timeToTimeStamp(time: String) -> Double {
        let dfmatter = DateFormatter()
        //yyyy-MM-dd HH:mm:ss
        dfmatter.dateFormat="yyyy-MM-dd"
        let last = dfmatter.date(from: time)
        let timeStamp = last?.timeIntervalSince1970
        return timeStamp!
    }
    
    /* 加载提示动画 */
    public class func activityStart(_ view:UIView) {
        ActivityBGV = UIView(frame: view.bounds)
        ActivityBGV.backgroundColor = UIColor.init(white: 0.9, alpha: 0.1)
        Activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        Activity.layer.cornerRadius = 10
        Activity.layer.backgroundColor = UIColor.init(white: 0.2, alpha: 0.5).cgColor
        Activity.style = UIActivityIndicatorView.Style.whiteLarge
        Activity.color =  .white
        Activity.center = view.center
        Activity.startAnimating()
        if !view.subviews.contains(Activity) {
            view.addSubview(ActivityBGV)
            view.addSubview(Activity)
        }
        
        
    }
    
    public class func activityDismiss() {
        Activity.stopAnimating()
        Activity.removeFromSuperview()
        ActivityBGV.removeFromSuperview()
    }
    
    //MARK: 图片预览
    
    /* 初始化 */
    static  func initImageView(image : UIImage?, BGView : UIView, vc:AnyObject) {
        if image != nil {
            print(1)
            ImageScView = UIScrollView.init(frame: BGView.bounds)
            ImageScView.zoomScale = ImageScView.minimumZoomScale
            ImageScView?.contentSize = ImageScView.frame.size
            ImageScView.backgroundColor = .black
            ImageReview = UIImageView(frame: CGRect(origin: ImageScView!.center, size: ImageScView!.contentSize))
            ImageReview.center = ImageScView.center
            ImageReview?.image = image
            BGView.addSubview(ImageScView)
            ImageScView.addSubview(ImageReview)
            setZoomScaleFor(srollViewSize: ImageScView.bounds.size)
            recenterImage()
        }
    }
    
    static func recenterImage() {
        print(2)
        let scrollViewSize = ImageScView.bounds.size
        let imageViewSize = ImageReview.frame.size
        let horizontalSpace = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2.0 : 0
        let verticalSpace = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.width) / 2.0 :0
        ImageScView.contentInset = UIEdgeInsets(top: verticalSpace, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
    }
    static func setZoomScaleFor(srollViewSize: CGSize) {
        print(3)
        let imageSize = ImageReview.bounds.size
        let widthScale = srollViewSize.width / imageSize.width
        let heightScale = srollViewSize.height / imageSize.height
        let minimunScale = min(widthScale, heightScale)
        ImageScView.minimumZoomScale = minimunScale
        ImageScView.maximumZoomScale = 3.0
    }
    
    private static func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print(4)
        return ImageReview
    }
    
}
