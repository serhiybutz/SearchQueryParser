import XCTest
@testable import SearchQueryParser

final class SearchQueryApplicatorTests: XCTestCase {
    let textSample1 = ###"Lorem ipsum dolor sit amet 😀, "consectetur" (adipiscing)/{elit}⁉️"###
    func test_positive_01() {
        let queryTerms = SearchQueryParser("lorem")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.markedRanges.sorted(by: { $0.location < $1.location }),
                       [NSRange(location: 0, length: 5)])
    }
    func test_negative_01() {
        let queryTerms = SearchQueryParser("XYZ")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNil(sut)
    }
    func test_positive_02() {
        let queryTerms = SearchQueryParser("lorem elit")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.markedRanges.sorted(by: { $0.location < $1.location }),
                       [NSRange(location: 0, length: 5),
                        NSRange(location: 59, length: 4)])
    }
    func test_positive_03() {
        let queryTerms = SearchQueryParser("ipsum lorem")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.markedRanges.sorted(by: { $0.location < $1.location }),
                       [NSRange(location: 0, length: 5),
                        NSRange(location: 6, length: 5)])
    }
    func test_positive_04() {
        let queryTerms = SearchQueryParser("ipsum😀lorem")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.markedRanges.sorted(by: { $0.location < $1.location }),
                       [NSRange(location: 0, length: 5),
                        NSRange(location: 6, length: 5)])
    }
    func test_positive_05() {
        let queryTerms = SearchQueryParser("lorem ipsum elit")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.markedRanges.sorted(by: { $0.location < $1.location }),
                       [NSRange(location: 0, length: 5),
                        NSRange(location: 6, length: 5),
                        NSRange(location: 59, length: 4)])
    }

    func test_positive_wildcard_01() {
        let queryTerms = SearchQueryParser("ips*")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.markedRanges.sorted(by: { $0.location < $1.location }),
                       [NSRange(location: 6, length: 3)])
    }

    func test_positive_wildcard_02() {
        let queryTerms = SearchQueryParser("ipsum* amet")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.markedRanges.sorted(by: { $0.location < $1.location }),
                       [NSRange(location: 6, length: 5),
                        NSRange(location: 22, length: 4)])
    }

    func test_negative_wildcard_01() {
        let queryTerms = SearchQueryParser("XYZ*")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNil(sut)
    }

    func test_positive_wildcard_03() {
        let queryTerms = SearchQueryParser("*olor")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.markedRanges.sorted(by: { $0.location < $1.location }),
                       [NSRange(location: 13, length: 4)])
    }

    func test_positive_wildcard_04() {
        let queryTerms = SearchQueryParser("*olor lorem")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.markedRanges.sorted(by: { $0.location < $1.location }),
                       [NSRange(location: 0, length: 5),
                        NSRange(location: 13, length: 4)])
    }

    func test_positive_mixed_01() {
        let queryTerms = SearchQueryParser("*olor lorem *ing")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.markedRanges.sorted(by: { $0.location < $1.location }),
                       [NSRange(location: 0, length: 5),
                        NSRange(location: 13, length: 4),
                        NSRange(location: 53, length: 3)])
    }

    func test_positive_logic_01() {
        let queryTerms = SearchQueryParser("lorem and ipsum")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.markedRanges.sorted(by: { $0.location < $1.location }),
                       [NSRange(location: 0, length: 5),
                        NSRange(location: 6, length: 5)])
    }

    func test_positive_logic_02() {
        let queryTerms = SearchQueryParser("lorem and !XYZ")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.markedRanges.sorted(by: { $0.location < $1.location }),
                       [NSRange(location: 0, length: 5)])
    }

    func test_positive_logic_03() {
        let queryTerms = SearchQueryParser("!XYZ")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.markedRanges.sorted(by: { $0.location < $1.location }),
                       [])
    }

    func test_negative_logic_01() {
        let queryTerms = SearchQueryParser("lorem and !ipsum")
        let textScanner = SearchTextScanner(textSample1)
        let sut = SearchQueryApplicator(searchQueryTerms: queryTerms!, textTokens: textScanner)
        XCTAssertNil(sut)
    }
}
