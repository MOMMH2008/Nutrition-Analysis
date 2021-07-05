//
//  Nutrition_AnalysisTests.swift
//  Nutrition AnalysisTests
//
//  Created by mohamed mahmoud helmy on 7/3/21.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
@testable import Nutrition_Analysis

class NutritionServiceMock: NutritionService {

    func fetchOneNutrition(param: String) -> Observable<NutritionModel> {
        return Observable.just(NutritionModel.init(uri: nil, yield: nil, calories: 1000, totalWeight: nil, dietLabels: nil, healthLabels: nil, totalNutrients: nil, totalDaily: nil, totalNutrientsKCal: nil))
    }

    func fetchTotalNutrition(params: [String]) -> Observable<NutritionModel> {
        return Observable.just(NutritionModel.init(uri: nil, yield: nil, calories: 1000, totalWeight: nil, dietLabels: nil, healthLabels: nil, totalNutrients: nil, totalDaily: nil, totalNutrientsKCal: nil))
    }
}

class Nutrition_AnalysisTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModel() throws {
        let disposeBag = DisposeBag()
        let viewModel = SummaryViewModel(
            query: Observable
                .just("1 cup rice\n3 oz chickpeas")
                .asDriver(onErrorJustReturn: "NONE"),
            nutritionService: NutritionServiceMock())

        let correctlySeparated = XCTestExpectation()
        let allAPICalled = XCTestExpectation()

        viewModel.nutritions.asObservable().subscribe(onNext: {
            if $0[0].foodRecipe == "1 cup rice" && $0[1].foodRecipe == "3 oz chickpeas" {
                correctlySeparated.fulfill()
            }
        }).disposed(by: disposeBag)
        viewModel.nutritions.asObservable().flatMap { Observable.from($0) }
            .flatMap { return $0.nutritionModelSource }
            .reduce(0, accumulator: { current, model in
                if model.calories == 1000 { return current + 1 } else { return current }
            })
            .subscribe(onNext: { count in
                if count == 2 { allAPICalled.fulfill() }
            })
            .disposed(by: disposeBag)

        wait(for: [allAPICalled, correctlySeparated], timeout: 10)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
