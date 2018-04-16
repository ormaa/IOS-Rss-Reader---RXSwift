//
//  RSS_Cell_View.swift
//  ORMAA RSS reader
//
//  Created by Olivier on 05/04/2018.
//  Copyright © 2018 ORMAA. All rights reserved.
//

import Foundation
import UIKit

class RSS_Cell_View: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        
    }
    
}
