//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
protocol CoinManagerDelegate {
    func didFailWithError(error:Error)
    func didUpdateCurrency(price: String,currency : String)
}
struct CoinManager {
    var delegate : CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "31E7F706-E312-4F01-B87D-9DE763DAA469"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    func getCoinPrice(for currency : String){
        
        let urlString = "\(baseURL)/\(currency)?APIKEY=\(apiKey)"
        //1.Create a URL
        if  let url = URL(string: urlString){
            
            //2.Create a URLSession
            let session = URLSession(configuration: .default)
            //3.Assign a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    
                    if  let bitePrice = parseJSON(currencyData:safeData){
                        print(bitePrice)
                        print(currency)
                        let bitePriceString = String(format:"%.2f",bitePrice)
                        self.delegate?.didUpdateCurrency(price: bitePriceString, currency: currency )
                    }
                }
            }
            //4.start the Task
            task.resume()
            
        }
    }
    
    func parseJSON(currencyData data:Data)->Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(coinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
