//
//  PracticalTask2VC.swift
//  HarshDemoPractical
//
//  Created by My Mac Mini on 09/02/24.
//

import UIKit

class PracticalTask2VC: UIViewController {
    
    let arrNumbers = [123, 234, 521, 158018, 40848, 408, 58238]
    let arrNames = ["anay", "karan", "sagar", "dinesh", "Amit", "Nikunj", "ajay"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myInput = 23
        let value = findTheLowest(number: myInput)
        print("value: \(value)")
        
    }
    func findTheLowest(number: Int) -> String {
        var indexMatched: [Int] = []
        
        for (index, num) in arrNumbers.enumerated() {
            if String(num).contains(String(number)) {
                indexMatched.append(index)
            }
        }
        
        if indexMatched.count == 1 {
            return arrNames[indexMatched[0]]
        }else if indexMatched.isEmpty {
            return "No name found"
        } else {
            var smallestNameIndex = indexMatched[0]
            for index in indexMatched {
                if arrNames[index] < arrNames[smallestNameIndex] {
                    smallestNameIndex = index
                }
            }
            return arrNames[smallestNameIndex]
        }
    }
    
}
