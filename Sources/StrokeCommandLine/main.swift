import ArgParse

#if os(Linux)
    import Glibc
    Glibc.srandom(UInt32(Glibc.time(nil)))
#endif

let help = """
    Run the stroke triage model for one set of inputs.

Arguments:
    Run base case only: \(Arguments.baseCase.help) (Single run using median intra-hospital times)
    Model iterations: \(Arguments.iterations.help) (Default: 1000)
    Sex: \(Arguments.male.help) or \(Arguments.female.help) (Default: Female)
    Age: \(Arguments.age.help) ## (Default 70)
    Stroke severity: \(Arguments.race.help) ## or \(Arguments.nihss.help) ## (Default: RACE 3)
    Time from symptom onset: \(Arguments.symptom.help) ## (Default: 30 minutes)
    Travel times (each can be entered multiple times (with the flag included each time):
        Primary: \(Arguments.primary.help) ## (Default: [25, 30, 45])
        Transfer (paired with primaries): \(Arguments.transfer.help) ## (Default: [50, 35, 20])
        Comprehensive: \(Arguments.comprehensive.help) ## (Default: [60])
    (Note that currently only the closest primary and comprehensive center will be used for \
strategies other than drip-and-ship. Multiple comprehensive times are accepted for \
future compatibility with center-specific performance distributions.)
"""
let version = "0.1.0"

let parser = ArgParser(helptext: help, version: version)

parser.newFlag(Arguments.baseCase.full)
parser.newInt(Arguments.iterations.full, fallback: 1000)

parser.newFlag(Arguments.male.full)
parser.newFlag(Arguments.female.full)

parser.newInt(Arguments.age.full, fallback: 70)

parser.newDouble(Arguments.race.full, fallback: 3)
parser.newDouble(Arguments.nihss.full)

parser.newDouble(Arguments.symptom.full, fallback: 30)

parser.newDouble(Arguments.comprehensive.full, fallback: 60)
parser.newDouble(Arguments.primary.full, fallback: 25)
parser.newDouble(Arguments.transfer.full, fallback: 45)

parser.parse()

if let model = ModelAndArguments(parser: parser) {
    do {
        try model.run()
    } catch {
        print("Something broke: \(error)")
    }
} else {
    print("Each time to a primary hospital must have a corresponding transfer time")

}
