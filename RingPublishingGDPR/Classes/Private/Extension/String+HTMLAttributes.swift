//
//  String+HTMLAttributes.swift
//  RingPublishingGDPR
//
//  Created by Adam Szeremeta on 11/02/2021.
//

import Foundation

extension String {

    func convertfromHTML(using font: UIFont, textColor color: UIColor?) -> NSAttributedString? {
        let textData = Data(self.utf8)
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: textData,
                                                             options: options,
                                                             documentAttributes: nil) else {
            return nil
        }

        // Change font attribute
        let modifiedString = NSMutableAttributedString(attributedString: attributedString)

        let wholeRange = NSRange(location: 0, length: attributedString.length)
        let enumerationOptions: NSAttributedString.EnumerationOptions = .longestEffectiveRangeNotRequired

        attributedString.enumerateAttribute(.font, in: wholeRange, options: enumerationOptions, using: { (value, range, _) in
            if let currentFont = value as? UIFont, let newFont = applyTraitsFromFont(currentFont, to: font) {
                modifiedString.addAttribute(.font, value: newFont, range: range)
            }
        })

        // We have to override color so it looks good in dark mode
        modifiedString.addAttribute(.foregroundColor, value: color ?? .black, range: wholeRange)

        return modifiedString
    }
}

// MARK: Private
private extension String {

    func applyTraitsFromFont(_ originalFont: UIFont, to newFont: UIFont) -> UIFont? {
        let originalTraits = originalFont.fontDescriptor.symbolicTraits
        var traitsToApply = [UIFontDescriptor.SymbolicTraits]()

        switch originalTraits {
        case let traits where traits.contains(.traitBold) && traits.contains(.traitItalic):
            traitsToApply.append(.traitBold)
            traitsToApply.append(.traitItalic)

        case let traits where traits.contains(.traitBold):
            traitsToApply.append(.traitBold)

        case let traits where traits.contains(.traitItalic):
            traitsToApply.append(.traitItalic)

        default:
            break
        }

        var newFontTraits = newFont.fontDescriptor.symbolicTraits
        traitsToApply.forEach {
            newFontTraits.insert($0)
        }

        guard let newFontDescriptor = newFont.fontDescriptor.withSymbolicTraits(newFontTraits) else {
            return newFont
        }

        return UIFont(descriptor: newFontDescriptor, size: newFont.pointSize)
    }
}
