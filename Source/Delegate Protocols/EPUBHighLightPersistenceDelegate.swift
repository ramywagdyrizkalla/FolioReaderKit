//
//  EPUBPersistenceProtocol.swift
//  FolioReaderKit
//
//  Created by Ramy Rizkalla on 10/21/18.
//  Copyright © 2018 FolioReader. All rights reserved.
//

import Foundation

public protocol EPUBHighLightPersistenceDelegate {
    
    func saveHighLight(by highlight: Highlight)
    
    func remove(withConfiguration readerConfig: FolioReaderConfig)
    
    func removeHighLight(by highlightId: String)
    
    func getHighLight(by highlightId: String) -> Highlight
    
    func updateHighLight(by highlightId: String, type: HighlightStyle)
    
    func updateHighLight(by highlightId: String, note: String)

    func allHighlights(by bookId: String, andPage page: NSNumber?) -> [Highlight]
    
    func all(withConfiguration readerConfig: FolioReaderConfig) -> [Highlight]
    
}
