//
//  HTML_Tool.swift
//  ORMAA RSS reader
//
//  Created by Olivier on 16/04/2018.
//  Copyright © 2018 ORMAA. All rights reserved.
//

import Foundation

class HTML_Tool {
    
    
    // download an image from internet.
    //
    func downloadImage(url: String, completion:@escaping (_ error: String, _ message: String, _ data: Data?) -> Void) {
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error)
                    completion(error.localizedDescription, "", nil)
                }
                
                //print("ko")
                return
            }
            //print("ok")
            completion("", "ok", data)
        }
        task.resume()
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
        //print("First filter\n")
        //print(modString)
        
        stringlength = modString.count
        let regex3:NSRegularExpression = try! NSRegularExpression(pattern: lineBreak, options: NSRegularExpression.Options.caseInsensitive)
        modString = regex3.stringByReplacingMatches(in: modString, range: NSMakeRange(0, stringlength), withTemplate: "")
        //print("Second filter \n")
        //print(modString)
        
        stringlength = modString.count
        let regex2:NSRegularExpression = try! NSRegularExpression(pattern: stripFormatting, options: NSRegularExpression.Options.caseInsensitive)
        modString = regex2.stringByReplacingMatches(in: modString, range: NSMakeRange(0, stringlength), withTemplate: "")
        //print("third filter \n")
        //print(modString)
        
        //print("completed")
        
        return modString
    }
    
    
    
//    // not used anymore
//    //
//    func old(html: String) {
//        //        var tagWhiteSpace = @"(>|$)(\W|\n|\r)+<"    //matches one or more (white space or line breaks) between '>' and '<'
//        //        var stripFormatting = @"<[^>]*(>|$)"        //match any character between '<' and '>', even when end tag is missing
//        //        var lineBreak = @"<(br|BR)\s{0,1}\/{0,1}>"  //matches: <br>,<br/>,<br />,<BR>,<BR/>,<BR />
//        
//        var tagWhiteSpace = "(>|$)(|\n|\r)+<"    //matches one or more (white space or line breaks) between '>' and '<'
//        var stripFormatting = "<[^>]*(>|$)"        //match any character between '<' and '>', even when end tag is missing
//        var lineBreak = "<(br|BR){0,1}/{0,1}>"  //matches: <br>,<br/>,<br />,<BR>,<BR/>,<BR />
//        
//        var lineBreakRegex = try? NSRegularExpression(pattern: tagWhiteSpace)
//        
//        var stripFormattingRegex = try? NSRegularExpression(pattern: tagWhiteSpace)
//        var tagWhiteSpaceRegex = try? NSRegularExpression(pattern: tagWhiteSpace)
//        
//        //    var lineBreakRegex = new Regex(lineBreak, RegexOptions.Multiline);
//        //    var stripFormattingRegex = new Regex(stripFormatting, RegexOptions.Multiline);
//        //    var tagWhiteSpaceRegex = new Regex(tagWhiteSpace, RegexOptions.Multiline);
//        
//        var text = html;
//        //Decode html specific characters
//        text = text.stringByDecodingHTMLEntities // System.Net.WebUtility.HtmlDecode(text);
//        
//        // olivier added : convert \n<p>... into <p>...
//        //text = tagWhiteSpaceRegex.Replace(text, "<");
//        //    let results = tagWhiteSpaceRegex!.matches(in: text, range: NSRange(text.startIndex..., in: text))
//        //
//        //    let finalStr = results.map {
//        //            String(text[Range($0.range, in: text)!])
//        //    }
//        
//        
//        
//        
//        var myString = text //"DD11 AAA"
//        var stringlength = myString.count
//        // "^([A-HK-PRSVWY][A-HJ-PR-Y])\\s?([0][2-9]|[1-9][0-9])\\s?[A-HJ-PR-Z]{3}$"
//        
//        let regex:NSRegularExpression = try! NSRegularExpression(pattern: tagWhiteSpace, options: NSRegularExpression.Options.caseInsensitive)
//        var modString = regex.stringByReplacingMatches(in: myString, range: NSMakeRange(0, stringlength), withTemplate: "")
//        
//        print("resultat filtré \n")
//        print(modString)
//        stringlength = modString.count
//        
//        let regex3:NSRegularExpression = try! NSRegularExpression(pattern: lineBreak, options: NSRegularExpression.Options.caseInsensitive)
//        modString = regex3.stringByReplacingMatches(in: modString, range: NSMakeRange(0, stringlength), withTemplate: "")
//        
//        print("resultat filtré \n")
//        print(modString)
//        stringlength = modString.count
//        
//        
//        let regex2:NSRegularExpression = try! NSRegularExpression(pattern: stripFormatting, options: NSRegularExpression.Options.caseInsensitive)
//        modString = regex2.stringByReplacingMatches(in: modString, range: NSMakeRange(0, stringlength), withTemplate: "")
//        
//        print("resultat filtré \n")
//        print(modString)
//        
//        
//        
//        print("ok")
//        
//        
//        
//        //Remove tag whitespace/line breaks
//        //text = tagWhiteSpaceRegex.Replace(text, "><");
//        
//        //Replace <br /> with line breaks
//        //text = lineBreakRegex.Replace(text, Environment.NewLine);
//        
//        
//        //Strip formatting
//        //text = stripFormattingRegex.Replace(text, string.Empty);
//        
//        print("ok")
//        
//    }
    
    
    
}
