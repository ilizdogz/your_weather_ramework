//
//  GetWeatherData.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 18.02.2018.
//  Copyright © 2018 Krzysztof Glimos. All rights reserved.
//

import Foundation
import SwiftyJSON
import Timepiece
import CoreLocation

func getLang() -> String {
    if (Locale.preferredLanguages[0] == "pl-PL") {
        return "&lang=pl"
    } else {
        print(Locale.preferredLanguages)
        return ""
    }
}

public func getDataWithId(id: String, apiKey: String, callback: @escaping (WeatherModel?, NSError?) -> Void) {
    let urlArray: [JSONType: String] = [.forecast: "https://api.openweathermap.org/data/2.5/forecast?id=\(id)&appid=\(apiKey)\(getLang())", .now: "https://api.openweathermap.org/data/2.5/weather?id=\(id)&appid=\(apiKey)\(getLang())"]
    if let data = getWeatherData(urlArray) {
        if let data = parse(data) {
            callback(data, nil)
        } else {
            callback(nil, NSError())
        }
    } else {
        callback(nil, NSError())
    }
}

public func getDataWithLocation(location: CLLocation, apiKey: String, callback: @escaping (WeatherModel?, NSError?) -> Void) {
    let urlArray: [JSONType: String] = [.forecast: "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)\(getLang())", .now: "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)\(getLang())"]
    if let data = getWeatherData(urlArray) {
        if let data = parse(data) {
            callback(data, nil)
        } else {
            callback(nil, NSError())
        }
    } else {
        callback(nil, NSError())
    }
}

func getWeatherData(_ array: [JSONType: String]) -> [JSONType: JSON]? {
    var results = [JSONType: JSON]()
    for (rodzaj, adres) in array {
        if let url = URL(string: adres) {
            if let data = try? Data(contentsOf: url) {
                if let json = try? JSON(data: data) {
                    if json["cod"].intValue == 200 {
                        results[rodzaj] = json
                    } else { return nil }
                }
            } else { return nil }
        } else { return nil }
    }
    return results
}

func parse(_ results: [JSONType: JSON]) -> WeatherModel? {
    var today: TodayModel?
    var next24h: [Next24hModel]?
    var later: [LaterModel]?
    var cityName: String?
    for (type, json) in results {
        switch type {
        case .forecast:
            cityName = "\(json["city"]["name"].stringValue), \(json["city"]["country"].stringValue)".lowercased()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .long
            var tempNext24h = [Next24hModel]()
            var tempLater = [LaterModel]()
            for index in 0...json["list"].count {
                let obj = json["list"][index]
                let dtInt = obj["dt"].intValue
                let time = Date(timeIntervalSince1970: TimeInterval(dtInt))
                let temp = Temperature(k: obj["main"]["temp"].doubleValue)
                let desc = obj["weather"][0]["description"].stringValue
                if (index < 8) {
                    tempNext24h.append(Next24hModel(time: time, desc: desc, temp: temp))
                } else {
                    if (time.hour >= 21) {
                        tempLater.append(LaterModel(date: time, tempNight: temp, descNight: desc))
                    } else if (time.hour > 11 && time.hour < 15) {
                        tempLater.append(LaterModel(date: time, tempDay: temp, descDay: desc))
                    }
                }
                
            }
            var list = [LaterModel]()
            for i in 1 ..< tempLater.count {
                let item = tempLater[i]
                let prevItem = tempLater[i - 1]
                if (item.date.day == prevItem.date.day && item.date.month == prevItem.date.month && item.date.year == prevItem.date.year) {
                    let items = [item, prevItem]
                    var laterModel = LaterModel(date: item.date)
                    for thing in items {
                        if let descDay = thing.descDay, let tempDay = thing.tempDay {
                            laterModel.descDay = descDay
                            laterModel.tempDay = tempDay
                        }
                        if let descNight = thing.descNight, let tempNight = thing.tempNight {
                            laterModel.descNight = descNight
                            laterModel.tempNight = tempNight
                        }
                    }
                    list.append(laterModel)
                } else if (i == 1) {
                    //pierwszy element to poprzednia noc
                    list.insert(LaterModel(date: prevItem.date, tempNight: prevItem.tempNight!, descNight: prevItem.descNight!), at: 0)
                } else if (i == tempLater.count - 1) {
                    // ostatni element to nastepny dzien
                    list.append(LaterModel(date: item.date, tempDay: item.tempDay!, descDay: item.descDay!))
                }
            }
            next24h = tempNext24h
            later = list
        case .now:
            let temp = Temperature(k: json["main"]["temp"].doubleValue)
            let desc = json["weather"][0]["description"].stringValue
            let wind = json["wind"]["speed"].doubleValue
            var rain: Double = 0
            var snow: Double?
            if (json["snow"]["3h"].doubleValue != 0) {
                snow = json["snow"]["3h"].doubleValue
            } else {
                rain = json["rain"]["3h"].doubleValue
            }
            today = TodayModel(temp: temp, desc: desc, rain: rain, snow: snow, wind: wind)
        }
    }
    if let today = today,
        let next24h = next24h,
        let later = later,
        let cityName = cityName{
        return WeatherModel(today: today, next24h: next24h, later: later, cityName: cityName)
    } else {
        return nil
    }
}
