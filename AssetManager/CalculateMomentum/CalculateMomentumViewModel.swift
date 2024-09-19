//
//  CalculateMomentumViewModel.swift
//  AssetManager
//
//  Created by 정다연 on 8/29/24.
//

import Foundation
import RxSwift
import RxCocoa

class CalculateMomentumViewModel {
    private let disposeBag = DisposeBag()
    private let model: CalculateMomentumModel
    
    let sections: Driver<[CalculateMomentumSectionModel]>

    init(model: CalculateMomentumModel) {
        self.model = model
        sections = Self.sections(with: model.token)
    }
}

extension CalculateMomentumViewModel {
    private static func sections(with info: Observable<String>) -> Driver<[CalculateMomentumSectionModel]> {
        return info
            .flatMap { info -> Observable<[CalculateMomentumSectionModel]> in
                let sectionModel = CalculateMomentumSectionModel.calculateSection(
                    items: [
                        .calculate(
                            viewModel: CalculateMomentumTitleCellViewModel(
                                model: CalculateMomentumTitleCellModel()
                            )
                        )
                    ]
                )
                return Observable.just([sectionModel])
            }
            .asDriver(onErrorJustReturn: [])
    }
}
