//
//  SummaryTableViewCell.swift
//  Nutrition Analysis
//
//  Created by mohamed mahmoud helmy on 7/4/21.
//

import UIKit
import RxSwift

struct NutritionCellData {
    let foodRecipe: String
    let nutritionModelSource: Observable<NutritionModel>
}

class SummaryTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()


    @IBOutlet weak var qtyLable: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!



    func configure(data: NutritionCellData) {
        disposeBag = DisposeBag()
        // Put loader here
        let foodRecipeArray = data.foodRecipe.components(separatedBy: .whitespaces)
        if foodRecipeArray.count > 0 {
            self.qtyLable.text = foodRecipeArray[0]
        }
        if foodRecipeArray.count > 1 {
            self.unitLabel.text = foodRecipeArray[1]
        }
        if foodRecipeArray.count > 2 {
            self.foodLabel.text = foodRecipeArray[2]
        }
        data.nutritionModelSource
            .observe(on: MainScheduler())
            .subscribe { [weak self] (nutritionModel) in
                self?.caloriesLabel.text = "\(nutritionModel.calories ?? 0) kcal"
                self?.weightLabel.text = "\(Double(round(100*(nutritionModel.totalWeight ?? 0)/100))) g"
                print("CALORIES: \(nutritionModel.calories ?? 0)")
            } onError: { (error) in
                print("ERROR: \(error)")
            }.disposed(by: disposeBag)

    }
}
