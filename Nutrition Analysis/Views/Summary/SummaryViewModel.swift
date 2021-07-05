//
//  SummaryViewModel.swift
//  Nutrition Analysis
//
//  Created by mohamed mahmoud helmy on 7/4/21.
//

import Foundation
import RxSwift
import RxCocoa

class SummaryViewModel {

    private let disposeBag = DisposeBag()
    let nutritionService: NutritionService
    let nutritions: Driver<[NutritionCellData]>

    init(query: Driver<String>, nutritionService: NutritionService) {
        self.nutritionService = nutritionService
        nutritions = query.map {
            $0.components(separatedBy: CharacterSet.newlines)
                .map {
                    return NutritionCellData(
                        foodRecipe: $0,
                        nutritionModelSource: nutritionService.fetchOneNutrition(param: $0).share(replay: 1, scope: .forever))
                }
        }
    }
}

