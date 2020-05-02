// MIT License

import Foundation

// Extension to Float for truncation
/// https://stackoverflow.com/questions/35946499/how-to-truncate-decimals-to-x-places-in-swift
extension CFAbsoluteTime {
    func truncate(places : Int)-> CFAbsoluteTime
    {
        return CFAbsoluteTime(floor(pow(10.0, CFAbsoluteTime(places)) * self)/pow(10.0, CFAbsoluteTime(places)))
    }
}

/// Our super Int Object.
struct SuperInt {
    
    private(set) var value: Int
    
    /// The constant property that takes advantage of memoization of closures
    lazy var isPrime: Bool = {
        
        /// NOTE: Swift does some behind the scenes caching, so this
        /// sleep makes the memoization more apparent.
        sleep(5)
        
        if value <= 1 {
            return false
        }
        
        if value <= 3 {
            return true
        }
        
        var i = 2
        while i*i <= value {
            
            if value % i == 0 {
                return false
            }
            
            i += 1
        }
        
        return true
    }()
    /// https://stackoverflow.com/a/31105728/7556543
    /// Same logic but implemented as a computed property
    var computedIsPrime: Bool {
       
        /// NOTE: Swift does some behind the scenes caching, so this
        /// sleep makes the memoization more apparent.
        sleep(5)
        
        if value <= 1 {
            return false
        }
        
        if value <= 3 {
            return true
        }
        
        var i = 2
        while i*i <= value {
            
            if value % i == 0 {
                return false
            }
            
            i += 1
        }
        
        return true
    }
    
    init(_ i: Int) {
        self.value = i
    }
    
}


/// Objective Abstraction of our Testing
/// One suite holds many tests and neatly prints them out by conforming to the CustomStringConvertible protocol
struct TestSuite {
    var name: String?
    var tests: [TestCase] = []
}

/// Extension for protocol conformance. Look how clean this is!
extension TestSuite: CustomStringConvertible {
    var description: String {
        var stringBuilder = "\(name ?? "A Test Suite")\n-----\n"
        
        /// 'test' needs to be mutable here
        for var test in tests {
            stringBuilder.append("[\(test.totalTime.truncate(places: 2))] - From \(test.startTime?.truncate(places: 2) ?? 0) to \(test.endTime?.truncate(places: 2) ?? 0)\n")
        }
        
        stringBuilder.append("-----")
        
        return stringBuilder
    }
}


struct TestCase {
    var startTime: CFAbsoluteTime?
    var endTime: CFAbsoluteTime?
    
    /// Making use of constant property to cache value :)
    lazy var totalTime: CFAbsoluteTime = {
        return (endTime ?? 0) - (startTime ?? 0)
    }()
    
    /// Notice the functional paradigm of passing a lambda function, or known as
    /// a closure in Swift.
    mutating func runTest(_ passedFunc: () -> ()) {
        startTime = CFAbsoluteTimeGetCurrent()
        passedFunc()
        endTime = CFAbsoluteTimeGetCurrent()
    }
    
}

/**
        DEMO STARTS HERE
 */

// Creating our SuperInt
var si = SuperInt(12351315313)

// Creating our test suites and calling the functions 5 times.
var computedSuite = TestSuite()
computedSuite.name = "Computed Suite"

for _ in 0..<5 {
    var computedTestCase = TestCase()
    computedTestCase.runTest {
        // This notation silences the unused result warning
        _ = si.computedIsPrime
    }
}

var constantSuite = TestSuite()
constantSuite.name = "Constant Suite"

for _ in 0..<5 {
    var constantTestCase = TestCase()
    
    // This notation silences the unused result warning
    constantTestCase.runTest {
        _ = si.isPrime
    }
}

/// Conforming to CustomStringConvertible lets us format the print output of our object
/// This is like overriding toString() in Java
print(computedSuite)
print(constantSuite)
