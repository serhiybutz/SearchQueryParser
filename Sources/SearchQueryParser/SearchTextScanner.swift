///
/// This file is part of the SearchQueryParser package.
/// (c) Serhiy Butz <serhiybutz@gmail.com>
///
/// For the full copyright and license information, please view the LICENSE
/// file that was distributed with this source code.
///

import Foundation

public final class SearchTextScanner: CharacterIteratable {
    // MARK: - State

    public let originalText: String
    let text: String

    private(set) var tokenInfos: [TokenInfo] = []

    public init(_ text: String) {
        self.originalText = text
        self.text = text.uppercased()
        scan()
    }

    // MARK: - CharacterIteratable

    var currentIndex: String.Index?
}

// MARK: - Scanning

extension SearchTextScanner {
    func scan() {
        var lowerBound: String.Index?
        for _ in 0... {
            let ch = nextCharacter
            if let ch = ch, isLetter(ch) {
                if lowerBound == nil {
                    lowerBound = currentIndex!
                }
            } else {
                if let lower = lowerBound {
                    let range = NSRange(lower...text.index(before: currentIndex!), in: text)
                    tokenInfos.append(TokenInfo(token: text[Range(range, in: text)!], range: range))
                    lowerBound = nil
                }
                guard ch != nil else { break }
            }
        }
    }
}

extension SearchTextScanner: CustomStringConvertible {
    public var description: String { self.map({ $0.token }).joined(separator: " ") }
}
