//
//  Temperatura.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 02.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation

public enum Stopien: String {
    case c = "℃"
    case f = "℉"
    case k = "K"
}

public struct Temperatura {
    var c: Double {
        return k - 273.15
    }
    
    var f: Double {
        return c * 1.8 + 32
    }
    
    var k: Double
    
    public func returnFormat(_ formatTemp: Stopien) -> Double {
        switch formatTemp {
        case .c:
            return self.c
        case .f:
            return self.f
        case .k:
            return self.k
        }
    }
}
