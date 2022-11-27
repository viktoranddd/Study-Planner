//
//  noteViewController.swift
//  Study Planner
//
//  Created by Viktor Andreev on 26.11.2022.
//

import Foundation
import UIKit

class noteViewController: UIViewController {
        
    private var noteId: Int = 0
    
    private let titleTextField: UITextField = {
        UITextField(frame: CGRect.zero)
    }()
    
    private let noteTextView: UITextView = {
        UITextView(frame: CGRect.zero)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleTextField)
        view.addSubview(noteTextView)
        setupTitleTextField()
        setupNoteTextField()
        title = Notes[noteId]["Title"] ?? "Заметка"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(pushShareNoteButton))
        view.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .systemBackground
            default:
                return .systemGray6
            }
        }
        
        navigationController?.navigationBar.tintColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .white
            default:
                return .black
            }
        }
        navigationController?.navigationBar.barTintColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .systemBackground
            default:
                return .systemGray6
            }
        }
        navigationController?.navigationBar.shadowImage = UIImage()

        titleTextField.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .systemGray6
            default:
                return .systemBackground
            }
        }
        noteTextView.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .systemGray6
            default:
                return .systemBackground
            }
        }
        
        let additionalView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 20,
                                                  height: titleTextField.frame.height))
        
        titleTextField.font = .boldSystemFont(ofSize: 24)
        titleTextField.leftView = additionalView
        titleTextField.rightView = additionalView
        titleTextField.leftViewMode = .always
        noteTextView.font = .systemFont(ofSize: 18)
        noteTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Notes[noteId]["Title"] = titleTextField.text
        Notes[noteId]["Note"] = noteTextView.text
    }
    
    func setupTitleTextField() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.leftAnchor.constraint(equalTo: view.leftAnchor),
            titleTextField.rightAnchor.constraint(equalTo: view.rightAnchor),
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60)
        ])
    }
    
    func setupNoteTextField() {
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteTextView.leftAnchor.constraint(equalTo: view.leftAnchor),
            noteTextView.rightAnchor.constraint(equalTo: view.rightAnchor),
            noteTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setup(id: Int, context: NoteContext) {
        self.noteId = id
        self.titleTextField.text = Notes[id]["Title"]
        self.noteTextView.text = Notes[id]["Note"]

    }
    
    @objc
    func pushShareNoteButton() {
        Notes[noteId]["Title"] = titleTextField.text
        Notes[noteId]["Note"] = noteTextView.text
        
        let textToShare = [ getTextToShare(at: self.noteId) ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    

}
