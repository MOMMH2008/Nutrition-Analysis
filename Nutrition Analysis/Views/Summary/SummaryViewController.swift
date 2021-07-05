//
//  SummaryViewController.swift
//  Nutrition Analysis
//
//  Created by mohamed mahmoud helmy on 7/4/21.
//

import UIKit
import RxCocoa
import RxSwift

class SummaryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var analyzeString : Driver<String> = Observable.just("dummy").asDriver(onErrorJustReturn: "dummy")

    var summaryViewModel: SummaryViewModel!
    let disposeBag = DisposeBag()

    var currentNutritionModels = [NutritionCellData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.title = "Summary breakdown"
        summaryViewModel = SummaryViewModel(query: self.analyzeString, nutritionService: NutritionStore.shared)

        summaryViewModel.nutritions.drive(onNext: {[unowned self] (data) in
            self.currentNutritionModels = data
            self.tableView.reloadData()
        }).disposed(by: disposeBag)

        setupTableView()
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "SummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "SummaryTableViewCell")
    }

}

extension SummaryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentNutritionModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell", for: indexPath) as! SummaryTableViewCell

        cell.configure(data: currentNutritionModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    @IBAction func totalNutritionClicked(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TotalNutritionViewController") as? TotalNutritionViewController

        vc?.analyzeString = analyzeString

        self.navigationController?.pushViewController(vc!, animated: true)

    }

}

