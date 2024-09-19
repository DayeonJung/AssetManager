//
//  TitleView.swift
//  AssetManager
//
//  Created by 정다연 on 8/30/24.
//

import UIKit

class TitleView: BaseView {
    @IBOutlet weak var titleLabel: UILabel!
    
    override open func initCustomView() {
        self.titleLabel.text = "tttttest"
    }
}
