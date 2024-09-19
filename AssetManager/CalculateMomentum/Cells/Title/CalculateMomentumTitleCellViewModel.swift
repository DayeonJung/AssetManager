//
//  CalculateMomentumTitleCellViewModel.swift
//  AssetManager
//
//  Created by 정다연 on 8/27/24.
//

import Foundation
import RxSwift
import RxCocoa

class CalculateMomentumTitleCellViewModel {
    
    private let model: CalculateMomentumTitleCellModel
    
//    let indices: Driver<String>
    
    init(model: CalculateMomentumTitleCellModel) {
        self.model = model
        
//        indices = model.indicesInfo
//            .map  {
//                $0.indices
//                    .map { "\($0.marketName) \($0.index)" }.joined(separator: "\n")
//            }
//            .asDriver(onErrorJustReturn: "")
    }
}

class CalculateMomentumTitleCellModel {
    
    private let disposeBag = DisposeBag()
    
    init() {
        
    }
}
