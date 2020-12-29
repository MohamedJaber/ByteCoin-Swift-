//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol BitcoinManagerDelegate {
    func didUpdateCurrency(currency: BitcoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "19F49460-85DD-47A7-8849-80A89C9DC62F"
    var delegate: BitcoinManagerDelegate?
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
        
    }
    func performRequest(with urlString: String){
        if let url=URL(string: urlString){
        let session=URLSession(configuration: .default)
        let task=session.dataTask(with: url) { (data, response, error) in
            if error != nil{
                return
            }
            if let safeData=data{
                let currency=self.parseJSON(safeData)
                delegate?.didUpdateCurrency(currency: currency!)
              /*  let currencyVC=ViewController()
                currencyVC.didUpdateCurrencyVC(currency: currency)*/
            }
        }
            task.resume()
        }
    }
    func parseJSON(_ currencyData: Data)->BitcoinModel?{
        let decoder=JSONDecoder()
        do{
            let decodedData = try decoder.decode(BitcoinData.self, from: currencyData)
            let currencyName=decodedData.asset_id_quote
            let rate=decodedData.rate
            let currency=BitcoinModel(currencyName: currencyName, rate: rate)
            return currency
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
