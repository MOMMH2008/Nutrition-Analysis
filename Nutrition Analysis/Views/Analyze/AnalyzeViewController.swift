//
//  AnalyzeViewController.swift
//  Nutrition Analysis
//
//  Created by mohamed mahmoud helmy on 7/4/21.
//

import UIKit
import RxSwift
import RxCocoa

class AnalyzeViewController: UIViewController {

    private var viewModel: AnalyzeViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var analyzeText: UITextView!
    @IBOutlet weak var analyzeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AnalyzeViewModel()
        analyzeButton.setTitleColor(.systemIndigo, for: .normal)
        analyzeButton.setTitleColor(.systemGray, for: .disabled)
        bindViewModel()
    }

func bindViewModel() {
    let outputs = viewModel.configure(input: AnalyzeViewModel.Input(analyzeString: analyzeText.rx.text.orEmpty.asObservable()))
    outputs.isAnalyzeAllowed.drive(analyzeButton.rx.isEnabled).disposed(by: disposeBag)

    analyzeButton.rx.tap.bind {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SummaryViewController") as? SummaryViewController

        vc?.analyzeString = (self.analyzeText.rx.text.orEmpty.asObservable()).asDriver(onErrorJustReturn: "")
        self.navigationController?.pushViewController(vc!, animated: true)
    }.disposed(by: disposeBag)
}
}

