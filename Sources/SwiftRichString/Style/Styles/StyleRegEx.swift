//
//  SwiftRichString
//  https://github.com/malcommac/SwiftRichString
//  Copyright (c) 2020 Daniele Margutti (hello@danielemargutti.com).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

/// StyleRegEx allows you to define a style which is applied when one or more regular expressions
/// matches are found in source string or attributed string.
public class StyleRegEx: StyleProtocol {
	
	//MARK: - PROPERTIES
	
	/// Regular expression
	public private(set) var regex: NSRegularExpression
	
	/// Base style. If set it will be applied in set before any match.
	public private(set) var baseStyle: StyleProtocol?
	
	/// Applied style
	private var style: StyleProtocol
	
	/// Style attributes
	public var attributes: [NSAttributedString.Key : Any] {
		return style.attributes
	}
	
    public var textTransforms: [TextTransform]?
    
	/// Font attributes
	public var fontStyle: FontStyle? {
		return style.fontStyle
	}
	
	//MARK: - INIT
	
	/// Initialize a new regular expression style matcher.
	///
	/// - Parameters:
	///   - base: base style. it will be applied (in set or add) to the entire string before any other operation.
	///   - pattern: pattern of regular expression.
	///   - options: matching options of the regular expression; if not specified `caseInsensitive` is used.
	///   - handler: configuration handler for style.
	public init?(base: StyleProtocol? = nil,
				 pattern: String, options: NSRegularExpression.Options = .caseInsensitive,
				 handler: @escaping Style.StyleInitHandler) {
		do {
			self.regex = try NSRegularExpression(pattern: pattern, options: options)
			self.baseStyle = base
			self.style = Style(handler)
		} catch {
			return nil
		}
	}
	
	//MARK: - METHOD OVERRIDES
	
	public func set(to source: String, range: NSRange?) -> AttributedString {
		//let attributed = NSMutableAttributedString(string: source, attributes: (baseStyle?.attributes ?? [:]))
		//return setWithRegExp(to: attributed, add: false, range: range)
        return StyleDecorator.set(regexStyle: self, to: source, add: true, range: range)
	}
	
	public func add(to source: AttributedString, range: NSRange?) -> AttributedString {
		/*if let base = baseStyle {
			source.addAttributes(base.attributes, range: (range ?? NSMakeRange(0, source.length)))
		}*/
        
        return StyleDecorator.set(regexStyle: self, to: source, add: true, range: range)
		//return setWithRegExp(to: source, add: true, range: range)
	}
	
	public func set(to source: AttributedString, range: NSRange?) -> AttributedString {
		/*if let base = baseStyle {
			source.setAttributes(base.attributes, range: (range ?? NSMakeRange(0, source.length)))
		}*/
        
        return StyleDecorator.set(regexStyle: self, to: source, add: false, range: range)
		//return setWithRegExp(to: source, add: false, range: range)
	}
	
	//MARK: - INTERNAL FUNCTIONS
	
	/// Regular expression matcher.
	///
	/// - Parameters:
	///   - str: attributed string.
	///   - add: `true` to append styles, `false` to replace existing styles.
	///   - range: range, `nil` to apply the style to entire string.
	/// - Returns: modified attributed string
	/*private func setWithRegExp(to str: AttributedString, add: Bool, range: NSRange?) -> AttributedString {
		let rangeValue = (range ?? NSMakeRange(0, str.length))
		
		let matchOpts = NSRegularExpression.MatchingOptions(rawValue: 0)
		regex.enumerateMatches(in: str.string, options: matchOpts, range: rangeValue) {
			(result : NSTextCheckingResult?, _, _) in
			if let r = result {
				if add {
					str.addAttributes(attributes, range: r.range)
				} else {
					str.setAttributes(attributes, range: r.range)
				}
			}
		}
		
		return str
	}*/
    
    
    // MARK: ---
    
    @discardableResult
    public func remove(from source: AttributedString, range: NSRange?) -> AttributedString {
      //  attributes.keys.forEach({
      //      source.removeAttribute($0, range: (range ?? NSMakeRange(0, source.length)))
      //  })
        //return applyTextTransform(textTransforms, to: source)
    //    return source.applyTextTransform(textTransforms)
        return StyleDecorator.remove(style: self, from: source, range: nil)
    }
	
}

/*
public extension AttributedString {
    
    func applyTextTransform(_ transforms: [TextTransform]?) -> AttributedString {
        guard let transforms = transforms else {
            return self
        }
        
        let mutable = mutableStringCopy()
        let fullRange = NSRange(location: 0, length: mutable.length)
        mutable.enumerateAttributes(in: fullRange, options: [], using: { (_, range, _) in
            var substring = mutable.attributedSubstring(from: range).string
            transforms.forEach {
                substring = $0.transformer(substring)
            }
            mutable.replaceCharacters(in: range, with: substring)
        })
        
        return mutable
    }
    
}
*/