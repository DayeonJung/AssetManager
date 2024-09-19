//
//  CalculateMomentumModel.swift
//  AssetManager
//
//  Created by 정다연 on 8/29/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class CalculateMomentumModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let fetch = PublishSubject<Void>()
    }
    let input = Input()
    
    private let service: CalculateMomentumService
    
    let token: Observable<String>

    
    init(service: CalculateMomentumService) {
        self.service = service
        self.token = Observable.just("")
    }
}
