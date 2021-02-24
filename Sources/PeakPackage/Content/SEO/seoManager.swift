//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 2/22/21.
//

import Foundation
import SwiftUI
import SwiftSoup

struct scrapedSearchResult{
    var term : String
    var map_ranking : Int?
    var organic_ranking : Int?
}

struct viewableSearchResult{
    
    var id = UUID()
    var term : String
    var organic_rank : String
    var change : Bool?
    
}

public class SEOManager : Manager {
    
    //TODO: change terms eventually based on app type
    static var terms = ["cabinet refinishing", "cabinet refinisher", "cabinet painting", "cabinet painter", "cabinet refacing", "cabinet door replacement", "floor refinishing", "floor sanding", "cabinet color change", "custom color cabinets"]
    
    @Published var rankings : [viewableSearchResult] = []
    @Published var weekbyweek : [SearchRankingforTime] = []
    
    //needs a public
    public override init(){}
    
    func loadRankings(){
        DatabaseDelegate.getSEORankings(completion: {
            rex in
            
            let rankList = rex as! [SearchRankingforTime]
            self.weekbyweek = rankList
            self.calculateChange()
        })
    }
    
    func calculateChange(){
        if weekbyweek.count == 1{
            let first = weekbyweek.first!
            for searchTerm in first.list{
                let result = viewableSearchResult(term: searchTerm.keyword,
                                                  organic_rank: searchTerm.organic_ranking ?? "-",
                                                  change: nil)
                rankings.append(result)
            }
        }else if weekbyweek.count > 1{
            let first = weekbyweek.first!
            let last = weekbyweek.last!
            let timeframe = Int(last.week.digits)
            for searchTerm in first.list{
                for searchTerm2 in last.list{
                    if searchTerm.keyword == searchTerm2.keyword{
                        var change : Bool? = nil
                        if searchTerm.organic_ranking != nil && searchTerm2.organic_ranking != nil{
                            //both have rankings
                            var rank1 = Int(searchTerm.organic_ranking!) ?? 0
                            var rank2 = Int(searchTerm2.organic_ranking!) ?? 0
                            change = rank1 == rank2 ? nil : rank1 > rank2
        
                        }else if searchTerm.organic_ranking == nil && searchTerm2.organic_ranking == nil{
                            //both don't have ranking
                        }else if searchTerm.organic_ranking != nil{
                            //went up
                            change = true
                        }else{
                            //went down
                            change = false
                        }
                        let result = viewableSearchResult(term: searchTerm.keyword,
                                                          organic_rank: searchTerm.organic_ranking ?? "-",
                                                          change: change)
                        rankings.append(result)
                    }
                }
            }
        }else{
            printr("no SEO data")
        }
    }
    
    static func scrapeRankings(){
        let list = findRankings(for: terms)
        setRankings(for: list)
    }
    
    static func setRankings(for results: [scrapedSearchResult]){
        for result in results{
            DatabaseDelegate.setSEORankings(keyword: result.term, mapRanking: result.map_ranking, organicRanking: result.organic_ranking)
        }
    }
    
    static private func findRankings(for terms: [String]) -> [scrapedSearchResult]{
        var searchArray : [scrapedSearchResult] = []
        let baseURL = "https://www.google.com/search?q="
        var searchterms = terms.map({$0.replacingOccurrences(of: " ", with: "+")})
        for term in searchterms{
            let url_str = baseURL + term
            guard let url = URL(string: url_str) else { continue }
            let body = parseHTML(url: url).lowercased()
            //TODO: eventually change to not nhance
            searchArray.append(getSearchPosition(of: "nhance", in: body, searchTerm: term))
        }
        
        return searchArray
    }

    static func matches(for regex: String, in text: String) -> [String] {

        do {
            let regexOptions : NSRegularExpression.Options = [.useUnicodeWordBoundaries]
            let regex = try NSRegularExpression(pattern: "\\b" + regex + "\\b", options: regexOptions)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    static func getSearchPosition(of str: String, in html: String, searchTerm: String) -> scrapedSearchResult{
        let links = matches(for: "www.[^ ]*.com", in: html)
        let tempterm = searchTerm.replacingOccurrences(of: "+", with: " ")
        for index in 0..<links.count{
            let result = links[index]
            if result.contains(str){
                return scrapedSearchResult(term: tempterm, map_ranking: -1, organic_ranking: index+1)
            }
        }
        
        return scrapedSearchResult(term: tempterm, map_ranking: -1, organic_ranking: -1)
    }

    static func parseHTML(url : URL) -> String{

    //    guard let url = URL(string: "https://www.google.com/search?q=cabinet+refinishing") else {
    //        print("could not make url")
    //        return ""
    //    }
        
        do {
            let html = try String(contentsOf: url, encoding: .ascii)
            let doc: Document = try SwiftSoup.parse(html)
            let str = try doc.text()
            return str
        } catch let error {
            print("Error: \(error)")
        }

        return ""
    }
    
}
