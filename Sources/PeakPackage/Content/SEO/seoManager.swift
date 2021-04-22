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
    
    func toViewable() -> viewableSearchResult {
        return viewableSearchResult(
            term: self.term,
            organic_rank: (organic_ranking != nil || organic_ranking == -1) ? String(organic_ranking!) : "-",
            maps_rank: (map_ranking != nil || map_ranking == -1) ? String(map_ranking!) : "-")
    }
}

struct viewableSearchResult{
    
    var id = UUID()
    var term : String
    var organic_rank : String
    var maps_rank : String 
    var change : Bool?
    var change_maps : Bool?
    
    func greaterThan(_ other: viewableSearchResult) -> Bool {
        #warning("TODO: only taking organic rank into account")
        //not super elegant
        if Int(organic_rank) == -1 {
            return true
        }else if Int(other.organic_rank) ?? -1 == -1{
            return false
        }
        return Int(organic_rank) ?? 100 > Int(other.organic_rank) ?? 100
    }
}

public class SEOManager : Manager {
    #warning("TODO change terms based on app type")
    static var terms : [String] {
        return getSearchTerms()
    }
    
    @Published var rankings : [viewableSearchResult] = []
    @Published var weekbyweek : [SearchRankingforTime] = []
    
    //needs a public
    public override init(){}
    
    static func getSubjectOfSearch() -> String {
        if defaults.getApplicationType() == .NHanceConnect {
            return "nhance"
        } else if defaults.getApplicationType() == .PeakClients(.admin) {
            return ""
        }
        return ""
    }
    static func getSearchTerms() -> [String] {
        if defaults.getApplicationType() == .PeakClients(.admin){
            return ["internet marketing",
                    "franchise marketing",
                    "chem dry marketing",
                    "seo solutions",
                    "franchise web solutions",
                    "website development"]
        }else if defaults.getApplicationType() == .NHanceConnect {
            return ["cabinet refinishing",
                    "cabinet refinisher",
                    "cabinet painting",
                    "cabinet painter",
                    "cabinet refacing",
                    "cabinet door replacement",
                    "floor refinishing",
                    "floor sanding",
                    "cabinet color change",
                    "custom color cabinets"]
        }else if defaults.getApplicationType() == .ChemDryConnect ||
                    defaults.getApplicationType() == .PeakClients(.chemdry){
            return ["carpet cleaning",
                    "carpet cleaner",
                    "rug cleaning",
                    "pet odor removal",
                    "put urine stain removal",
                    "furniture cleaning",
                    "carpet stain removal",
                    "tile cleaning",
                    "chem dry",
                    "upholstery cleaning"]
        }
        
        return []
    }
    
