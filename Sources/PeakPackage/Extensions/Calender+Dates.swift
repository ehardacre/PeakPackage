// Kevin Li - 7:28 PM - 6/10/20

import SwiftUI

extension Calendar {

    func isDate(_ date1: Date, equalTo date2: Date, toGranularities components: Set<Calendar.Component>) -> Bool {
        components.reduce(into: true) { isEqual, component in
            isEqual = isEqual && isDate(date1, equalTo: date2, toGranularity: component)
        }
    }

    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.month, .year], from: date)
        return self.date(from: components)!
    }

    func startOfYear(for date: Date) -> Date {
        let components = dateComponents([.year], from: date)
        return self.date(from: components)!
    }

}

extension Calendar {

    func generateDates(inside interval: DateInterval,
                       matching components: DateComponents) -> [Date] {
       var dates: [Date] = []
       dates.append(interval.start)

       enumerateDates(
           startingAfter: interval.start,
           matching: components,
           matchingPolicy: .nextTime) { date, _, stop in
           if let date = date {
               if date < interval.end {
                   dates.append(date)
               } else {
                   stop = true
               }
           }
       }

       return dates
    }

}

//Extension to date in order to convert between timezones
extension Date {
    
    //the number of seconds in a day
    static let day : TimeInterval = 86400
    
    static let sunday = 1
    static let saturday = 7

    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        printr(seconds)
        return Date(timeInterval: seconds, since: self)
    }
    
    /**
     # Data Base Format
        format a date for the correct format for the database
     */
    func databaseFormat() -> String{
        
        //format date into correct format for database
        let globalDate = self.toGlobalTime()
        let year = globalDate.year
        var month = "\(Calendar.current.component(.month, from: globalDate))"
        if  month.count == 1{
            month = "0\(month)"
        }
        var day = "\(Calendar.current.component(.day, from: globalDate))"
        if  day.count == 1{
            day = "0\(day)"
        }
        let inthour = Calendar.current.component(.hour, from: globalDate)
        var hour = "\(inthour)"
        if hour.count == 1{
            hour = "0\(hour)"
        }
        let intmin = Calendar.current.component(.minute, from: globalDate)
        var minute = "\(intmin)"
        if minute.count == 1{
            minute = "0\(minute)"
        }
        let second = "00"
        return "\(year)\(month)\(day)\(hour)\(minute)\(second)"
        
    }
    
    static func fromDatabaseFormat(_ DateStr: String) -> Date {
        //TODO: 
        return Date()
    }

}
