//
//  NutritionModel.swift
//  Nutrition Analysis
//
//  Created by mohamed mahmoud helmy on 7/3/21.
//

import Foundation

// MARK: - NutritionModel
struct NutritionModel: Codable {
    let uri: String?
    let yield, calories: Int?
    let totalWeight: Double?
    let dietLabels, healthLabels: [String]?
    let totalNutrients, totalDaily: [String: TotalDaily]?
    let totalNutrientsKCal: TotalNutrientsKCal?
}

// MARK: - TotalDaily
struct TotalDaily: Codable {
    let label: String?
    let quantity: Double?
    let unit: String?
}

// MARK: - TotalNutrientsKCal
struct TotalNutrientsKCal: Codable {
    let enercKcal, procntKcal, fatKcal, chocdfKcal: TotalDaily?

    enum CodingKeys: String, CodingKey {
        case enercKcal = "ENERC_KCAL"
        case procntKcal = "PROCNT_KCAL"
        case fatKcal = "FAT_KCAL"
        case chocdfKcal = "CHOCDF_KCAL"
    }
}
