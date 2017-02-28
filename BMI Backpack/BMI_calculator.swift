//
//  BMI_calculator.swift
//  BMI Backpack
//
//  Created by Daniel Henderson on 2/18/17.
//  Copyright © 2017 Daniel Henderson. All rights reserved.
//
//  Model for BMI Backpack app. 
//  
//  Units are set to metric initially.
//  When weight and height are nil, BMI is not calculated.
//  When weight and height have values, BMI is calculated.
//  When units changes, weight and height values are re-calculated
//    to equivalent values.
//  
//  When object is init'ed, look for values from UserDefaults
//    to populate initial values.
//  Idea from Course: Building a Note-Taking App for iOS 10 with Swift
//    by Todd Perkins, from Lynda.com

//  BMI images based on artwork at 
//  http://www.pre-diabetes.com/info/medical-encyclopedia/body-mass-about.html
//  http://www.pre-diabetes.com/wp-content/uploads/2011/07/BMI-Chart.jpg

import Foundation

/**
  *MeasurementSystems of measure*
  - Important: metric and imperial 
     are the two MeasurementSystems supported.
 
  - Author: Daniel Henderson
 
*/

enum MeasurementSystem {
    case metric, imperial
}

enum BmiUnit {
    case kilo, pound, meter, foot, inch, centimeter
}

enum BMICategory {
    case severeThinness, moderateThinness, mildThinness
}


/**
 *BMI struct*
 - Important: Simple struct to hold height, weight, 
   MeasurementSystems (metric or imperial) and a calculated
   value for bmi score.
 
   If imperial MeasurementSystems are used, 
   weight is in pounds and height is in inches.
   If metric MeasurementSystems are used, 
   weight is in kilograms and height is in centimeters.
   When MeasurementSystems is changed, struct re-computes
   these values and saves them to the struct.
 
 - Author: Daniel Henderson

 - Parameters: 
   weight: the person's weight (without MeasurementSystems)
   height: the person's height (without MeasurementSystems)
   MeasurementSystems: MeasurementSystem of measure (metric or imperial)
 
 */

struct BMI {
    var weight:Float = 40
    var weightUnits:BmiUnit = .kilo
    var height:Float = 100
    var heightUnits:BmiUnit = .centimeter
    var _measure:MeasurementSystem = .metric
    
    init(_ weight: Float, _ height: Float) {
        self.weight = weight
        self.height = height
    }
    
    var measureSystem: MeasurementSystem {
        set {
            if ( newValue == _measure ) {
                // do nothing, no change
            } else {
                if ( newValue == MeasurementSystem.metric ) {
                    // convert w & h imperial -> metric
                    weight = convert(value: weight, from: weightUnits, to: .kilo)!
                    weightUnits = .kilo
                    height = convert(value: height, from: heightUnits, to: .centimeter)!
                    heightUnits = .centimeter
                } else {
                    // convert w & h metric -> imperial
                    weight = convert(value: weight, from: weightUnits, to: .pound)!
                    weightUnits = .pound
                    height = convert(value: height, from: heightUnits, to: .inch)!
                    heightUnits = .inch
                }
            }
            _measure = newValue
        }
        get { return _measure }
    }

    
    
    // read-only computed property
    var bmi:Float {
        let h = convert(value: height, from: heightUnits, to: .meter)!
        let w = convert(value: weight, from: weightUnits, to: .kilo)!
        return w / ( h * h )
    }
    
}

// BmiUnit: kilo, pound, meter, foot, inch, centimeter
func convert(value: Float, from: BmiUnit, to: BmiUnit) -> Float? {
    print("converting \(value) from \(from) to \(to)")
    switch from {
    case .kilo:
        switch to {
        case .kilo:
                return value
        case .pound:
                return value * 0.453592
        default:
                return nil // improper conversion from weight to distance
        }
    case .pound:
        switch to {
        case .pound:
            return value
        case .kilo:
            return value * 2.5400013716
        default:
            return nil // improper conversion
        }
    case .meter:
        switch to {
        case .meter:
            return value
        case .centimeter:
            return value * 100
        case .foot:
            return value * 3.28084
        case .inch:
            return value * 39.37008
        default:
            return nil // improper conversion distance to weight
        }
    case .foot:
        switch to {
        case .foot:
            return value
        case .meter:
            return value * 0.3048
        case .centimeter:
            return value * 30.48
        case .inch:
            return value * 12
        default:
            return nil // improper conversion distance to weight
        }
    case .inch:
        switch to {
        case .inch:
            return value
        case .meter:
            return value * 0.0254
        case .centimeter:
            return value * 2.54
        case .foot:
            return value / 12
        default:
            return nil // improper conversion distance to weight
        }
    case .centimeter:
        switch to {
        case .centimeter:
            return value
        case .meter:
            return value / 100
        case .foot:
            return value * 0.0328084
        case .inch:
            return value * 0.393701
        default:
            return nil // improper conversion distance to weight
        }
    }
}

    
