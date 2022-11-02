///
/// This file is part of the SearchQueryParser package.
/// (c) Serhiy Butz <serhiybutz@gmail.com>
///
/// For the full copyright and license information, please view the LICENSE
/// file that was distributed with this source code.
///

import Foundation

/// Abstract syntax tree node.
public indirect enum SearchQueryASTNode: Equatable {
    case or(_ leftChild: SearchQueryASTNode, _ rightChild: SearchQueryASTNode)
    case and(_ leftChild: SearchQueryASTNode, _ rightChild: SearchQueryASTNode)
    case not(_ child: SearchQueryASTNode)
    case parentheses(_ child: SearchQueryASTNode)
    case prefixWildcardTerm(String)
    case suffixWildcardTerm(String)
    case term(String)
}

extension SearchQueryASTNode: CustomStringConvertible {
    public var description: String {
        dump()
            .map { "\(String(repeating: " ", count: $0.level * 4))\($0.text)" }
            .joined(separator: "\n") + "\n"
    }

    public typealias DumpLine = (level: Int, text: String)
    public func dump(_ level: Int = 0) -> [DumpLine] {
        var result: [DumpLine] = []
        switch self {
        case .or(let leftChild, let rightChild):
            result.append((level: level, text: "OR:"))
            result += leftChild.dump(level + 1)
            result += rightChild.dump(level + 1)
        case .and(let leftChild, let rightChild):
            result.append((level: level, text: "AND:"))
            result += leftChild.dump(level + 1)
            result += rightChild.dump(level + 1)
        case .not(let child):
            result.append((level: level, text: "NOT:"))
            result += child.dump(level + 1)
        case .parentheses(let child):
            result.append((level: level, text: "PARENS:"))
            result += child.dump(level + 1)
        case .prefixWildcardTerm(let term):
            result.append((level: level, text: "\"...\(term)\""))
        case .suffixWildcardTerm(let term):
            result.append((level: level, text: "\"\(term)...\""))
        case .term(let term):
            result.append((level: level, text: "\"\(term)\""))
        }
        return result
    }
}
