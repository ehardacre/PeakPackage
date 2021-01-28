import ElegantPages
import SwiftUI

public struct ElegantCalendarView: View {

    var theme: CalendarTheme = .default

    public let calendarManager: ElegantCalendarManager

    public init(calendarManager: ElegantCalendarManager) {
        self.calendarManager = calendarManager
    }

    public var body: some View {
        ElegantHPages(manager: calendarManager.pagesManager) {
            yearlyCalendarView
            monthlyCalendarView
        }
        .onPageChanged(calendarManager.scrollToYearIfOnYearlyView)
    }

    private var yearlyCalendarView: some View {
        YearlyCalendarView(calendarManager: calendarManager.yearlyManager)
            .theme(theme)
    }

    private var monthlyCalendarView: some View {
        MonthlyCalendarView(calendarManager: calendarManager.monthlyManager)
            .theme(theme)
    }

}


struct ElegantCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        // Only run one calendar at a time. SwiftUI has a limit for rendering time
        Group {

//            LightThemePreview {
//                ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock))

    //            ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock, initialMonth: Date()))
//            }

            DarkThemePreview {
                ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock))

    //            ElegantCalendarView(calendarManager: ElegantCalendarManager(configuration: .mock, initialMonth: Date()))
            }
            
        }
    }
}

