//
//  ParkingSpot.swift
//  SpotDemoMap
//
//  Created by Nick Brandaleone on 6/8/15.
//  Copyright (c) 2015 Nick Brandaleone. All rights reserved.
//

/*
This is the model for a parking spot.

TODO:
We need to set a variable for price. Currently handled in summary string.
We need to handle date ranges. For example, a spot may be available
for a few days within a week, but not the entire week.
*/

import Foundation
import MapKit

/* Different types of Parking Spots */
enum ParkingCategory {
    case Open
    case Closed
    case Reset
}

/****************************************************************************/

class ParkingSpot: NSObject, MKAnnotation {
    let category:ParkingCategory
    let summary: String
    let coordinate: CLLocationCoordinate2D
    // let price: Double
    // let date: NSDate
    
    // Computed Properties. There is also a "set" property.
    var title: String {
        get {
            switch category {
            case .Open: return "Available"
            case .Closed: return "Not Available"
            case .Reset: return "Reset"
            }
        }
    }
    var subtitle: String {
        get {
            switch category {
            case .Open: return "Rent me!"
            case .Closed: return "Try again later"
            case .Reset: return "Reset"
            }
        }
    }
    var textColor: UIColor {
        get {
            switch category {
            case .Open: return UIColor(red: 0.106, green: 0.686, blue: 0.125, alpha: 1)
            case .Closed: return UIColor(red: 0.114, green: 0.639, blue: 0.984, alpha: 1)
            case .Reset: return UIColor(red: 0.322, green: 0.459, blue: 0.984, alpha: 1)
            }
        }
    }
    
    init(category: ParkingCategory, summary: String, coordinate: CLLocationCoordinate2D){
        self.category = category
        self.summary = summary
        self.coordinate = coordinate
        
        super.init()
    }
    
    func pinColor() -> MKPinAnnotationColor {
        switch category {
        case .Open:     return .Green
        case .Closed:   return .Red
        default:        return .Purple
        }
    }
}