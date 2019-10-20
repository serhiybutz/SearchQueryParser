import XCTest
@testable import SearchQueryParser

final class SearchTextScannerTests: XCTestCase {
    func test_01() {
        let sut = SearchTextScanner("")
        XCTAssertEqual(sut.map { $0 },
                       [])
        XCTAssertEqual(sut.map { $0 }, [])
    }
    func test_02() {
        let sut = SearchTextScanner("foo")
        XCTAssertEqual(sut.map { $0 },
                       [.init(token: "FOO", range: NSRange(location: 0, length: 3))])
    }
    func test_03() {
        let sut = SearchTextScanner("foo bar")
        XCTAssertEqual(sut.map { $0 },
                       [.init(token: "FOO", range: NSRange(location: 0, length: 3)),
                        .init(token: "BAR", range: NSRange(location: 4, length: 3))])
    }
    func test_04() {
        let sut = SearchTextScanner("Foo bar. Baz - bazz!")
        XCTAssertEqual(sut.map { $0 },
                       [.init(token: "FOO", range: NSRange(location: 0, length: 3)),
                        .init(token: "BAR", range: NSRange(location: 4, length: 3)),
                        .init(token: "BAZ", range: NSRange(location: 9, length: 3)),
                        .init(token: "BAZZ", range: NSRange(location: 15, length: 4))])
    }

    func test_05() {
        let sut = SearchTextScanner("太感一路況過下原 他發原是發")
        XCTAssertEqual(sut.map { $0 },
                       [.init(token: "太感一路況過下原", range: NSRange(location: 0, length: 8)),
                        .init(token: "他發原是發", range: NSRange(location: 9, length: 5))])
    }

    func test_06() {
        let sut = SearchTextScanner("foo😀bar")
        XCTAssertEqual(sut.map { $0 },
                       [.init(token: "FOO", range: NSRange(location: 0, length: 3)),
                        .init(token: "BAR", range: NSRange(location: 5, length: 3))])
    }
}
