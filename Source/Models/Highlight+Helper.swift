//
//  Highlight+Helper.swift
//  FolioReaderKit
//
//  Created by Heberti Almeida on 06/07/16.
//  Copyright (c) 2015 Folio Reader. All rights reserved.
//

import Foundation
//import RealmSwift

/**
 HighlightStyle type, default is .Yellow.
 */
public enum HighlightStyle: Int {
    case yellow
    case green
    case blue
    case pink
    case underline

    public init () {
        // Default style is `.yellow`
        self = .yellow
    }

    /**
     Return HighlightStyle for CSS class.
     */
    public static func styleForClass(_ className: String) -> HighlightStyle {
        switch className {
        case "highlight-yellow":    return .yellow
        case "highlight-green":     return .green
        case "highlight-blue":      return .blue
        case "highlight-pink":      return .pink
        case "highlight-underline": return .underline
        default:                    return .yellow
        }
    }

    /**
     Return CSS class for HighlightStyle.
     */
    public static func classForStyle(_ style: Int) -> String {

        let enumStyle = (HighlightStyle(rawValue: style) ?? HighlightStyle())
        switch enumStyle {
        case .yellow:       return "highlight-yellow"
        case .green:        return "highlight-green"
        case .blue:         return "highlight-blue"
        case .pink:         return "highlight-pink"
        case .underline:    return "highlight-underline"
        }
    }

    /// Color components for the style
    ///
    /// - Returns: Tuple of all color compnonents.
    private func colorComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        switch self {
        case .yellow:       return (red: 255, green: 235, blue: 107, alpha: 0.9)
        case .green:        return (red: 192, green: 237, blue: 114, alpha: 0.9)
        case .blue:         return (red: 173, green: 216, blue: 255, alpha: 0.9)
        case .pink:         return (red: 255, green: 176, blue: 202, alpha: 0.9)
        case .underline:    return (red: 240, green: 40, blue: 20, alpha: 0.6)
        }
    }

    /**
     Return CSS class for HighlightStyle.
     */
    public static func colorForStyle(_ style: Int, nightMode: Bool = false) -> UIColor {
        let enumStyle = (HighlightStyle(rawValue: style) ?? HighlightStyle())
        let colors = enumStyle.colorComponents()
        return UIColor(red: colors.red/255, green: colors.green/255, blue: colors.blue/255, alpha: (nightMode ? colors.alpha : 1))
    }
}

/// Completion block
public typealias Completion = (_ error: NSError?) -> ()

extension Highlight {
    
    /// Save a Highlight with completion block
    ///
    /// - Parameters:
    ///   - readerConfig: Current folio reader configuration.
    ///   - completion: Completion block.
    public func persist(withConfiguration readerConfig: FolioReaderConfig, completion: Completion? = nil) {

        if let highlightDelegate = readerConfig.highlightDelegateConfiguration {
            highLightCoreDataSaveDelegate = highlightDelegate
            highLightCoreDataSaveDelegate?.save(highlight: self)
        }
    }

    /// Remove a Highlight
    ///
    /// - Parameter readerConfig: Current folio reader configuration.
    public func remove(withConfiguration readerConfig: FolioReaderConfig) {
//        do {
//            guard let realm = try? Realm(configuration: readerConfig.realmConfiguration) else {
//                return
//            }
//            try realm.write {
//                realm.delete(self)
//                try realm.commitWrite()
//            }
//        } catch let error as NSError {
//            print("Error on remove highlight: \(error)")
//        }
    }

    public static func removeById(withConfiguration readerConfig: FolioReaderConfig, highlightId: String) {
        Highlight.highLightCoreDataRetrieveDelegate?.removeHighLight(byHighlightId: highlightId)
    }

    public static func getById(withConfiguration readerConfig: FolioReaderConfig, highlightId: String) -> Highlight {
        
        guard let retrieveDelegate = Highlight.highLightCoreDataRetrieveDelegate else {
            return Highlight()
        }
        
        return retrieveDelegate.getHighLight(byHighlightId: highlightId)
    }

    public static func updateById(withConfiguration readerConfig: FolioReaderConfig, highlightId: String, type: HighlightStyle) {
        guard let highlightDelegate = readerConfig.highlightDelegateConfiguration else {
            return
        }
        Highlight.highLightCoreDataRetrieveDelegate = highlightDelegate
        Highlight.highLightCoreDataRetrieveDelegate?.updateHighLight(byHighlightId: highlightId, type: type)
    
    }
    
    public static func updateById(withConfiguration readerConfig: FolioReaderConfig, highlightId: String, note: String) {
        guard let conf = readerConfig.highlightDelegateConfiguration else {
            return
        }
        Highlight.highLightCoreDataRetrieveDelegate = conf
        Highlight.highLightCoreDataRetrieveDelegate?.updateHighLight(byHighlightId: highlightId, note: note)
        
    }

    public static func allByBookId(withConfiguration readerConfig: FolioReaderConfig, bookId: Int, andPage page: NSNumber? = nil) -> [Highlight] {

        guard let highlightDelegate = readerConfig.highlightDelegateConfiguration else {
            return []
        }
        
        Highlight.highLightCoreDataRetrieveDelegate = highlightDelegate
        
        guard let retrieveDelegate = Highlight.highLightCoreDataRetrieveDelegate else {
            return []
        }
        
        return retrieveDelegate.allHighlights(byBookId: bookId, andPage: page)
 
    }

