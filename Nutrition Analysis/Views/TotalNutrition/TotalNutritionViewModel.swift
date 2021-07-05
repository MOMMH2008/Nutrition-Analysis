//
//  TotalNutritionViewModel.swift
//  Nutrition Analysis
//
//  Created by mohamed mahmoud helmy on 7/4/21.
//

import Foundation
import RxSwift
import RxCocoa

class TotalNutritionViewModel {
    let totalNutrition: Observable<NutritionModel>

    init(analyzeString: Driver<String>, nutritionService: NutritionService) {
        totalNutrition = analyzeString.asObservable().flatMap { string in
            nutritionService.fetchTotalNutrition(params: string.components(separatedBy: .newlines))
        }
    }

}
