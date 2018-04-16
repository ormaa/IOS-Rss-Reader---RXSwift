//
//  ViewController_Tableview.swift
//  ORMAA RSS reader
//
//  Created by Olivier on 05/04/2018.
//  Copyright © 2018 ORMAA. All rights reserved.
//

import Foundation
import UIKit
// UITableViewDataSource, UITableViewDelegate
extension ViewController  {
    
    
    // Table view area
    
    // return number of rows
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if viewModel == nil {
//            return 0
//        }
//        return viewModel!.RSS_items.value.count
//    }
    
    // display row
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        // Instantiate a cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "RSS_Cell") as! RSS_Cell_View
//
//        // get an item in the viewmodel
//        let item  = viewModel!.RSS_items.value[indexPath.row]
//        // set some fixed values. viewmodel is not interesting here...
//
//        // title
//        cell.title.text = item.titleStr
//
//        // description, limited to 200 characters
//        let str = item.descriptionStr
//        let strMax = str.count < 200 ? str.count : 200
//        let indexEndOfText = str.index(str.startIndex, offsetBy: strMax)
//        cell.desc.text = String(item.descriptionStr[..<indexEndOfText])
//
//        // image, if exist, and when downloaded
//        cell.imageData = item.imageData.value
//
//        return cell
//    }
    
//    // Highlight selected row
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//
//    }
//    // unHighlight selected row
//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//
//    }
    
    // select row
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("row selected: " + String(describing: indexPath.row))
//
//        //let item = rssItems[indexPath.row]
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 13) {
//            // TODO : open a web page with the RSS details
//        }
//    }
    
//    // Allow or disable deletion of rows
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
////        if tableView == objectsTableView {
////            return .delete
////        }
//        return .none
//    }
    
    
//    // Delete
//    //
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete  {
//            print("Delete ")
//        }
//    }
    
    
    
    
    
}
