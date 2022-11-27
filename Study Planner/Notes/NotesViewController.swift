//
//  NotesViewController.swift
//  Study Planner
//
//  Created by Viktor Andreev on 26.11.2022.
//

import Foundation
import UIKit

class notesViewController: UIViewController {

    private let notesTableViewController: UITableView = {
        UITableView(frame: CGRect.zero, style: .plain)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Заметки"
        view.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .systemBackground
            default:
                return .systemGray6
            }
        }
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add,
                            target: self,
                            action: #selector(pushAddNoteButton)),
            UIBarButtonItem(image: UIImage(systemName: "pencil"),
                            style: .plain,
                            target: self,
                            action: #selector(pushEditNotesButton))
        ]
        
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

        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.notesTableViewController.reloadData()
    }

    private func setupTable() {
        view.addSubview(notesTableViewController)
        setupTableViewConstraints()
        notesTableViewController.delegate = self
        notesTableViewController.dataSource = self
        notesTableViewController.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .systemGray6
            default:
                return .systemBackground
            }
        }
        notesTableViewController.alwaysBounceVertical = false
        registerCell()
        
    }
    
    private func setupTableViewConstraints() {
        notesTableViewController.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notesTableViewController.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            notesTableViewController.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            notesTableViewController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            notesTableViewController.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        notesTableViewController.layer.cornerRadius = 10
    }

    private func registerCell() {
        notesTableViewController.register(notesViewControllerCell.self, forCellReuseIdentifier: "notesViewControllerCell")
    }
    
    @objc
    func pushAddNoteButton() {
        addNote()
        let noteViewController = noteViewController()
        noteViewController.setup(id: 0, context: NoteContext(
            title: Notes[0]["Title"] ?? "",
            note: Notes[0]["Note"] ?? ""))
        navigationController?.pushViewController(noteViewController, animated: true)
    }
    
    @objc
    func pushEditNotesButton() {
        notesTableViewController.setEditing(!notesTableViewController.isEditing, animated: false)
        self.notesTableViewController.reloadData()
    }
    
    private func shareNote(at index: Int) {
        // set up activity view controller
        let textToShare = [ getTextToShare(at: index) ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func deleteNote(at indexPath: IndexPath) {
        removeNote(at: indexPath.row)
        notesTableViewController.deleteRows(at: [indexPath], with: .fade)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let shareNoteAction =
        UIContextualAction(style: .normal, title: "Поделиться", handler: {_,_,_ in
            self.shareNote(at: indexPath.row)
        })
        shareNoteAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [shareNoteAction])
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteNoteAction =
        UIContextualAction(style: .destructive, title: "Удалить", handler: {_,_,_ in
            self.deleteNote(at: indexPath)
        })
        deleteNoteAction.image = UIImage(systemName: "trash")
   
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteNoteAction])
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveNote(from: fromIndexPath.row, to: to.row)
        tableView.reloadData()     
    }
    
}

extension notesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteViewController = noteViewController()
        noteViewController.setup(id: indexPath.row,
                                 context: NoteContext(
                                    title: Notes[indexPath.row]["Title"] ?? "",
                                    note: Notes[indexPath.row]["Note"] ?? ""))
        
        
        navigationController?.pushViewController(noteViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView,
                            contextMenuConfigurationForRowAt indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
                suggestedActions in
            let shareNoteAction =
                UIAction(title: NSLocalizedString("Share Note", comment: ""),
                         image: UIImage(systemName: "square.and.arrow.up")) { action in
                    self.shareNote(at: indexPath.row)
                }
            
            let deleteAction =
                UIAction(title: NSLocalizedString("Delete Note", comment: ""),
                         image: UIImage(systemName: "trash"),
                         attributes: .destructive) { action in
                    self.deleteNote(at: indexPath)
                }

            return UIMenu(title: "", children: [shareNoteAction, deleteAction])
        })
    }
    
}

extension notesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = notesTableViewController.dequeueReusableCell(withIdentifier: "notesViewControllerCell", for: indexPath) as? notesViewControllerCell else {
            fatalError()
        }
        cell.configure(title: Notes[indexPath.row]["Title"] ?? "Нет заголовка",
                       note: Notes[indexPath.row]["Note"] ?? "Нет заметки",
                       isEdit: notesTableViewController.isEditing)
        cell.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .systemGray6
            default:
                return .systemBackground
            }
        }
        return cell
    }
    
}

