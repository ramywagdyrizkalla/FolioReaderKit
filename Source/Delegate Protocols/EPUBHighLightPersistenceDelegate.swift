//
//  EPUBPersistenceProtocol.swift
//  FolioReaderKit
//
//  Created by Ramy Rizkalla on 10/21/18.
//  Copyright © 2018 FolioReader. All rights reserved.
//

import Foundation

public protocol EPUBHighLightPersistenceDelegate {
    
    func save(highlight: Highlight)
    
    func remove(withConfiguration readerConfig: FolioReaderConfig)
    
    func removeHighLight(byHighlightId highlightId: String)
    
    func getHighLight(byHighlightId highlightId: String) -> Highlight
    
    func updateHighLight(byHighlightId highlightId: String, type: HighlightStyle)
    
    func updateHighLight(byHighlightId highlightId: String, note: String)

    func allHighlights(byBookId bookId: Int, andPage page: NSNumber?) -> [Highlight]
    
    func all(withConfiguration readerConfig: FolioReaderConfig) -> [Highlight]
    
}
