//
//  UITableView+Extensions.swift
//  HarshDemoPractical
//
//  Created by My Mac Mini on 09/02/24.
//

import Foundation
import UIKit
extension UITableView {
    
    func bottomIndicatorView() -> UIActivityIndicatorView{
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil {
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 80)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            
            if #available(iOS 13.0, *) {
                activityIndicatorView.style = .large
            } else {
                // Fallback on earlier versions
                activityIndicatorView.style = .whiteLarge
            }
            
            activityIndicatorView.color = .label
            activityIndicatorView.hidesWhenStopped = true
            
            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        }
        else {
            return activityIndicatorView
        }
    }
    
    func addLoading(_ indexPath:IndexPath ){
        bottomIndicatorView().startAnimating()
    }
    
    func stopLoading() {
        if self.tableFooterView != nil {
            self.bottomIndicatorView().stopAnimating()
            self.tableFooterView = nil
        }
        else {
            self.tableFooterView = nil
        }
    }
}

extension UserDefaults {
    func setCustomModelArray<T: Encodable>(_ value: [T], forKey key: String) {
        do {
            let encodedData = try JSONEncoder().encode(value)
            self.set(encodedData, forKey: key)
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    func customModelArray<T: Decodable>(forKey key: String) -> [T]? {
        if let encodedData = self.data(forKey: key) {
            do {
                let decodedData = try JSONDecoder().decode([T].self, from: encodedData)
                return decodedData
            } catch {
                print("Error decoding data: \(error)")
                return nil
            }
        }
        return nil
    }
}
