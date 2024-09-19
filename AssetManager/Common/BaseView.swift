//
//  BaseView.swift
//  AssetManager
//
//  Created by 정다연 on 8/30/24.
//

import UIKit

@IBDesignable open class BaseView: UIView {
    @IBOutlet open var containerView: UIView!
    
    open var uiModel:Any?
    
    public init() {
        super.init(frame: .zero)

        self.initialize()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }

    public func initialize() {
//        self.translatesAutoresizingMaskIntoConstraints = false
        
        // first: load the view hierarchy to get proper outlets
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        // next: append the container to our view
        self.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        self.initCustomView()
    }

    open func initCustomView() {
        
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        containerView.prepareForInterfaceBuilder()
    }
}
