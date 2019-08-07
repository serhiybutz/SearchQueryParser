///
/// This file is part of the SearchQueryParser package.
/// (c) Serge Bouts <sergebouts@gmail.com>
///
/// For the full copyright and license information, please view the LICENSE
/// file that was distributed with this source code.
///

import Foundation

public final class SearchQueryApplicator<T: Collection> where T.Element == TokenInfo {
    public let searchQueryTerms: SearchQueryTerms
    public let textTokens: T

    public private(set) var markedRanges: Set<NSRange> = []

    public init?(searchQueryTerms: SearchQueryTerms, textTokens: T) {
        self.searchQueryTerms = searchQueryTerms
        self.textTokens = textTokens
        guard process(searchQueryTerms.astRoot) else { return nil }
        guard processWithMarking(searchQueryTerms.astRoot) else { return nil }
    }

    func process(_ node: SearchQueryASTNode) -> Bool {
        switch node {
        case .or(let left, let right):
            return process(left) || process(right)
        case .and(let left, let right):
            return process(left) && process(right)
        case .not(let child):
            return !process(child)
        case .parentheses(let child):
            return !process(child)
        case .prefixWildcardTerm(let term):
            return find(.prefixWildcardTerm(term))
        case .suffixWildcardTerm(let term):
            return find(.suffixWildcardTerm(term))
        case .term(let term):
            return find(.regularTerm(term))
        }
    }

    enum FindTerm {
        case prefixWildcardTerm(String)
        case suffixWildcardTerm(String)
        case regularTerm(String)
    }

    func find(_ term: FindTerm) -> Bool {
        switch term {
        case .prefixWildcardTerm(let term):
            return textTokens.firstIndex(where: { $0.token.count >= term.count && $0.token.suffix(term.count) == term }) != nil
        case .suffixWildcardTerm(let term):
            return textTokens.firstIndex(where: { $0.token.count >= term.count && $0.token.prefix(term.count) == term }) != nil
        case .regularTerm(let term):
            return textTokens.firstIndex(where: { $0.token == term }) != nil
        }
    }

    func processWithMarking(_ node: SearchQueryASTNode) -> Bool {
        switch node {
        case .or(let left, let right):
            let leftResult = processWithMarking(left)
            let rightResult = processWithMarking(right)
            return leftResult || rightResult
        case .and(let left, let right):
            return processWithMarking(left) && processWithMarking(right)
        case .not:
            // With NOT nodes pushed out we can just ignore them
            return true
        case .parentheses(let child):
            return processWithMarking(child)
        case .prefixWildcardTerm(let term):
            return findWithMarking(.prefixWildcardTerm(term))
        case .suffixWildcardTerm(let term):
            return findWithMarking(.suffixWildcardTerm(term))
        case .term(let term):
            return findWithMarking(.regularTerm(term))
        }
    }

    func findWithMarking(_ term: FindTerm) -> Bool {
        switch term {
        case .prefixWildcardTerm(let term):
            var success = false
            textTokens.enumerated().forEach { index, tokenInfo in
                let diff = tokenInfo.token.count - term.count
                guard diff >= 0,
                      tokenInfo.token.suffix(term.count) == term else { return }
                markedRanges.insert(NSRange(location: tokenInfo.range.location + diff, length: tokenInfo.range.length - diff))
                success = true
            }
            return success
        case .suffixWildcardTerm(let term):
            var success = false
            textTokens.forEach { tokenInfo in
                let diff = tokenInfo.token.count - term.count
                guard diff >= 0,
                      tokenInfo.token.prefix(term.count) == term else { return }
                markedRanges.insert(NSRange(location: tokenInfo.range.location, length: tokenInfo.range.length - diff))
                success = true
            }
            return success
        case .regularTerm(let term):
            var success = false
            textTokens.enumerated().forEach { index, tokenInfo in
                guard tokenInfo.token == term else { return }
                markedRanges.insert(tokenInfo.range)
                success = true
            }
            return success
        }
    }
}
