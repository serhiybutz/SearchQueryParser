///
/// This file is part of the SearchQueryParser package.
/// (c) Serge Bouts <sergebouts@gmail.com>
///
/// For the full copyright and license information, please view the LICENSE
/// file that was distributed with this source code.
///

import Foundation

// MARK: - Collection

extension SearchTextScanner: Collection {
    public typealias Index = Array<TokenInfo>.Index
    public typealias Element = TokenInfo
    public var startIndex: Index { tokenInfos.startIndex }
    public var endIndex: Index { tokenInfos.endIndex }
    public subscript(position: Index) -> Element {
        return tokenInfos[position]
    }
    public func index(after position: Index) -> Index {
        tokenInfos.index(after: position)
    }
}
