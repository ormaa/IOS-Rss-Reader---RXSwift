//
//  RSSItem.swift
//  ORMAA RSS reader
//
//  Created by Olivier on 16/04/2018.
//  Copyright © 2018 ORMAA. All rights reserved.
//

import Foundation
import RxSwift

class RSSItem {
    var currentTitle = ""
    var currentDescription = ""
    var currentPubDate = ""
    
    var titleStr = ""
    var descriptionStr = ""
    
    var imageStr: String? {
        didSet {
            if imageStr != nil && imageStr != "" {
                HTML_Tool().downloadImage(url: imageStr!, completion: { (error, message, data) in
                    if error == "" {
                        if data != nil {
                            self.imageData.value = data
                        }
                    }
                })
            }
        }
    }
    var imageData = Variable<Data?>(nil)
    
    init(title: String, description: String, pubDate: String) {
        self.currentTitle = title
        self.currentPubDate = pubDate
        self.currentDescription = description
    }
}

