//
//  ViewController_Tableview.swift
//  ORMAA RSS reader
//
//  Created by Olivier on 05/04/2018.
//  Copyright © 2018 ORMAA. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func downloadImage(url: String, completion:@escaping (_ error: String, _ message: String, _ data: Data?) -> Void) {
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error)
                    completion(error.localizedDescription, "", nil)
                }

                print("ko")
                return
            }
            print("ok")
            completion("", "ok", data)
        }
        task.resume()
    }
    
    
    
    // Table view area
    
    // return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssItems.count
    }
    
    // display row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Instantiate a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSS_Cell") as! RSS_Cell_View
        let item  = self.rssItems[indexPath.row]
        cell.title.text = item.titleStr
        let str = item.descriptionStr
        //let indexStartOfText = str.index(str.startIndex, offsetBy: 0)
        let strMax = str.count < 200 ? str.count : 200
        let indexEndOfText = str.index(str.startIndex, offsetBy: strMax)
        cell.desc.text = String(item.descriptionStr[..<indexEndOfText])
        if item.imageStr != "" {
            downloadImage(url: item.imageStr, completion: { (error, message, data) in
                if error == "" {
                    if data != nil {
                        let img = UIImage(data: data!)
                        if img != nil {
                            DispatchQueue.main.async {
                                cell.thumbnail.image = img
                            }
                        }
                    }
                }
            })
        }
        
        
        
        return cell
    }
    
    // Highlight selected row
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
    }
    // unHighlight selected row
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
    }
    
    // select row
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = rssItems[indexPath.row]
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 13) {
            // open a web page
        }
    }
    
    // Allow or disable deletion of rows
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
//        if tableView == objectsTableView {
//            return .delete
//        }
        
        return .none
    }
    
    
//    // Delete
//    //
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete  {
//            print("Delete ")
//        }
//    }
    
    
    
    
    
}
