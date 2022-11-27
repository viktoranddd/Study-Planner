//
//  NotesModel.swift
//  Study Planner
//
//  Created by Viktor Andreev on 26.11.2022.
//

import Foundation
import UIKit

var Notes: [[String: String]] {
    set {
        UserDefaults.standard.set(newValue, forKey: "StudyPlannerNotesDataKey")
        UserDefaults.standard.synchronize()
    }
    
    get {
        if let array = UserDefaults.standard.array(forKey: "StudyPlannerNotesDataKey") as? [[String: String]] {
            return array
        } else {
            return []
        }
    }
}



func addNote() {
    Notes.insert(["Title": "", "Note": ""], at: 0)
}

func removeNote(at index: Int) {
    Notes.remove(at: index)
}

func moveNote(from: Int, to: Int) {
    let fromData = Notes[from]
    Notes.remove(at: from)
    Notes.insert(fromData, at: to)
}

func getTextToShare(at index: Int) -> String {
    print("Share text")
    
    var text: String = ""
    
    if Notes[index]["Title"] != "" {
        text = (Notes[index]["Title"] ?? "") + "\n\n"
    }
    
    text = text + (Notes[index]["Note"] ?? "")
            
            
    return text
}

func shareNoteAsFile(at index: Int) {
    print("Share Note")
}
