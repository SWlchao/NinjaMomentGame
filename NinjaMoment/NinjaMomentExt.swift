import Foundation
import UIKit

struct NMGEXT<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol NinjaMomentExt {}
extension NinjaMomentExt {
    static var ext: NMGEXT<Self>.Type {
        get {
            NMGEXT<Self>.self
        }
        set{}
    }
    var ext: NMGEXT<Self> {
        get {
            NMGEXT(self)
        }
        set{}
    }
}

extension UIViewController: NinjaMomentExt {}
extension UIView: NinjaMomentExt {}
extension String: NinjaMomentExt {}
extension UIColor: NinjaMomentExt {}
extension Date: NinjaMomentExt {}
extension Int: NinjaMomentExt {}

extension NMGEXT where Base == Int {
    var txt: String {
        return "\(base)"
    }
}

extension NMGEXT where Base: UIViewController {
    func show(_ message: String) {
        let hub = MBProgressHUD.showAdded(to: base.view, animated: true)
        hub.detailsLabel.text = message
        hub.detailsLabel.textColor = .white
        hub.isUserInteractionEnabled = false
        hub.mode = .text
        hub.bezelView.backgroundColor = .black
        hub.hide(animated: true, afterDelay: 1.5)
    }
    
    func alert(_ title: String, done: (() -> Void)?, cancel: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: { _ in
            done?()
        }))
        if let cancel = cancel {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                cancel()
            }))
        }
        base.present(alert, animated: true, completion: nil)
    }
    
    var cacheFileSize: String{
        var foldSize: UInt64 = 0
        let filePath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
        if let files = FileManager.default.subpaths(atPath: filePath) {
            for path in files {
                let temPath: String = filePath+"/"+path
                let folder = try? FileManager.default.attributesOfItem(atPath: temPath) as NSDictionary
                if let c = folder?.fileSize() {
                    foldSize += c
                }
            }
        }
        //保留2位小数
        if foldSize > 1024 * 1024 {
            return String(format: "%.2f", Double(foldSize) / 1024.0 / 1024.0) + "MB"
        } else if foldSize > 1024 {
            return String(format: "%.2f", Double(foldSize)/1024.0) + "KB"
        } else {
            return String(foldSize) + "B"
        }
    }
    
    var clearFileCache: String {
        let filePath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
        if let files = FileManager.default.subpaths(atPath: filePath) {
            for path in files {
                let temPath: String = filePath+"/"+path
                if FileManager.default.fileExists(atPath: temPath) {
                    try? FileManager.default.removeItem(atPath: temPath)
                }
            }
        }
        return base.ext.cacheFileSize
    }
}

extension NMGEXT where Base == String {
    var intValue: Int {
        return Int(base) ?? 0
    }
    
    subscript(_ index: Int) -> String {
        if (0..<base.count).contains(index) {
            let start = base.index(base.startIndex, offsetBy: index)
            return String(base[start])
        }
        return base
    }
    
    subscript(_ r: Range<Int>) -> String {
        if (r.upperBound < base.count) {
            let start = base.index(base.startIndex, offsetBy: max(r.lowerBound, 0))
            let end = base.index(base.startIndex, offsetBy: min(r.upperBound, base.count))
            return String(base[start...end])
        }
        return base
    }
    
    subscript(_ r: ClosedRange<Int>) -> String {
        if (r.upperBound < base.count) {
            let start = base.index(base.startIndex, offsetBy: max(r.lowerBound, 0))
            let end = base.index(base.startIndex, offsetBy: min(r.upperBound, base.count - 1))
            return String(base[start...end])
        }
        return base
    }
    
    var height: CGFloat {
        let font = UIFont.systemFont(ofSize: 15)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let attrs = [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.paragraphStyle : paragraphStyle
        ]
        return base.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 60, height: 256), options: .usesLineFragmentOrigin, attributes: attrs, context: nil).height
    }
}

extension NMGEXT where Base: UIView {
    func rbc(_ r: CGFloat = 0, b: CGFloat = 0, c: UIColor = .clear) {
        base.layer.masksToBounds = true
        base.layer.cornerRadius = r
        base.layer.borderWidth = b
        base.layer.borderColor = c.cgColor
    }
    
    func corner(_ r: CGFloat = 5, rc: UIRectCorner) {
        let basePath = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: rc, cornerRadii: CGSize(width: r, height: r))
        let baseLayer = CAShapeLayer()
        baseLayer.frame = base.bounds
        baseLayer.path = basePath.cgPath
        base.layer.mask = baseLayer
    }
    
    var width: CGFloat {
        return base.bounds.width
    }
    
    var height: CGFloat {
        return base.bounds.height
    }
}

extension NMGEXT where Base == UIColor {
    static func rgb(_ r: CGFloat = 255, _ g: CGFloat = 255, _ b: CGFloat = 255, _ a: CGFloat = 1) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}

extension NMGEXT where Base == Date {
    
    func string(_ customdf: String = "yyyy/MM/dd") -> String {
        let df = DateFormatter()
        df.dateFormat = customdf
        return df.string(from: base)
    }
    
    var hour: String {
        return "\(base.ext.string("H"))h\(base.ext.string("m"))m"
    }
    
    var h: Int {
        return base.ext.string("H").ext.intValue
    }
    
    var m: Int {
        return base.ext.string("m").ext.intValue
    }
    
    var isToday: Bool {
        return base.ext.string() == Date().ext.string()
    }
    
    var isFuture: Bool {
        return base > Date()
    }
    
    var days: Int {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"

        guard let f = df.date(from: df.string(from: Date())) else {
            return 0
        }

        guard let t = df.date(from: df.string(from: base)) else {
            return 0
        }
        
        let components = NSCalendar.current.dateComponents([.day], from: f, to: t)
        
        return components.day ?? 0
    }
}

