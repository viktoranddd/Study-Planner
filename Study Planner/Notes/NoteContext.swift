//
//  NoteContext.swift
//  Study Planner
//
//  Created by Viktor Andreev on 26.11.2022.
//

import Foundation

struct NoteContext {
    let title: String
    let note: String

    
    init(
        title: String,
        note: String
    ) {
        self.title = title
        self.note = note
    }
}
