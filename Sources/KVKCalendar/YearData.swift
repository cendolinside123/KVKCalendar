//
//  YearData.swift
//  KVKCalendar
//
//  Created by Sergei Kviatkovskii on 28.11.2020.
//

#if os(iOS)

import Foundation
import SwiftUI

final class YearData: ObservableObject {
    
    struct YearSection: Identifiable {
        let date: Date
        var months: [Month]
        
        var id: Int {
            date.hashValue
        }
    }
    
    @Published var date: Date
    var style: Style
    @Published var sections: [YearSection]
    let rowsInPage = 3
    let columnsInPage = 4
    var middleRowInPage: Int {
        (rowsInPage * columnsInPage) / 2
    }

    var itemsInPage: Int {
        columnsInPage * rowsInPage
    }
    
    init(data: CalendarData, date: Date, style: Style) {
        self.date = date
        self.style = style
        
        self.sections = data.months.reduce([], { (acc, month) -> [YearSection] in
            var accTemp = acc
            
            guard let idx = accTemp.firstIndex(where: { $0.date.kvkYear == month.date.kvkYear }) else {
                return accTemp + [YearSection(date: month.date, months: [month])]
            }
            
            accTemp[idx].months.append(month)
            return accTemp
        })
    }
    
    func handleSelectedDate(_ date: Date) {
        var components = DateComponents(year: date.kvkYear, month: date.kvkMonth, day: self.date.kvkDay)
        let dt = style.calendar.date(from: components)
        self.date = dt ?? date
    }
}

#endif
