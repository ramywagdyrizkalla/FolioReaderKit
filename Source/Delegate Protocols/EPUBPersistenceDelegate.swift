//
//  EpubBookPersistenceDelegate.swift
//  FolioReaderKit
//
//  Created by Ramy Wagdy on 10/24/18.
//  Copyright © 2018 FolioReader. All rights reserved.
//

import Foundation

public protocol EPUBPersistenceDelegate: AnyObject {

    func updateBook(by bookID: Int, with currentPosition: Int)

}
