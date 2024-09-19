//
//  TableView+Extension.swift
//  AssetManager
//
//  Created by 정다연 on 8/27/24.
//

protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

extension UITableView {
    func register(cellType: UITableViewCell.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func register(cellTypes: [UITableViewCell.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }
}


import class UIKit.UITableViewCell
import class UIKit.UITableView
import struct Foundation.IndexPath
import UIKit

protocol ReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {
}

extension UIView {
    func dequeueError<T>(withIdentifier reuseIdentifier: String, type _: T) -> String {
        return "Couldn't deque \(T.self) with idnentifier \(reuseIdentifier)"
    }
    
}

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(withCellType type: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseIdentifier) as? T else {
            fatalError(dequeueError(withIdentifier: type.reuseIdentifier, type: self))
        }
        
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withCellType type: T.Type = T.self, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(dequeueError(withIdentifier: T.reuseIdentifier, type: self))
        }
        
        return cell
    }
}
