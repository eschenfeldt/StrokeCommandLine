import Foundation
import Dispatch
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
            race = nihss_to_race(nihss: nihss)
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

        let start = DispatchTime.now()
        let model = StrokeModel(mi)
        let results: Results
        if baseCase {
            results = model.run()
        } else {
            results = model.runWithVariance(simulation_count: evals_per_set,
                                            completion_handler: {_, _ in })
        }
        let end = DispatchTime.now()
        let nano_time = end.uptimeNanoseconds - start.uptimeNanoseconds
        let sim_time = Double(nano_time) / 1_000_000_000

        print(results.string)
        print("\nSimulation time: \(sim_time) seconds")

    }

}
