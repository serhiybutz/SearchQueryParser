///
/// This file is part of the SearchQueryParser package.
/// (c) Serge Bouts <sergebouts@gmail.com>
///
/// For the full copyright and license information, please view the LICENSE
/// file that was distributed with this source code.
///

import Foundation

extension Parsing {
    @inline(__always)
    func attempt(_ predicate: () -> Bool) -> Bool {
        let preservedIndex = currentIndex
        guard predicate() else {
            currentIndex = preservedIndex
            return false
        }
        return true
    }

    @inline(__always)
    func attempt<T>(_ exec: () -> T?) -> T? {
        precondition(type(of: T.self) != Bool.self)
        let preservedIndex = currentIndex
        guard let result = exec() else {
            currentIndex = preservedIndex
            return nil
        }
        return result
    }

    @inline(__always)
    func bounds<R>(by region: R) -> (lowerBound: Int?, upperBound: Int?) {
        var lowerBound: Int?
        var upperBound: Int?
        switch region {
        case let range as Range<Int>:
            lowerBound = range.lowerBound
            upperBound = range.upperBound - 1
        case let range as ClosedRange<Int>:
            lowerBound = range.lowerBound
            upperBound = range.upperBound
        case let range as PartialRangeFrom<Int>:
            lowerBound = range.lowerBound
        case let range as PartialRangeUpTo<Int>:
            upperBound = range.upperBound - 1
        case let range as PartialRangeThrough<Int>:
            upperBound = range.upperBound
        default: preconditionFailure()
        }
        return (lowerBound, upperBound)
    }

    /// The lower bound is _mandatory_ repetitions count, the upper bound is a _maximum_ optional repetitions count
    @inline(__always)
    func repeating<R>(_ region: R, _ predicate: () -> Bool) -> Bool where R: RangeExpression, R.Bound == Int {
        let (mandatoryBound, optionalBound) = bounds(by: region)

        func optionalExec(bound: Int?) {
            if let bound = bound {
                guard bound > 0 else { return }
                // optional, limited
                for _ in 1...bound {
                    guard attempt({predicate()}) else { break }
                }
            } else {
                // optional, unlimited
                for _ in 0... {
                    guard attempt({predicate()}) else { break }
                }
            }
        }

        if let mandatoryBound = mandatoryBound, mandatoryBound > 0 {
            // mandatory
            for _ in 1...mandatoryBound {
                guard attempt({predicate()}) else { return false }
            }
            // optional
            optionalExec(bound: optionalBound.map { $0 - mandatoryBound } )
        } else {
            // optional
            optionalExec(bound: optionalBound)
        }

        return true
    }

    /// The lower bound is _mandatory_ repetitions count, the upper bound is a _maximum_ optional repetitions count
    @inline(__always)
    func repeating<R, V>(_ region: R, _ exec: (V?) -> V?) -> V? where R: RangeExpression, R.Bound == Int {
        let (mandatoryBound, optionalBound) = bounds(by: region)

        var result: V?

        func optionalExec(bound: Int?) {
            if let bound = bound {
                guard bound > 0 else { return }
                // optional, limited
                for _ in 1...bound {
                    guard let newResult = attempt({exec(result)}) else { break }
                    result = newResult
                }
            } else {
                // optional, unlimited
                for _ in 0... {
                    guard let newResult = attempt({exec(result)}) else { break }
                    result = newResult
                }
            }
        }

        if let mandatoryBound = mandatoryBound, mandatoryBound > 0 {
            // mandatory
            for _ in 1...mandatoryBound {
                guard let newResult = attempt({exec(result)}) else { return nil }
                result = newResult
            }
            // optional
            optionalExec(bound: optionalBound.map { $0 - mandatoryBound } )
        } else {
            // optional
            optionalExec(bound: optionalBound)
        }

        return result
    }
}
