//
//  AnalyzeViewModel.swift
//  Nutrition Analysis
//
//  Created by mohamed mahmoud helmy on 7/4/21.
//

import Foundation
import RxSwift
import RxCocoa

final class AnalyzeViewModel {

    struct Input {
        let analyzeString: Observable<String>
    }

    struct Output {
        let isAnalyzeAllowed: Driver<Bool>
    }

    func configure(input: Input) -> Output {
        let isAnalyzeAllowed = input.analyzeString.map{ !$0.isEmpty }.asDriver(onErrorJustReturn: false)
        return Output(isAnalyzeAllowed: isAnalyzeAllowed)
    }
}
