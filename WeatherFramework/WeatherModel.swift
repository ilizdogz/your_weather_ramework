//
//  Pogoda.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 06.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation
import UIKit

public struct WeatherModel {
    public var today: TodayModel
    public var next24h: [Next24hModel]
    public var later: [LaterModel]
    public var cityName: String
}

public struct TodayModel {
    public var temp: Temperature
    public var desc: String
    public var rain: Double
    public var snow: Double?
    public var wind: Double
    public var pressure: Int
    public var humidity: Int
    public var clouds: Int
}

public struct Next24hModel {
    public var time: Date
    public var desc: String
    public var temp: Temperature
    public var pressure: Int
    public var humidity: Int
    public var clouds: Int
}

public struct LaterModel {
    public var date: Date
    public var tempDay: Temperature?
    public var descDay: String?
    public var tempNight: Temperature?
    public var descNight: String?
    init(date: Date, tempDay: Temperature, descDay: String) {
        self.tempDay = tempDay
        self.date = date
        self.descDay = descDay
    }
    init(date: Date, tempNight: Temperature, descNight: String) {
        self.date = date
        self.tempNight = tempNight
        self.descNight = descNight
    }
    init(date: Date) {
        self.date = date
    }
}

enum JSONType {
    case now, forecast
}

