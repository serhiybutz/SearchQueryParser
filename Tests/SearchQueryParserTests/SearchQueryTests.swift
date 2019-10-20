import XCTest
@testable import SearchQueryParser

final class SearchQueryParserTests: XCTestCase {
    func test_primitive_01() {
        let sut = SearchQueryParser("")
        XCTAssertNil(sut)
    }

    func test_primitive_02() {
        let sut = SearchQueryParser(" ")
        XCTAssertNil(sut)
    }

    func test_primitive_03() {
        let sut = SearchQueryParser("*")
        XCTAssertNil(sut)
    }

    func test_primitive_04() {
        let sut = SearchQueryParser("\"")
        XCTAssertNil(sut)
    }

    func test_primitive_05() {
        let sut = SearchQueryParser("(")
        XCTAssertNil(sut)
    }

    func test_primitive_06() {
        let sut = SearchQueryParser(")")
        XCTAssertNil(sut)
    }

    func test_primitive_07() {
        let sut = SearchQueryParser("foo")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("FOO")
        )
    }

    func test_primitive_08() {
        let sut = SearchQueryParser("太感一路況過下原")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("太感一路況過下原")
        )
    }

    func test_primitive_09() {
        let sut = SearchQueryParser("foo ")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("FOO")
        )
    }
    func test_primitive_10() {
        let sut = SearchQueryParser(" foo")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("FOO")
        )
    }

    func test_and_01() {
        let sut = SearchQueryParser("foo & bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_and_02() {
        let sut = SearchQueryParser("太感一路況過下原 & 他發原是發")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("太感一路況過下原"),
                .term("他發原是發")
            )
        )
    }

    func test_and_03() {
        let sut = SearchQueryParser("foo AND bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_and_04() {
        let sut = SearchQueryParser("foo bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_and_05() {
        let sut = SearchQueryParser("foo😀bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_and_06() {
        let sut = SearchQueryParser("foo &bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("BAR")
            )
        )
    }
    func test_and_07() {
        let sut = SearchQueryParser("foo& bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("BAR")
            )
        )
    }
    func test_and_08() {
        let sut = SearchQueryParser("foo&bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("BAR")
            )
        )
    }
    func test_and_09() {
        let sut = SearchQueryParser("foo & bar & baz")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .and(
                    .term("FOO"),
                    .term("BAR")
                ),
                .term("BAZ")
            )
        )
    }

    func test_or_01() {
        let sut = SearchQueryParser("foo | bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_or_02() {
        let sut = SearchQueryParser("foo OR bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_or_03() {
        let sut = SearchQueryParser("foo| bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_or_04() {
        let sut = SearchQueryParser("foo |bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_or_05() {
        let sut = SearchQueryParser("foo | bar | baz")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .or(
                    .term("FOO"),
                    .term("BAR")
                ),
                .term("BAZ")
            )
        )
    }

    func test_not_01() {
        let sut = SearchQueryParser("!")
        XCTAssertNil(sut)
    }

    func test_not_02() {
        let sut = SearchQueryParser("! foo")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .not(
                .term("FOO")
            )
        )
    }

    func test_not_03() {
        let sut = SearchQueryParser("NOT foo")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .not(
                .term("FOO")
            )
        )
    }

    func test_not_04() {
        let sut = SearchQueryParser("NOT NOT foo")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("FOO")
        )
    }

    func test_not_05() {
        let sut = SearchQueryParser("! ! foo")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("FOO")
        )
    }

    func test_not_06() {
        let sut = SearchQueryParser("!!foo")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("FOO")
        )
    }

    func test_parentheses_01() {
        let sut = SearchQueryParser("()")
        XCTAssertNil(sut)
    }

    func test_parentheses_02() {
        let sut = SearchQueryParser("(foo)")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("FOO")
        )
    }

    func test_parentheses_03() {
        let sut = SearchQueryParser("(foo) ")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("FOO")
        )
    }

    func test_parentheses_04() {
        let sut = SearchQueryParser(" (foo)")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("FOO")
        )
    }

    func test_parentheses_05() {
        let sut = SearchQueryParser("( foo)")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("FOO")
        )
    }

    func test_parentheses_06() {
        let sut = SearchQueryParser("(foo )")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("FOO")
        )
    }

    func test_parentheses_07() {
        let sut = SearchQueryParser("(foo & bar)")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_parentheses_08() {
        let sut = SearchQueryParser("(foo & bar )")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_parentheses_09() {
        let sut = SearchQueryParser("(foo | bar)")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_parentheses_10() {
        let sut = SearchQueryParser("(foo | bar) & baz")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .or(
                    .term("FOO"),
                    .term("BAR")),
                .term("BAZ")
            )
        )
    }

    func test_parentheses_11() {
        let sut = SearchQueryParser("baz & (foo | bar)")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("BAZ"),
                .or(
                    .term("FOO"),
                    .term("BAR")
                )
            )
        )
    }

    func test_parentheses_12() {
        let sut = SearchQueryParser("(foo | bar) & (baz | bazz)")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .or(
                    .term("FOO"),
                    .term("BAR")
                ),
                .or(
                    .term("BAZ"),
                    .term("BAZZ")
                )
            )
        )
    }

    func test_parentheses_13() {
        let sut = SearchQueryParser("foo (bar | baz)")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .or(
                    .term("BAR"),
                    .term("BAZ"))
            )
        )
    }

    func test_parentheses_14() {
        let sut = SearchQueryParser("(foo OR bar) baz")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .or(
                    .term("FOO"),
                    .term("BAR")),
                .term("BAZ")
            )
        )
    }

    func test_wildcard_01() {
        let sut = SearchQueryParser("*foo")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .prefixWildcardTerm("FOO")
        )
    }

    func test_wildcard_02() {
        let sut = SearchQueryParser("*太感一路況過下原")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .prefixWildcardTerm("太感一路況過下原")
        )
    }

    func test_wildcard_03() {
        let sut = SearchQueryParser("*foo | bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .prefixWildcardTerm("FOO"),
                .term("BAR")
            )
        )
    }
    func test_wildcard_04() {
        let sut = SearchQueryParser("*foo| bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .prefixWildcardTerm("FOO"),
                .term("BAR")
            )
        )
    }
    func test_wildcard_05() {
        let sut = SearchQueryParser("*foo|bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .prefixWildcardTerm("FOO"),
                .term("BAR")
            )
        )
    }
    func test_wildcard_06() {
        let sut = SearchQueryParser("*foo | *bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .prefixWildcardTerm("FOO"),
                .prefixWildcardTerm("BAR")
            )
        )
    }
    func test_wildcard_07() {
        let sut = SearchQueryParser("*foo & bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .prefixWildcardTerm("FOO"),
                .term("BAR")
            )
        )
    }
    func test_wildcard_08() {
        let sut = SearchQueryParser("foo*")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .suffixWildcardTerm("FOO")
        )
    }
    func test_wildcard_09() {
        let sut = SearchQueryParser("foo*bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .suffixWildcardTerm("FOO"),
                .term("BAR"))
        )
    }
    func test_wildcard_10() {
        let sut = SearchQueryParser("foo* | bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .suffixWildcardTerm("FOO"),
                .term("BAR"))
        )
    }
    func test_wildcard_11() {
        let sut = SearchQueryParser("foo*| bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .suffixWildcardTerm("FOO"),
                .term("BAR"))
        )
    }
    func test_wildcard_12() {
        let sut = SearchQueryParser("foo*|bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .suffixWildcardTerm("FOO"),
                .term("BAR"))
        )
    }
    func test_wildcard_13() {
        let sut = SearchQueryParser("foo* & bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .suffixWildcardTerm("FOO"),
                .term("BAR"))
        )
    }
    func test_wildcard_14() {
        let sut = SearchQueryParser("foo* & bar*")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .suffixWildcardTerm("FOO"),
                .suffixWildcardTerm("BAR"))
        )
    }
    func test_wildcard_15() {
        let sut = SearchQueryParser("foo* & *bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .suffixWildcardTerm("FOO"),
                .prefixWildcardTerm("BAR"))
        )
    }
    func test_wildcard_16() {
        let sut = SearchQueryParser("*foo & bar*")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .prefixWildcardTerm("FOO"),
                .suffixWildcardTerm("BAR"))
        )
    }

    func test_phrase_01() {
        let sut = SearchQueryParser(###""foo""###)
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("FOO")
        )
    }

    func test_phrase_02() {
        let sut = SearchQueryParser(###""foo bar""###)
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_phrase_03() {
        let sut = SearchQueryParser(###""foo and bar""###)
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .and(
                    .term("FOO"),
                    .term("AND")
                ),
                .term("BAR")
            )
        )
    }

    func test_phrase_04() {
        let sut = SearchQueryParser(###""&|!foo&|!bar&|!""###)
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_mixed_01() {
        let sut = SearchQueryParser("foo & bar | baz")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .and(
                    .term("FOO"),
                    .term("BAR")
                ),
                .term("BAZ")
            )
        )
    }

    func test_mixed_02() {
        let sut = SearchQueryParser("foo | bar & baz")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .term("FOO"),
                .and(
                    .term("BAR"),
                    .term("BAZ")
                )
            )
        )
    }

    func test_mixed_03() {
        let sut = SearchQueryParser("foo & ! baz")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .not(
                    .term("BAZ")
                )
            )
        )
    }

    func test_mixed_04() {
        let sut = SearchQueryParser("foo | !baz")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .term("FOO"),
                .not(
                    .term("BAZ")
                )
            )
        )
    }

    func test_mixed_05() {
        let sut = SearchQueryParser("!foo | !baz")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .not(
                    .term("FOO")
                ),
                .not(
                    .term("BAZ")
                )
            )
        )
    }

    func test_mixed_06() {
        let sut = SearchQueryParser("!(!foo & !baz)")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .term("FOO"),
                .term("BAZ")
            )
        )
    }

    func test_mixed_07() {
        let sut = SearchQueryParser("(foo bar)")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("BAR")
            )
        )
    }

    func test_mixed_08() {
        let sut = SearchQueryParser("foo bar | baz")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .and(
                    .term("FOO"),
                    .term("BAR")
                ),
                .term("BAZ")
            )
        )
    }

    func test_mixed_09() {
        let sut = SearchQueryParser("foo !bar | baz")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .and(
                    .term("FOO"),
                    .not(
                        .term("BAR")
                    )
                ),
                .term("BAZ")
            )
        )
    }

    func test_mixed_10() {
        let sut = SearchQueryParser("foo bar baz")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .and(
                    .term("FOO"),
                    .term("BAR")
                ),
                .term("BAZ")
            )
        )
    }

    func test_mixed_11() {
        let sut = SearchQueryParser("foo and")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("AND")
            )
        )
    }

    func test_mixed_12() {
        let sut = SearchQueryParser("and foo")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("AND"),
                .term("FOO")
            )
        )
    }

    func test_mixed_13() {
        let sut = SearchQueryParser("foo or")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("FOO"),
                .term("OR")
            )
        )
    }

    func test_mixed_14() {
        let sut = SearchQueryParser("and or")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("AND"),
                .term("OR")
            )
        )
    }

    func test_mixed_15() {
        let sut = SearchQueryParser("or and")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("OR"),
                .term("AND")
            )
        )
    }

    func test_mixed_16() {
        let sut = SearchQueryParser("or or")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("OR"),
                .term("OR")
            )
        )
    }

    func test_mixed_17() {
        let sut = SearchQueryParser("or or or")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .or(
                .term("OR"),
                .term("OR")
            )
        )
    }

    func test_mixed_18() {
        let sut = SearchQueryParser("and and")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("AND"),
                .term("AND")
            )
        )
    }

    func test_mixed_19() {
        let sut = SearchQueryParser("and and and")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("AND"),
                .term("AND")
            )
        )
    }

    func test_mixed_20() {
        let sut = SearchQueryParser("or not")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("OR"),
                .term("NOT")
            )
        )
    }

    func test_mixed_21() {
        let sut = SearchQueryParser("or !")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("OR")
        )
    }

    func test_mixed_22() {
        let sut = SearchQueryParser("and not")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("AND"),
                .term("NOT")
            )
        )
    }

    func test_mixed_23() {
        let sut = SearchQueryParser("and !")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .term("AND")
        )
    }

    func test_mixed_24() {
        let sut = SearchQueryParser("and (foo bar)")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("AND"),
                .and(
                    .term("FOO"),
                    .term("BAR")
                )
            )
        )
    }

    func test_mixed_25() {
        let sut = SearchQueryParser("and (foo bar")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("AND"),
                .and(
                    .term("FOO"),
                    .term("BAR")
                )
            )
        )
    }

    func test_mixed_26() {
        let sut = SearchQueryParser("and (foo)")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("AND"),
                .term("FOO")
            )
        )
    }

    func test_mixed_27() {
        let sut = SearchQueryParser("and (foo")
        XCTAssertNotNil(sut)
        XCTAssertEqual(
            sut!.astRoot,
            .and(
                .term("AND"),
                .term("FOO")
            )
        )
    }
}
