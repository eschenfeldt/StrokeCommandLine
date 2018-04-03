import Foundation
#if !os(Linux)
import Dispatch
#endif
import StrokeModel
import ArgParse

public final class ModelAndArguments {

    let baseCase: Bool
    private let evals_per_set: Int
    private let sex: Sex
    private let age: Int
    private let race: Double
    private let time_since_symptoms: Double
    private let time_to_primaries: [Double]
    private let time_to_comprehensives: [Double]
    private let transfer_times: [Double]

    private var mi: Inputs? {
        return Inputs(sex: sex, age: age, race: race, timeSinceSymptoms: time_since_symptoms,
                      primaryTimes: time_to_primaries, transferTimes: transfer_times,
                      comprehensiveTimes: time_to_comprehensives)
    }

    public init?(parser: ArgParser) {

        let primaryList = parser.getDoubleList(Arguments.primary.rawValue)
        let transferList = parser.getDoubleList(Arguments.transfer.rawValue)
        let comprehensiveList = parser.getDoubleList(Arguments.comprehensive.rawValue)

        guard primaryList.count == transferList.count else { return nil }

        if primaryList.isEmpty {
            time_to_primaries = [25, 30, 45]
            transfer_times = [50, 35, 20]
        } else {
            time_to_primaries = primaryList
            transfer_times = transferList
        }

        if comprehensiveList.isEmpty {
            time_to_comprehensives = [60]
        } else {
            time_to_comprehensives = comprehensiveList
        }

        baseCase = parser.found(Arguments.baseCase.rawValue)
        evals_per_set = parser.getInt(Arguments.iterations.rawValue)

        let male = parser.getFlag(Arguments.male.rawValue)
        let female = parser.getFlag(Arguments.female.rawValue)
        switch (male, female) {
        case (true, true):
            print("Both sexes entered, defaulting to female")
            self.sex = .female
        case (true, false): self.sex = .male
        case (false, true): self.sex = .female
        case (false, false): self.sex = .female
        }

        age = parser.getInt(Arguments.age.rawValue)
        if !parser.found(Arguments.race.rawValue) &&
            parser.found(Arguments.nihss.rawValue) {
            // We use nihss only if race is not also supplied
            let nihss = parser.getDouble(Arguments.nihss.rawValue)
            race = Race.fromNIHSS(nihss: nihss)
        } else {
            race = parser.getDouble(Arguments.race.rawValue)
        }

        time_since_symptoms = parser.getDouble(Arguments.symptom.rawValue)

        print("\(age) year old \(sex), \(time_since_symptoms) minutes from symptom onset with race \(race)")

        print("Time to primaries: \(time_to_primaries)")
        print("Transfer times : \(transfer_times)")
        print("Time to comprehensives: \(time_to_comprehensives)")

    }

    public func run() throws {

        guard let mi = mi else {
            throw Error.primaryTimesMismatch
        }

        let start = Date()
        let model = StrokeModel(mi)
        let results: Results
        if baseCase {
            results = model.run()
        } else {
            #if os(Linux)
            let useGCD = false
            #else
            let useGCD = true
            #endif
            results = model.runWithVariance(simulationCount: evals_per_set,
                                            completionHandler: {_, _ in },
                                            useGCD: useGCD)
        }
        let end = Date()
        let time_dif = end.timeIntervalSince(start)
        let sim_time = Double(time_dif)

        print(results.string)
        print("\nSimulation time: \(sim_time) seconds")

    }

}
