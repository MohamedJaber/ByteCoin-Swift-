//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    var coinManager=CoinManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource=self
        currencyPicker.delegate=self
        coinManager.delegate=self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedCurrency=coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
    
   /* func didUpdateCurrencyVC(currency: BitcoinModel){
        DispatchQueue.main.async {
            self.bitcoinLabel.text=String(format:"%.0f", currency.rate)
            self.currencyLabel.text=currency.currencyName
        }
    }*/
}
//MARK: - BitcoinManagerDelegate

extension ViewController: BitcoinManagerDelegate{
    func didUpdateCurrency(currency: BitcoinModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text=String(format:"%.0f", currency.rate)
            self.currencyLabel.text=currency.currencyName
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
