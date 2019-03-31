//
//  ViewController.swift
//  Notrich
//
//  Created by ADG RIT 4 on 31/03/19.
//  Copyright © 2019 ADG RIT 4. All rights reserved.
//

import UIKit
import SwiftChart
class ViewController: UIViewController, ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        //
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        //
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        //
    }
    
    
    @IBOutlet weak var ww: Chart!
    
    @IBOutlet weak var kingsson: UISegmentedControl!
    @IBOutlet weak var queen: UILabel!
    @IBAction func king(_ sender: Any) {
        getprice()
     
    }
    var arrayUSD: [Double] = [4000.00]
    var arrayINR: [Double] = [20000.00]
    struct Prices: Decodable{
        let bpi: [String: Bpi]
    }

    struct Bpi: Decodable{
        let code: String?
        let rate_float: Double?
        
    }
    func updateChart(usdValue: Double, priceArray: inout [Double]){
        if priceArray.count > 20{
            priceArray.remove(at: 0)
        }
        priceArray.append(usdValue)
        let series = ChartSeries(priceArray)
        ww.removeAllSeries()
        ww.add(series)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getprice()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(getprice), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func getprice(){
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/INR.json" )
        URLSession.shared.dataTask(with: url!){ data, responce, error in
        if error != nil{
            print(error!.localizedDescription)
        
        }
            if let data = data{
                let price = try? JSONDecoder().decode(Prices.self, from: data)
                let bpi = price?.bpi
                let rateUSD = bpi!["USD"]!.rate_float!
                let rateINR = bpi!["INR"]!.rate_float
                DispatchQueue.main.async {
                    if self.kingsson.selectedSegmentIndex == 0{
                      self.queen.text = "\(rateUSD)"
                        self.updateChart(usdValue: rateUSD, priceArray: &self.arrayUSD)
                    }
                else{
                        self.queen.text = "\(rateINR)"
                        self.updateChart(usdValue: rateINR!, priceArray: &self.arrayINR)
                }
                
            }
        

}
}.resume()
}
}
