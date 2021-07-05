//
//  TotalNutritionViewController.swift
//  Nutrition Analysis
//
//  Created by mohamed mahmoud helmy on 7/4/21.
//

import UIKit
import RxSwift
import RxCocoa

class TotalNutritionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var analyzeString : Driver<String> = Observable.just("dummy").asDriver(onErrorJustReturn: "dummy")

    var totalDailyArray : [TotalDaily]?
    var totalDaily: [String: TotalDaily]? {
        didSet {
            totalDailyArray = totalDaily?.map { $0.value } ?? []
            tableView.reloadData()
        }
    }

    var disposeBag = DisposeBag()
    var viewModel: TotalNutritionViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Total Nutrition"
        viewModel = TotalNutritionViewModel(analyzeString: analyzeString, nutritionService: NutritionStore.shared)
        viewModel?.totalNutrition
            .observe(on: MainScheduler())
            .subscribe(onNext: {

                self.totalDaily = $0.totalDaily

            }).disposed(by: disposeBag)
    }

}
extension TotalNutritionViewController :UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalDailyArray?.count ?? 0

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TotalNutritionTableViewCell") as! TotalNutritionTableViewCell
        if let totalDailyArray = self.totalDailyArray {
            cell.configureCell(totalDaily: totalDailyArray[indexPath.row])
        }
        return cell
    }

}
