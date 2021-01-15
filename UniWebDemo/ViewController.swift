//
//  ViewController.swift
//  UniWebDemo
//
//  Created by Sergey Monastyrskiy on 15.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel: ViewModelType = ViewModel()
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var btcRateLabel: UILabel!
    @IBOutlet var labelsCollection: [UILabel]!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var exchangerSegmentedControl: UISegmentedControl!
        
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.isHidden = true
        }
    }
        
    
    // MARK: - Class functions
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Bitcoin rate"
    }
    
    
    // MARK: - Custom fuctions
    func bind() {
        viewModel.isLoading
            .subscribe(onNext: { (status) in
                self.spinner.isHidden = !status
                self.currencySegmentedControl.isEnabled = status
                self.exchangerSegmentedControl.isEnabled = status
            },
            onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)

        viewModel.rate
            .filter({ $0.type == "sell" || $0.type == nil })
            .subscribe(onNext: { (rateValue) in
                self.btcRateLabel.isHidden = false
                self.btcRateLabel.text = String(format: "%.6f", rateValue.price.doubleValue ?? 0.0)
                
                // Change text color
                UIView.transition(with: self.btcRateLabel,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.setupLabelsColor(byIndex: rateValue.isRise)
                                  },
                                  completion: {_ in
                                    self.spinner.isHidden = true
                                  })
            },
            onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLabelsColor(byIndex index: Bool? = false) {
        labelsCollection.forEach({ $0.textColor = index ?? false ? .green : .red })
    }
    
    // MARK: - Actions
    @IBAction func changeCurrency(_ sender: UISegmentedControl) {
        viewModel.changeSelectedCurrency(index: sender.selectedSegmentIndex)
    }
    
    @IBAction func changeExchanger(_ sender: UISegmentedControl) {
        viewModel.changeSelectedExchanger(index: sender.selectedSegmentIndex)
    }
}
