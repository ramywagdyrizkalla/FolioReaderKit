//
//  Highlight.swift
//  FolioReaderKit
//
//  Created by Heberti Almeida on 11/08/15.
//  Copyright (c) 2015 Folio Reader. All rights reserved.
//

import Foundation
//import RealmSwift

/// A Highlight object
open class Highlight: NSObject {
    @objc open dynamic var bookname: String!
    @objc open dynamic var bookId: Int = -1
    @objc open dynamic var content: String!
    @objc open dynamic var contentPost: String!
    @objc open dynamic var contentPre: String!
    @objc open dynamic var date: Date!
    @objc open dynamic var highlightId: String!
    @objc open dynamic var page: Int = 0
    @objc open dynamic var type: Int = 0
    @objc open dynamic var startOffset: Int = -1
    @objc open dynamic var endOffset: Int = -1
    @objc open dynamic var noteForHighlight: String?
    
    var highLightCoreDataSaveDelegate: EPUBHighLightPersistenceDelegate?
    static var highLightCoreDataRetrieveDelegate: EPUBHighLightPersistenceDelegate?
    
}
