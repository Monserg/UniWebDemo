//
//  ViewController.swift
//  UniWebDemo
//
//  Created by Sergey Monastyrskiy on 15.01.2021.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: ViewModelType = ViewModel()
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var exchangerSegmentedControl: UISegmentedControl!
    
    
    // MARK: - Class functions
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.subscribe(currency: "usd", exchanger: "kraken")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Bitcoin rate"
    }
    
    
    // MARK: - Custom fuctions
    func bind() {
        currencySegmentedControl
            .rx
            .selectedSegmentIndex
            .subscribe (onNext: { index in
                print(index)
            })
        
        segmentedControl.rx.selectedSegmentIndex.subscribe (onNext: { index in
                    doSomethingWith(index)
                })
    }
}
