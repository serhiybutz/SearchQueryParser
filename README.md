<p align="center">
    <img src="https://img.shields.io/badge/Swift-4.2-orange" alt="Swift" />
    <img src="https://img.shields.io/badge/platform-osx|ios-orange" alt="Platform" />
    <img src="https://img.shields.io/badge/pod-compatible-orange" alt="CocoaPods" />
    <a href="https://github.com/SergeBouts/SearchQueryParser/blob/master/LICENSE">
        <img src="https://img.shields.io/badge/licence-MIT-orange" alt="License" />
    </a>
</p>

# SearchQueryParser

`SearchQueryParser` is a simple Google-like search-engine-query [parser](https://en.wikipedia.org/wiki/Parsing#Parser) for Swift. It takes a search string and builds its [abstract syntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree).

## Features

- Scannerless (lexerless)
- Boolean-like syntax support (AND ("&"), OR ("|"), NOT ("!") logical operators)
- Prefix and suffix wildcards ("*")
- Phrase searches
- Tolerant to syntax errors

## Search Query Grammar

Backus–Naur form (BNF):

```
Query = Sweeping-Mute-And-Term, ⧚’?, EOF ;
Sweeping-Mute-And-Term = Mute-And-Term, { ⧚’?, Mute-And-Term }* ;
Mute-And-Term = Or-Term, Or-Term* ;
Or-Term = And-Term, {⧚?, (‘|’ | “OR”), And-Term }* ;
And-Term = Not-Term, {⧚?, (‘&’ | “AND”), Not-Term }* ;
Not-Term = ⧚?, (’!’ | “NOT”), Not-Term | Primary-Term ;
Primary-Term = ⧚?, ’(‘ ⧚?, Mute-And-Term, ⧚? ‘)’ |
               ⧚?, “‘“ ⧚?, Phrase, ⧚? “‘“ |
               ⧚?, Prefix-Wildcard-Search-Term |
               ⧚?, Suffix-Wildcard-Search-Term |
               ⧚?, Search-Term ;
Phrase = Search-Term, { ⧚, Search-Term }* ;
Prefix-Wildcard-Search-Term = ‘*’, Search-Term ;
Suffix-Wildcard-Search-Term = Search-Term, ‘*’ ;
Search-Term = Letter | Letter, Search-Term ;
Letter = Alpha | Digit | ‘_’ ;
⧚’ = ⧚-(“*” | “!” | “&” | “(“ | “)” | “\””)
⧚ = { ? any-character ?-Letter }+ ;
Alpha = ? alpha-character ? ;
Digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;
```

## How

```swift
import SearchQueryParser

func printQueryAST(_ query: String) {
    guard let parser = SearchQueryParser(query), let ast = parser.astRoot
    else {
        print("Couldn't parse")
        return
    }
    print("AST: \(ast)")
}

printQueryAST("foo bar")
```

## Installation

### CocoaPods

[CocoaPods]: http://cocoapods.org

Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```ruby
platform :osx, '10.12'

target 'YOUR-TARGET' do
  use_frameworks!
  pod 'SearchQueryParser', :git => 'https://github.com/SergeBouts/SearchQueryParser.git'
end
```

Then run `pod install`.

## License

This project is licensed under the MIT license.