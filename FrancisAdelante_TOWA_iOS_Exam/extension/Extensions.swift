//
//  Extensions.swift
//  FrancisAdelante_TOWA_iOS_Exam
//
//  Created by Francis Adelante on 2/13/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import CoreData

extension NSError {
    
    class func makeError(appErrorDomain: Int) -> NSError {
        
        var userInfo = [String: String]()
        
        switch appErrorDomain {
        case AppError.ParseError.code:
            userInfo[NSLocalizedDescriptionKey] = AppError.ParseError.message
            return NSError(domain: AppError.domain, code: appErrorDomain, userInfo: userInfo)
        case AppError.DataManagerFetchFail.code:
            userInfo[NSLocalizedDescriptionKey] = AppError.DataManagerFetchFail.message
            return NSError(domain: AppError.domain, code: appErrorDomain, userInfo: userInfo)
        default:
            userInfo[NSLocalizedDescriptionKey] = AppError.UnknownError.message
            return NSError(domain: AppError.domain, code: appErrorDomain, userInfo: userInfo)
        }
        
    }
    
}

extension NSObject {
    
    static func classNameAsString() -> String {
        return String(describing: self)
    }
    
}

extension NSManagedObject {
    
    static func createObjectInContext(context: NSManagedObjectContext) -> NSManagedObject! {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: self), into: context) as NSManagedObject
    }
    
    static func entityDescriptionWithContext(context: NSManagedObjectContext) -> NSEntityDescription! {
        return NSEntityDescription.entity(forEntityName: String(describing: self), in: context)!
    }
    
}

extension UIView {
    
    class func fromNib() -> UIView? {
        guard let selfView = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)![0] as? UIView else {
            return nil
        }
        return selfView
    }
    
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
    
}
extension UIImageView {
    
    func load(url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                    
                }
            }).resume()
        }
    }
}
extension UIView {
    
    func fillSuperview() {
        guard let superview = superview
            else {
                return
        }
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            topAnchor.constraint(equalTo: superview.topAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor)
        ]
        constraints.forEach {
            $0.priority = UILayoutPriority(999)
            $0.isActive = true
        }
    }
    
    @discardableResult
    func addSubviewAndFill(_ subview: UIView, inset: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            subview.topAnchor.constraint(equalTo: topAnchor, constant: inset.top),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left),
            bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: inset.bottom),
            rightAnchor.constraint(equalTo: subview.rightAnchor, constant: inset.right)
        ]
        constraints.forEach {
            $0.isActive = true
        }
        return constraints
    }
    
    @discardableResult
    func addSubviewCenterXY(_ subview: UIView) -> [NSLayoutConstraint] {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            subview.centerXAnchor.constraint(equalTo: centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        constraints.forEach {
            $0.isActive = true
        }
        return constraints
    }
    
    
    
}

extension UIView {
    
    func viewFromOwnedNib(named nibName: String? = nil) -> UIView {
        let bundle = Bundle(for: self.classForCoder)
        return {
            if let nibName = nibName {
                return bundle.loadNibNamed(nibName, owner: self, options: nil)!.last as! UIView
            }
            return bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)!.last as! UIView
            }()
    }
    
    /// Convenience function for creating a view from a nib file.
    /// Returns an instance of the `UIView` subclass that called the function.
    class func instantiateFromNib() -> Self {
        return self.instantiateFromNib(in: Bundle.main)
    }
    
}

fileprivate extension UIView {
    
    /// Creates a `UIView` subclass from a nib file of the same name. If an XIB file of the same name
    /// as the class does not exist and this function is invoked, a fatal error is thrown
    /// since it is a developer error that must definitely be fixed.
    class func instantiateFromNib<T>(in bundle: Bundle) -> T {
        let objects = bundle.loadNibNamed(String(describing: self), owner: self, options: nil)!
        let view = objects.last as! T
        return view
    }
    
}

extension UIImageView {
    
    func loadImg(url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                    
                }
            }).resume()
        }
    }
}
