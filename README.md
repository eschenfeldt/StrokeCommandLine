## StrokeCommandLine

This is a simple command line interface to [StrokeModel](https://github.com/eschenfeldt/stroke-swift). Run with no arguments to run an example scenario, or use command line flags to modify inputs. Arguments are processed by [ArgParse](https://github.com/dmulholland/ArgParse).

### Usage

The following settings are available via the given command line arguments:

- Run base case only: `--base_case` `-b` (Single run using median intra-hospital times)
- Model iterations: `--iterations` `-i` (Default: 1000)
- Sex: `--male` `-m` or `--female` `-f` (Default: Female)
- Age: `--age` `-a` ## (Default 70)
- Stroke severity: `--race` `-r` ## or `--nihss` ## (Default: RACE 3)
- Time from symptom onset: `--symptom_time` `--sym` `-s` ## (Default: 30 minutes)
- Travel times (each can be entered multiple times, with the flag included each time):
    - Primary: `--primary_time` `--prim` `-p` ## (Default: [25, 30, 45])
    - Transfer (paired with primaries): `--transfer_time` `--trans` `-t` ## (Default: [50, 35, 20])
    - Comprehensive: `--comprehensive_time` `--comp` `-c` ## (Default: [60])
    
Use the flag `--help` to print a description of the options.

#### Travel times
Note that currently only the closest primary and comprehensive center will be used for strategies other than drip-and-ship. Multiple comprehensive times are accepted for future compatibility with center-specific performance distributions. When entering multiple primary centers, each must have an accompanying transfer time, and these pairs will be formed in the order the arguments are provided.

#### Examples
For a 50 year old male with RACE 4 and only potential primary center 14 minutes away followed by a 60 minute transfer to a comprehensive center with the nearest comprehensive center 55 minutes from the site of the stroke, you could run
```
StrokeCommandLine -m -r 4 -p 14 -t 60 -c 55
```
If there are two potential primary centers, one 15 minutes away followed by a 75 minute transfer and another 35 minutes away with a 30 minute transfer, you can indicate this with:
```
StrokeCommandLine -p 15 -t 75 -p 35 -t 30
```
In the printed results, the first primary center will be `Primary 0` in drip and ship strategies and the second will be `Primary 1`. The order of arguments does not matter *except* for multiple arguments for primary and transfer times.

### Installation
With [Swift 4.1](https://swift.org/download/#releases) or higher installed, running `swift build -c release` in the root directory of the repository will create an executable at `.build/release/StrokeCommandLine`. This should work on macOS or Linux, with the caveat that the Linux version is single-threaded due to some instability with [Grand Central Dispatch on Linux](https://github.com/apple/swift-corelibs-libdispatch). If you have problems with this, running `swift package update` may fix some dependency issues.
