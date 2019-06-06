///
/// This file is part of the SearchQueryParser package.
/// (c) Serge Bouts <sergebouts@gmail.com>
///
/// For the full copyright and license information, please view the LICENSE
/// file that was distributed with this source code.
///

import Foundation

public final class SearchQueryParser: Parsing, SearchQueryTerms {
    // MARK: - Types

    public struct Options: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        public static let shouldRemoveParens = Options(rawValue: 1 << 0)
        public static let shouldPushOutNOTNodes = Options(rawValue: 1 << 1)
        public static let all: Options = [.shouldRemoveParens, .shouldPushOutNOTNodes]
    }

    // MARK: - State

    /// Abstract syntax tree's root node.
    internal(set) public var astRoot: SearchQueryASTNode!

    // MARK: - State

    public let text: String

    public init?(_ query: String, options: Options = .all) {
        self.text = query.uppercased()
        guard let ast = parse() else { return nil }
        self.astRoot = ast
        if options.contains(.shouldRemoveParens) {
            self.astRoot = rebuildASTRemovingParens(astRoot)
        }
        if options.contains(.shouldPushOutNOTNodes) {
            self.astRoot = rebuildASTPushingOutNOTNodes(astRoot)
        }
    }

    // MARK: - CharacterIteratable

    var currentIndex: String.Index?
}

// MARK: - Parsing
extension SearchQueryParser {
    func parse() -> SearchQueryASTNode? {
        attempt {
            guard isAtStart(),
                  let higherNode = parseSweepingMuteAndTerm(),
                  parseSeparator(treatingAsSeparator: "*!&|()\"") || true,
                  isAtEnd()
            else { return nil }
            return higherNode
        }
    }

    func parseSweepingMuteAndTerm() -> SearchQueryASTNode? {
        repeating(1..., { (previous: SearchQueryASTNode?) -> SearchQueryASTNode? in
            guard
                let higherNode = parseMuteAndTerm() ??
                    {
                        parseSeparator(treatingAsSeparator: "*!&|()\"")
                        return parseMuteAndTerm()
                    }()
            else { return nil }
            if let prevResult = previous {
                let result = fixASTPrecedenceForMuteAndNode(.and(prevResult, higherNode))
                return result
            } else {
                return higherNode
            }
        })
    }

    func parseMuteAndTerm() -> SearchQueryASTNode? {
        repeating(1..., { (previous: SearchQueryASTNode?) -> SearchQueryASTNode? in
            guard let higherNode = parseOrTerm()
            else { return nil }
            if let prevResult = previous {
                let result = fixASTPrecedenceForMuteAndNode(.and(prevResult, higherNode))
                return result
            } else {
                return higherNode
            }
        })
    }

    func parseOrTerm() -> SearchQueryASTNode? {
        repeating(1..., { previous in
            if let prevResult = previous {
                parseSeparator()
                guard let higherNode: SearchQueryASTNode =
                        attempt({
                            guard parseWord("|"),
                                  let term = parseAndTerm()
                            else { return nil }
                            return term
                        }) ??
                        attempt({
                            guard parseWord("OR"),
                                  let term = parseAndTerm()
                            else { return nil }
                            return term
                        })
                else { return nil }
                return .or(prevResult, higherNode)
            } else {
                return parseAndTerm()
            }
        })
    }

    func parseAndTerm() -> SearchQueryASTNode? {
        repeating(1..., { previous in
            if let prevResult = previous {
                parseSeparator()
                guard let higherNode: SearchQueryASTNode =
                        attempt({
                            guard parseWord("&"),
                                  let term = parseNotTerm()
                            else { return nil }
                            return term
                        }) ??
                        attempt({
                            guard parseWord("AND"),
                                  let term = parseNotTerm()
                            else { return nil }
                            return term
                        })
                else { return nil }
                return .and(prevResult, higherNode)
            } else {
                return parseNotTerm()
            }
        })
    }

    func parseNotTerm() -> SearchQueryASTNode? {
        parseSeparator()
        guard
            let node: SearchQueryASTNode = attempt({
                guard parseWord("!"),
                      let term = parseNotTerm()
                else { return nil }
                return .not(term)
            }) ??
            attempt({
                guard parseWord("NOT"),
                      let term = parseNotTerm()
                else { return nil }
                return .not(term)
            })
        else { return parsePrimaryTerm() }
        return node
    }

    func parsePrimaryTerm() -> SearchQueryASTNode? {
        parseBrackets() ??
        parsePhrase() ??
        parsePrefixWildcardSearchTerm() ??
        parseSuffixWildcardSearchTerm() ??
        parseRegularSearchTerm()
    }

