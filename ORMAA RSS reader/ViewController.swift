//
//  ViewController.swift
//  ORMAA RSS reader
//
//  Created by Olivier on 04/04/2018.
//  Copyright © 2018 ORMAA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    
    var rssItems = [RSSItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init tableview
        tableView.register(UINib(nibName: "RSS_Cell", bundle: nil), forCellReuseIdentifier: "RSS_Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        activity.startAnimating()
        
        // Parse RSS feeds
        let parser = FeedParser()
        parser.parseFeed(url: "https://megaflux.macg.co/") { (RSSItems) in
            self.rssItems = RSSItems
            // reload a tableview ?
            print("RSS feeds parsed")
            
            DispatchQueue.global(qos: .background).async { //[weak self] in
                for item in self.rssItems {
                    let str = item.currentTitle.stringByDecodingHTMLEntities
                    //print(str)
                    let str2 = item.currentDescription.stringByDecodingHTMLEntities
                    //print(str2)
                    item.titleStr = str
//                    item.descriptionStr = str2
                    
                    item.descriptionStr = self.HtmlToPlainText(html: item.currentDescription)
                    
                    // search for an image, in description
                    if let index = item.currentDescription.index(of: "<img src=") {
                        let str3 = item.currentDescription.suffix(from: index)
                        if let index2 = str3.index(of: ".jpg") {
                            let str4 = (str3.prefix(upTo: index2) + ".jpg").replacingOccurrences(of: "<img src=\"", with: "")
                            print(str4)
                            item.imageStr = str4
                        }
                        else {
                            if let index3 = str3.index(of: ".jpeg") {
                                let str4 = (str3.prefix(upTo: index3) + ".jpeg").replacingOccurrences(of: "<img src=\"", with: "")
                                print(str4)
                                item.imageStr = str4
                            }
                        }
                        
                    }
                    
//                    var desc = str;
//                    var i = desc.IndexOf("<img src=");
//                    if ( i != -1 ) {
//                        var index2 = desc.IndexOf(".jpg", i);
//                        if ( index2 != -1 && index2 > i )
//                        {
//                            // TODO : this is dangerous, because the length of desc has to be chacked before doing that.
//                            //
//                            var img = desc.Substring(i + 10, index2 - i - 6);
//                            feed.imageURL = img;
//                            //feed.ImageUrl = img;
//
//                        }
//                    }
//                }
                    
                }
                // REload the tableView
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
                }
            }
            


        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // convert HTML string into plain text string, without any tag or formatting info
    //
    func HtmlToPlainText( html: String) -> String
    {
        let tagWhiteSpace = "(>|$)(|\n|\r)+<"    //matches one or more (white space or line breaks) between '>' and '<'
        let stripFormatting = "<[^>]*(>|$)"      //match any character between '<' and '>', even when end tag is missing
        let lineBreak = "<(br|BR){0,1}/{0,1}>"   //matches: <br>,<br/>,<br />,<BR>,<BR/>,<BR />

        // convert HTML with escaped character into HTML with accentued characters
        let text = html.stringByDecodingHTMLEntities;
        
        var stringlength = text.count
        let regex:NSRegularExpression = try! NSRegularExpression(pattern: tagWhiteSpace, options: NSRegularExpression.Options.caseInsensitive)
        var modString = regex.stringByReplacingMatches(in: text, range: NSMakeRange(0, stringlength), withTemplate: "")
        print("First filter\n")
        print(modString)

        stringlength = modString.count
        let regex3:NSRegularExpression = try! NSRegularExpression(pattern: lineBreak, options: NSRegularExpression.Options.caseInsensitive)
        modString = regex3.stringByReplacingMatches(in: modString, range: NSMakeRange(0, stringlength), withTemplate: "")
        print("Second filter \n")
        print(modString)
        
        stringlength = modString.count
        let regex2:NSRegularExpression = try! NSRegularExpression(pattern: stripFormatting, options: NSRegularExpression.Options.caseInsensitive)
        modString = regex2.stringByReplacingMatches(in: modString, range: NSMakeRange(0, stringlength), withTemplate: "")
        print("third filter \n")
        print(modString)

        print("completed")
        
        return modString
    }
    
    func old(html: String) {
//        var tagWhiteSpace = @"(>|$)(\W|\n|\r)+<"    //matches one or more (white space or line breaks) between '>' and '<'
//        var stripFormatting = @"<[^>]*(>|$)"        //match any character between '<' and '>', even when end tag is missing
//        var lineBreak = @"<(br|BR)\s{0,1}\/{0,1}>"  //matches: <br>,<br/>,<br />,<BR>,<BR/>,<BR />

        var tagWhiteSpace = "(>|$)(|\n|\r)+<"    //matches one or more (white space or line breaks) between '>' and '<'
        var stripFormatting = "<[^>]*(>|$)"        //match any character between '<' and '>', even when end tag is missing
        var lineBreak = "<(br|BR){0,1}/{0,1}>"  //matches: <br>,<br/>,<br />,<BR>,<BR/>,<BR />
        
        var lineBreakRegex = try? NSRegularExpression(pattern: tagWhiteSpace)
        
        var stripFormattingRegex = try? NSRegularExpression(pattern: tagWhiteSpace)
        var tagWhiteSpaceRegex = try? NSRegularExpression(pattern: tagWhiteSpace)
        
//    var lineBreakRegex = new Regex(lineBreak, RegexOptions.Multiline);
//    var stripFormattingRegex = new Regex(stripFormatting, RegexOptions.Multiline);
//    var tagWhiteSpaceRegex = new Regex(tagWhiteSpace, RegexOptions.Multiline);
    
    var text = html;
    //Decode html specific characters
    text = text.stringByDecodingHTMLEntities // System.Net.WebUtility.HtmlDecode(text);
    
    // olivier added : convert \n<p>... into <p>...
    //text = tagWhiteSpaceRegex.Replace(text, "<");
//    let results = tagWhiteSpaceRegex!.matches(in: text, range: NSRange(text.startIndex..., in: text))
//
//    let finalStr = results.map {
//            String(text[Range($0.range, in: text)!])
//    }
    
        
        
        
        var myString = text //"DD11 AAA"
        var stringlength = myString.count
        // "^([A-HK-PRSVWY][A-HJ-PR-Y])\\s?([0][2-9]|[1-9][0-9])\\s?[A-HJ-PR-Z]{3}$"
        
        let regex:NSRegularExpression = try! NSRegularExpression(pattern: tagWhiteSpace, options: NSRegularExpression.Options.caseInsensitive)
        var modString = regex.stringByReplacingMatches(in: myString, range: NSMakeRange(0, stringlength), withTemplate: "")
        
        print("resultat filtré \n")
        print(modString)
        stringlength = modString.count
        
        let regex3:NSRegularExpression = try! NSRegularExpression(pattern: lineBreak, options: NSRegularExpression.Options.caseInsensitive)
        modString = regex3.stringByReplacingMatches(in: modString, range: NSMakeRange(0, stringlength), withTemplate: "")
        
        print("resultat filtré \n")
        print(modString)
        stringlength = modString.count


        let regex2:NSRegularExpression = try! NSRegularExpression(pattern: stripFormatting, options: NSRegularExpression.Options.caseInsensitive)
        modString = regex2.stringByReplacingMatches(in: modString, range: NSMakeRange(0, stringlength), withTemplate: "")
        
        print("resultat filtré \n")
        print(modString)

        
        
        print("ok")
        

        
    //Remove tag whitespace/line breaks
    //text = tagWhiteSpaceRegex.Replace(text, "><");
        
    //Replace <br /> with line breaks
    //text = lineBreakRegex.Replace(text, Environment.NewLine);
        
        
    //Strip formatting
    //text = stripFormattingRegex.Replace(text, string.Empty);
    
        print("ok")

    }
    


}

