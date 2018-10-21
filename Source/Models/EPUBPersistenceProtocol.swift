//
//  EPUBPersistenceProtocol.swift
//  FolioReaderKit
//
//  Created by Ramy Rizkalla on 10/21/18.
//  Copyright © 2018 FolioReader. All rights reserved.
//

import Foundation

protocol EPUBPersistenceProtocol {
    
    func saveHighLight(highlight: Highlight)
    
    func remove(withConfiguration readerConfig: FolioReaderConfig)
    
    func removeHighLightById(highlightId: String)
    
    func getHighLightgById(highlightId: String) -> Highlight
    
    func updateHighLightById(highlightId: String, type: HighlightStyle)
    
    func allByBookId(bookId: String, andPage page: NSNumber?) -> [Highlight]
    
    func all(withConfiguration readerConfig: FolioReaderConfig) -> [Highlight]
    
}