    func parseBrackets() -> SearchQueryASTNode? {
        attempt {
            guard parseSeparator() || true,
                  parseWord("("),
                  parseSeparator() || true,
                  let node = parseMuteAndTerm(),
                  parseSeparator() || true,
                  parseWord(")")
            else { return nil }
            return .parentheses(node)
        }
    }

    func parsePhrase() -> SearchQueryASTNode? {
        attempt {
            guard parseSeparator() || true,
                  parseWord("\""),
                  let node: SearchQueryASTNode = repeating(1..., { previous in
                      guard parseSeparator(treatingAsSeparator: "*!&|()") || true,
                            let str = parseSearchTermString()
                      else { return nil }
                      return previous.map { .and($0, .term(str)) } ?? .term(str)
                  }),
                  parseSeparator(treatingAsSeparator: "*!&|()") || true,
                  parseWord("\"")
            else { return nil }
            return node
        }
    }

    func parsePrefixWildcardSearchTerm() -> SearchQueryASTNode? {
        attempt {
            guard parseSeparator() || true,
                  parseWord("*"),
                  let str = parseSearchTermString()
            else { return nil }
            return .prefixWildcardTerm(str)
        }
    }

    func parseSuffixWildcardSearchTerm() -> SearchQueryASTNode? {
        attempt {
            guard parseSeparator() || true,
                  let str = parseSearchTermString(),
                  parseWord("*")
            else { return nil }
            return .suffixWildcardTerm(str)
        }
    }

    func parseRegularSearchTerm() -> SearchQueryASTNode? {
        attempt {
            guard parseSeparator() || true,
                  let str = parseSearchTermString()
            else { return nil }
            return .term(str)
        }
    }

    func parseWord(_ word: String) -> Bool {
        attempt {
            for ch in word {
                guard let nc = nextCharacter, nc == ch else { return false }
            }
            return true
        }
    }

    @discardableResult
    func parseSeparator(treatingAsSeparator additionalSymbols: String = "") -> Bool {
        repeating(1..., {
            guard let ch = nextCharacter else { return false }
            guard additionalSymbols.first(where: { $0 == ch }) == nil else { return true }
            return !(isLetter(ch) || ch == "|" || ch == "&" || ch == "!" || ch == "*" || ch == "(" || ch == ")" || ch == "\"")
        })
    }

    func parseSearchTermString() -> String? {
        repeating(1..., { previous in
            guard let ch = nextCharacter,
                  isLetter(ch) else { return nil }
            return previous.map { "\($0)\(ch)" } ?? "\(ch)"
        })
    }

    func fixASTPrecedenceForMuteAndNode(_ node: SearchQueryASTNode) -> SearchQueryASTNode {
        guard case .and(let left, let right) = node else { return node }
        switch (left, right) {
        case (.or(let leftOrLeft, let leftOrRight), .or(let rightOrLeft, let rightOrRight)):
            return .or(leftOrLeft, .or(.and(leftOrRight, rightOrLeft), rightOrRight))
        case (.or(let leftOrLeft, let leftOrRight), _):
            return .or(leftOrLeft, .and(leftOrRight, right))
        case (_, .or(let rightOrLeft, let rightOrRight)):
            return .or(.and(left, rightOrLeft), rightOrRight)
        default:
            return node
        }
    }

    func rebuildASTRemovingParens(_ node: SearchQueryASTNode) -> SearchQueryASTNode {
        switch node {
        case .or(let left, let right):
            return .or(rebuildASTRemovingParens(left), rebuildASTRemovingParens(right))
        case .and(let left, let right):
            return .and(rebuildASTRemovingParens(left), rebuildASTRemovingParens(right))
        case .not(let child):
            return .not(rebuildASTRemovingParens(child))
        case .parentheses(let child):
            return rebuildASTRemovingParens(child)
        default:
            return node
        }
    }

    func rebuildASTPushingOutNOTNodes(_ node: SearchQueryASTNode) -> SearchQueryASTNode {
        switch node {
        case .or(let left, let right):
            return .or(rebuildASTPushingOutNOTNodes(left), rebuildASTPushingOutNOTNodes(right))
        case .and(let left, let right):
            return .and(rebuildASTPushingOutNOTNodes(left), rebuildASTPushingOutNOTNodes(right))
        case .not(let child):
            switch child {
            case .or(let left, let right):
                return .and(rebuildASTPushingOutNOTNodes(.not(left)), rebuildASTPushingOutNOTNodes(.not(right)))
            case .and(let left, let right):
                return .or(rebuildASTPushingOutNOTNodes(.not(left)), rebuildASTPushingOutNOTNodes(.not(right)))
            case .not(let child):
                return rebuildASTPushingOutNOTNodes(child)
            default:
                return .not(child)
            }
        default:
            return node
        }
    }

    @inline(__always)
    func isLetter(_ ch: Character) -> Bool { ch.isLetter || ch.isNumber || ch == "_" }
}
