//
//  RSS.swift
//  ORMAA RSS reader
//
//  Created by Olivier on 04/04/2018.
//  Copyright © 2018 ORMAA. All rights reserved.
//

import Foundation


class FeedParser: NSObject, XMLParserDelegate
{

    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    private var currentTitle: String = "" {
        didSet
        {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = ""
    {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
    }
    private var currentPubDate: String = "" {
        didSet { currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
        }
    }
    
    
    // Add some content to item array
    
    // will search images in the RSS description. if found, use the first one as image thumbnail, to display the RSS sumary.
    //
    func searchForImages(rssItems: [RSSItem]) -> [RSSItem]{
        
        for item in rssItems {
            let str = item.currentTitle.stringByDecodingHTMLEntities
            //let str2 = item.currentDescription.stringByDecodingHTMLEntities
            item.titleStr = str
            
            item.descriptionStr = HTML_Tool().HtmlToPlainText(html: item.currentDescription)
            
            // search for an image, in description
            // TODO : could be done in better way...
            if let index = item.currentDescription.index(of: "<img src=") {
                let str3 = item.currentDescription.suffix(from: index)
                if let index2 = str3.index(of: ".jpg") {
                    let str4 = (str3.prefix(upTo: index2) + ".jpg").replacingOccurrences(of: "<img src=\"", with: "")
                    //print(str4)
                    item.imageStr = str4
                }
                else {
                    if let index3 = str3.index(of: ".jpeg") {
                        let str4 = (str3.prefix(upTo: index3) + ".jpeg").replacingOccurrences(of: "<img src=\"", with: "")
                        //print(str4)
                        item.imageStr = str4
                    }
                }
                
            }
        }
        return rssItems
    }
    
    
    
    
    // XML parsing area
    
    
    
    
    private var parserCompletionHandler: (([RSSItem]) -> Void)?

    
    // parse a feed content in XML format.
    // Call completion handler with array of RSSItem
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?)
    {
        self.parserCompletionHandler = completionHandler
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
        guard let data = data else {
            if let error = error {
                print(error)
            }
            return
        }
        // parse xml data
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
        }
        task.resume()
    
}
    
    // XML Parser Delegate

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // we assign the name of the element to currentElement,
        //if the item tag is found, we reset the temporary variables of title, description and pubdate for later use
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
        }
        
    }
    
    // when the value of an element is found, this method gets called with a string representation of part of the characters of the current element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "description" : currentDescription += string
        case "pubDate": currentPubDate += string default: break }
        
    }
    // when we reach the closing tag /item is found, this method gets called
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, description: currentDescription, pubDate: currentPubDate)
            rssItems += [rssItem]
            
        }
        
    }
    
    // xml content parsed until the end of document.
    func parserDidEndDocument(_ parser: XMLParser) {
        
        // do the process in background, it is long :o)
        DispatchQueue.global(qos: .background).async { //[weak self] in

            // update the array by adding images url, when available
            let rssItemArray = self.searchForImages(rssItems: self.rssItems)
            // Return the parsed rssitems array
            self.parserCompletionHandler?(rssItemArray)
        }
    }
}





