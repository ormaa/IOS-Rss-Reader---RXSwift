//
//  ViewController.swift
//  ORMAA RSS reader
//
//  Created by Olivier on 04/04/2018.
//  Copyright © 2018 ORMAA. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // start activity animation
        activity.startAnimating()

        // init tableview
        tableView.register(UINib(nibName: "RSS_Cell", bundle: nil), forCellReuseIdentifier: "RSS_Cell")
        //tableView.delegate = nil // self
        //tableView.dataSource = nil //self
        
        // init tableview selection ( click ) on cell event
        // TODO : this need to be initialized somewhere else.
        tableView.rx
            .modelSelected(RSSItem.self)
            .subscribe(onNext:  { value in
                print("Tapped `\(value.titleStr)`")
            })
            .disposed(by: disposeBag)
        
        // manage RSS feed
        load_Parse_RSSFeed()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    // load RSS feed and parse xml values, format + filter html "description" content.
    func load_Parse_RSSFeed() {
        // some RSS feed URL
        let urlStr = "https://megaflux.macg.co/"
        
        // Parse RSS feeds
        let parser = FeedParser()
        parser.parseFeed(url: urlStr ) { (RSSItems) in
            print("RSS feeds parsed")
            
            // Define the viewmodel
            self.setupTableViewBinding(RSSItems: RSSItems)
            
            // Stop the activity animation
            DispatchQueue.main.async {
                self.activity.stopAnimating()
                self.activity.isHidden = true
            }
        }
    }
    
    
    

    private let disposeBag = DisposeBag()

    private func setupTableViewBinding(RSSItems: [RSSItem]) {
        
        // set cells in tableview, need to be in main thread
        DispatchQueue.main.async {

            // bind the rss items array to the tableview.
            let viewModel = Observable.just(RSSItems)
            viewModel.bind(to:  self.tableView.rx.items(cellIdentifier: "RSS_Cell")) { (row, item: RSSItem, cell: RSS_Cell_View) in
                
                // Create a cell
                
                // title
                cell.title.text = item.titleStr
                // description, limited to 200 characters
                let str = item.descriptionStr
                let strMax = str.count < 200 ? str.count : 200
                let indexEndOfText = str.index(str.startIndex, offsetBy: strMax)
                cell.desc.text = String(item.descriptionStr[..<indexEndOfText])
        
                // image, if exist, and when downloaded
                cell.imageData = item.imageData.value
        
                }.addDisposableTo(self.disposeBag)
            
            
            
        }
    }
    

}

