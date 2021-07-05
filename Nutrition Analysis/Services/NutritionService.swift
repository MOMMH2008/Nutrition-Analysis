//
//  NutritionService.swift
//  Nutrition Analysis
//
//  Created by mohamed mahmoud helmy on 7/3/21.
//

import Foundation
import RxSwift

protocol NutritionService {

    func fetchTotalNutrition(params: [String]) -> Observable<NutritionModel>

    func fetchOneNutrition(param: String) -> Observable<NutritionModel>
}


public enum NutritionError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}

