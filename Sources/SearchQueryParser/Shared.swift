///
/// This file is part of the SearchQueryParser package.
/// (c) Serhiy Butz <serhiybutz@gmail.com>
///
/// For the full copyright and license information, please view the LICENSE
/// file that was distributed with this source code.
///

import Foundation

@inline(__always)
func isLetter(_ ch: Character) -> Bool { ch.isLetter || ch.isNumber || ch == "_" }