    /// Return all Highlights
    ///
    /// - Parameter readerConfig: - readerConfig: Current folio reader configuration.
    /// - Returns: Return all Highlights
//    public static func all(withConfiguration readerConfig: FolioReaderConfig) -> [Highlight] {
//        var highlights: [Highlight]?
//        do {
//            let realm = try Realm(configuration: readerConfig.realmConfiguration)
//            highlights = realm.objects(Highlight.self).toArray(Highlight.self)
//            return (highlights ?? [])
//        } catch let error as NSError {
//            print("Error on fetch all: \(error)")
//            return []
//        }
//    }
}

// MARK: - HTML Methods

extension Highlight {

    public struct MatchingHighlight {
        var text: String
        var id: String
        var startOffset: String
        var endOffset: String
        var bookName: String
        var bookID: Int
        var currentPage: Int
    }

    /**
     Match a highlight on string.
     */
    public static func matchHighlight(_ matchingHighlight: MatchingHighlight) -> Highlight? {
        let pattern = "<highlight id=\"\(matchingHighlight.id)\" onclick=\".*?\" class=\"(.*?)\">((.|\\s)*?)</highlight>"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let matches = regex?.matches(in: matchingHighlight.text, options: [], range: NSRange(location: 0, length: matchingHighlight.text.utf16.count))
        let str = (matchingHighlight.text as NSString)

        let mapped = matches?.map { (match) -> Highlight in
            var contentPre = str.substring(with: NSRange(location: match.range.location-kHighlightRange, length: kHighlightRange))
            var contentPost = str.substring(with: NSRange(location: match.range.location + match.range.length, length: kHighlightRange))

            // Normalize string before save
            contentPre = Highlight.subString(ofContent: contentPre, fromRangeOfString: ">", withPattern: "((?=[^>]*$)(.|\\s)*$)")
            contentPost = Highlight.subString(ofContent: contentPost, fromRangeOfString: "<", withPattern: "^((.|\\s)*?)(?=<)")

            let highlight = Highlight()
            highlight.highlightId = matchingHighlight.id
            highlight.type = HighlightStyle.styleForClass(str.substring(with: match.range(at: 1))).rawValue
            highlight.date = Date()
            highlight.content = Highlight.removeSentenceSpanTag(str.substring(with: match.range(at: 2)))
            highlight.contentPre = Highlight.removeSentenceSpanTag(contentPre)
            highlight.contentPost = Highlight.removeSentenceSpanTag(contentPost)
            highlight.page = matchingHighlight.currentPage
            highlight.bookname = matchingHighlight.bookName
            highlight.bookId = matchingHighlight.bookID
            highlight.startOffset = (Int(matchingHighlight.startOffset) ?? -1)
            highlight.endOffset = (Int(matchingHighlight.endOffset) ?? -1)

            return highlight
        }

        return mapped?.first
    }

    private static func subString(ofContent content: String, fromRangeOfString rangeString: String, withPattern pattern: String) -> String {
        var updatedContent = content
        if updatedContent.range(of: rangeString) != nil {
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
            let searchString = regex?.firstMatch(in: updatedContent, options: .reportProgress, range: NSRange(location: 0, length: updatedContent.count))

            if let string = searchString, (string.range.location != NSNotFound) {
                updatedContent = (updatedContent as NSString).substring(with: string.range)
            }
        }

        return updatedContent
    }

    /// Remove a Highlight from HTML by ID
    ///
    /// - Parameters:
    ///   - page: The page containing the HTML.
    ///   - highlightId: The ID to be removed
    /// - Returns: The removed id
    @discardableResult public static func removeFromHTMLById(withinPage page: FolioReaderPage?, highlightId: String) -> String? {
        guard let currentPage = page else { return nil }
        
        if let removedId = currentPage.webView?.js("removeHighlightById('\(highlightId)')") {
            return removedId
        } else {
            print("Error removing Highlight from page")
            return nil
        }
    }
    
    /**
     Remove span tag before store the highlight, this span is added on JavaScript.
     <span class=\"sentence\"></span>
     
     - parameter text: Text to analise
     - returns: Striped text
     */
    public static func removeSentenceSpanTag(_ text: String) -> String {
        
        // Remove from text
        func removeFrom(_ text: String, withPattern pattern: String) -> String {
            var locator = text
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
            let matches = regex?.matches(in: locator, options: [], range: NSRange(location: 0, length: locator.utf16.count))
            let str = (locator as NSString)
            
            var newLocator = ""
            matches?.forEach({ (match: NSTextCheckingResult) in
                newLocator += str.substring(with: match.range(at: 1))
            })
            
            if (matches?.count > 0 && newLocator.isEmpty == false) {
                locator = newLocator
            }
            
            return locator
        }
        
        let pattern = "<span class=\"sentence\">((.|\\s)*?)</span>"
        let cleanText = removeFrom(text, withPattern: pattern)
        return cleanText
    }
}
