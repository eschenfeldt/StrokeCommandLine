//
//  constants.swift
//  StrokeCommandLine
//
//  Created by Patrick Eschenfeldt (ITA) on 3/30/18.
//

import Foundation

enum Arguments: String {
    case baseCase = "base_case"
    case iterations = "iterations"
    case male = "male"
    case female = "female"
    case age = "age"
    case race = "race"
    case nihss = "nihss"
    case symptom = "symptom_time"
    case comprehensive = "comprehensive_time"
    case primary = "primary_time"
    case transfer = "transfer_time"

    var full: String {
        let shortNames: [String]
        switch self {
        case .baseCase: shortNames = ["b"]
        case .iterations: shortNames = ["i"]
        case .male: shortNames = ["m"]
        case .female: shortNames = ["f"]
        case .age: shortNames = ["a"]
        case .race: shortNames = ["r"]
        case .nihss: shortNames = []
        case .symptom: shortNames = ["sym", "s"]
        case .comprehensive: shortNames = ["comp", "c"]
        case .primary: shortNames = ["prim", "p"]
        case .transfer: shortNames = ["trans", "t"]
        }
        return ([self.rawValue] + shortNames).joined(separator: " ")
    }

    var help: String {
        let shortNames: [String]
        switch self {
        case .baseCase: shortNames = ["b"]
        case .iterations: shortNames = ["i"]
        case .male: shortNames = ["m"]
        case .female: shortNames = ["f"]
        case .age: shortNames = ["a"]
        case .race: shortNames = ["r"]
        case .nihss: shortNames = []
        case .symptom: shortNames = ["sym", "s"]
        case .comprehensive: shortNames = ["comp", "c"]
        case .primary: shortNames = ["prim", "p"]
        case .transfer: shortNames = ["trans", "t"]
        }
        return (["--" + self.rawValue] + shortNames).joined(separator: " -")
    }
}

public extension ModelAndArguments {
    enum Error: Swift.Error {
        case primaryTimesMismatch
    }
}
