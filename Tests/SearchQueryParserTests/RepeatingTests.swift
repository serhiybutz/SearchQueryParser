import XCTest
@testable import SearchQueryParser

final class RepeatingTests: XCTestCase {
    func test_optional_unlimited() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(0...) {
            count += 1
            return count < 3
        }

        XCTAssertTrue(result)
        XCTAssertEqual(count, 3)
    }

    func test_optional_limited01() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(...10) {
            count += 1
            return count < 3
        }

        XCTAssertTrue(result)
        XCTAssertEqual(count, 3)
    }

    func test_optional_limited02() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(...10) {
            count += 1
            return true
        }

        XCTAssertTrue(result)
        XCTAssertEqual(count, 10)
    }

    func test_optional_limited03() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(..<10) {
            count += 1
            return true
        }

        XCTAssertTrue(result)
        XCTAssertEqual(count, 9)
    }

    func test_mandatory_neg() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(2...) {
            count += 1
            return false
        }

        XCTAssertFalse(result)
        XCTAssertEqual(count, 1)
    }

    func test_pos01() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(1...) {
            count += 1
            return count == 1
        }

        XCTAssertTrue(result)
        XCTAssertEqual(count, 2)
    }

    func test_pos02() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(1...) {
            count += 1
            return count < 3
        }

        XCTAssertTrue(result)
        XCTAssertEqual(count, 3)
    }

    func test_neg04() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(2...) {
            count += 1
            return count < 2
        }

        XCTAssertFalse(result)
        XCTAssertEqual(count, 2)
    }

    func test_pos05() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(2...) {
            count += 1
            return count < 3
        }

        XCTAssertTrue(result)
        XCTAssertEqual(count, 3)
    }

    func test_mandatory_optional_max() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(2...3) {
            count += 1
            return true
        }

        XCTAssertTrue(result)
        XCTAssertEqual(count, 3)
    }

    func test_mandatory_optional_halfopen_max() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(2..<4) {
            count += 1
            return true
        }

        XCTAssertTrue(result)
        XCTAssertEqual(count, 3)
    }

    func test_optional_halfopen_max() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(..<4) {
            count += 1
            return true
        }

        XCTAssertTrue(result)
        XCTAssertEqual(count, 3)
    }

    func test_mandatory_optional_pos() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(2...3) {
            count += 1
            return count < 3
        }

        XCTAssertTrue(result)
        XCTAssertEqual(count, 3)
    }

    func test_mandatory_optional_max02() {
        let sut = SearchQueryParser("foo")

        XCTAssertNotNil(sut)

        var count = 0
        let result = sut!.repeating(2...3) {
            count += 1
            return count < 10
        }

        XCTAssertTrue(result)
        XCTAssertEqual(count, 3)
    }
}
