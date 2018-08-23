//
//  Temperatura.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 02.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation

public enum TempUnit: String {
    case c = "℃"
    case f = "℉"
    case k = "K"
}

public struct Temperature {
    public var c: Double {
        return k - 273.15
    }
    
    public var f: Double {
        return c * 1.8 + 32
    }
    
    public var k: Double
    
    public func returnFormat(_ tempUnit: TempUnit) -> Double {
        switch tempUnit {
        case .c:
            return self.c
        case .f:
            return self.f
        case .k:
            return self.k
        }
    }
}
