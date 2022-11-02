///
/// This file is part of the SearchQueryParser package.
/// (c) Serhiy Butz <serhiybutz@gmail.com>
///
/// For the full copyright and license information, please view the LICENSE
/// file that was distributed with this source code.
///

import Foundation

extension CharacterIteratable {
    @inline(__always)
    var nextCharacter: Character? {
        currentIndex = currentIndex.map { text.index(after: $0) } ?? text.startIndex
        guard let index = currentIndex, index < text.endIndex else { return nil }
        return text[index]
    }

    @inline(__always)
    func isAtStart() -> Bool { currentIndex == nil }

    @inline(__always)
    func isAtEnd() -> Bool { currentIndex! == text.index(before: text.endIndex) }    
}