    func loadRankings(){
            DatabaseDelegate.getSEORankings(
                completion: {
                rex in
                    let rankList = rex as! [SearchRankingforTime]
                    self.weekbyweek = rankList
                    self.calculateChange()
                    if self.rankings.count == 0{
                        printr("there's nothing in the database, scrape the web")
                        DispatchQueue.global().async {
                            self.rankings = SEOManager.scrapeRankings().map({$0.toViewable()})
                            self.sortRankings()
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: Notification.Name("SEORankingsDoneScraping"), object: nil)
                            }
                        }
                    }else{
                        self.sortRankings()
                    }
            })
    }
    
    func sortRankings(){
        rankings.sort(by: {$0.greaterThan($1)})
        rankings.reverse()
    }
    
    func weekbyweek(for term: String) -> [viewableSearchResult]{
        var list : [viewableSearchResult] = []
        for week in weekbyweek{
            for search in week.list{
                if search.keyword == term{
                    list.append(viewableSearchResult(
                                    term: week.week,
                                    organic_rank: search.organic_ranking ?? "-",
                                    maps_rank: search.maps_ranking ?? "-"))
                }
            }
        }
        return list
    }
    
    func calculateChange(){
        rankings = []
        if weekbyweek.count == 1{
            let first = weekbyweek.first!
            for searchTerm in first.list{
                let result =
                    viewableSearchResult(term: searchTerm.keyword,
                                         organic_rank: searchTerm.organic_ranking ?? "-",
                                         maps_rank: searchTerm.maps_ranking ?? "-",
                                         change: nil,
                                         change_maps: nil)
                rankings.append(result)
            }
        } else if weekbyweek.count > 1 {
            let first = weekbyweek.first!
            let last = weekbyweek.last!
//            let timeframe = Int(last.week.digits)
            for searchTerm in first.list{
                for searchTerm2 in last.list{
                    if searchTerm.keyword == searchTerm2.keyword{
                        var change : Bool? = nil
                        //Calculating organic change
                        if searchTerm.organic_ranking != nil &&
                            searchTerm2.organic_ranking != nil{
                            //both hlet rankings
                            let rank1 = Int(searchTerm.organic_ranking!) ?? 0
                            let rank2 = Int(searchTerm2.organic_ranking!) ?? 0
                            change = rank1 == rank2 ? nil : rank1 > rank2
                        }else if searchTerm.organic_ranking == nil &&
                            searchTerm2.organic_ranking == nil{
                        //both don't have ranking
                        }else if searchTerm.organic_ranking != nil{
                            //went up
                            change = true
                        }else{
                            //went down
                            change = false
                        }
                        var mapsChange : Bool? = nil
                        //Calculating maps change
                        if searchTerm.maps_ranking != nil &&
                            searchTerm2.maps_ranking != nil {
                            let rank1 = Int(searchTerm.maps_ranking!) ?? 0
                            let rank2 = Int(searchTerm2.maps_ranking!) ?? 0
                            mapsChange = rank1 == rank2 ? nil : rank1 > rank2
                        }else if searchTerm.maps_ranking == nil &&
                            searchTerm2.maps_ranking == nil{
                            //both don't have ranking
                        }else if searchTerm.maps_ranking != nil{
                            //went up
                            mapsChange = true
                        }else{
                            //went down
                            mapsChange = false
                        }
                        let result =
                            viewableSearchResult(
                                term: searchTerm.keyword,
                                organic_rank: searchTerm.organic_ranking ?? "-",
                                maps_rank: searchTerm.maps_ranking ?? "_",
                                change: change,
                                change_maps: mapsChange)
                        rankings.append(result)
                    }
                }
            }
        }
    }
    
    static func scrapeRankings(forDatabase: Bool = false) -> [scrapedSearchResult]{
        let list = findRankings(for: terms)
        if forDatabase{
            setRankings(for: list)
        }
        return list
    }
    
    static func setRankings(for results: [scrapedSearchResult]){
        for result in results{
            DatabaseDelegate.setSEORankings(
                keyword: result.term,
                mapRanking: result.map_ranking,
                organicRanking: result.organic_ranking)
        }
    }
    
    static private func findRankings(for terms: [String]) -> [scrapedSearchResult]{
        var searchArray : [scrapedSearchResult] = []
        let baseURL = "https://www.google.com/search?q="
        var searchterms = terms.map(
            {$0.replacingOccurrences(of: " ", with: "+")}
        )
        for term in searchterms{
            let url_str = baseURL + term
            guard let url = URL(string: url_str) else { continue }
            let body = parseHTML(url: url).lowercased()
            printr(body, tag: printTags.error)
            #warning("TODO remove hard reference to nhance")
            searchArray.append(getSearchPosition(
                                of: "nhance",
                                in: body,
                                searchTerm: term))
        }
        return searchArray
    }
    

    static func matches(
        for regex: String,
        in text: String)
    -> [String] {
        
        do {
            let regexOptions : NSRegularExpression.Options =
                [.useUnicodeWordBoundaries]
            let regex = try NSRegularExpression(
                pattern: "\\b" + regex + "\\b",
                options: regexOptions)
            let results = regex.matches(
                in: text,
                range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    static func getSearchPosition(
        of str: String,
        in html: String,
        searchTerm: String)
    -> scrapedSearchResult{
        
        let links = matches(for: "www.[^ ]*.com", in: html)
        let tempterm = searchTerm.replacingOccurrences(of: "+", with: " ")
        var organicRank = -1
        for index in 0..<links.count{
            let result = links[index]
            if result.contains(str){
                organicRank = index + 1
            }
        }
        var mapRank = -1
        //(hours or services may differ * more businesses|
        if let mapSection = matches(
            for: "near * more places",
                in: html).first {
            let mapsLinks = mapSection.components(separatedBy: "call")
            //printr("found \(mapsLinks.count) maps links")
            for index in 0..<mapsLinks.count{
                let result = mapsLinks[index]
                if result.contains(str){
                    mapRank = index + 1
                }
            }
        }else{
            //printr("no maps links found")
        }
        return scrapedSearchResult(
            term: tempterm,
            map_ranking: mapRank,
            organic_ranking: organicRank)
    }

    static func parseHTML(
        url : URL)
    -> String{
        
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
