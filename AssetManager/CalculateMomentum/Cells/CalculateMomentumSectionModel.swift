//
//  CalculateMomentumSectionModel.swift
//  AssetManager
//
//  Created by 정다연 on 8/30/24.
//

import Foundation
import RxDataSources

enum CalculateMomentumSectionModel {
    case calculateSection(items: [CalculateMomentumSectionItem])
}

enum CalculateMomentumSectionItem {
    case calculate(viewModel: CalculateMomentumTitleCellViewModel)
}

extension CalculateMomentumSectionModel: SectionModelType {
    typealias Item = CalculateMomentumSectionItem
    
    var items: [CalculateMomentumSectionItem] {
        switch  self {
            case .calculateSection(let items):
                return items
        }
    }
    
    init(original: Self, items: [Item]) {
        self = original
    }
}
