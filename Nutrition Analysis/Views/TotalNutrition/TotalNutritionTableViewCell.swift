//
//  TotalNutritionTableViewCell.swift
//  Nutrition Analysis
//
//  Created by mohamed mahmoud helmy on 7/5/21.
//

import UIKit

class TotalNutritionTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!

    func configureCell(totalDaily : TotalDaily) {
        self.nameLabel.text = "\(String(describing: totalDaily.label ?? ""))"

        self.quantityLabel.text = "\(String(describing: self.roundDouble(doubleValue: totalDaily.quantity ?? 0))) \(String(describing: totalDaily.unit ?? ""))"
    }

    private func roundDouble(doubleValue: Double) -> Double {
       return Double(round(100*doubleValue)/100)
    }
}
