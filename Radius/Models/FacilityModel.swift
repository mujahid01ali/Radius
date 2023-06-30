//
//  FacilityModel.swift
//  Radiant
//
//  Created by Mujahid Ali on 30/06/2023.
//

import Foundation

struct FacilityResponse: Codable {
    var facilities : [Facility]?
    var exclusions : [[Exclusions]]?
}

struct Exclusions : Codable {
    var facility_id : String?
    var options_id : String?
}

struct Facility: Codable {
    var facility_id : String?
    var name : String?
    var options : [Options]?
}

struct Options : Codable {
    var name : String?
    var icon : String?
    var id : String?
    var isSelected: Bool?
}
