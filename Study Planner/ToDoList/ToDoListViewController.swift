//
//  ToDoListViewController.swift
//  Study Planner
//
//  Created by Viktor Andreev on 26.11.2022.
//

import Foundation
import UIKit

class toDoListViewController: UIViewController {
    
    private let toDoListTableView: UITableView = {
        UITableView(frame: CGRect.zero, style: .plain)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
        title = "Задачи"
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add,
                            target: self,
                            action: #selector(pushAddItemButton)),
            UIBarButtonItem(image: UIImage(systemName: "pencil"),
                            style: .plain,
                            target: self,
                            action: #selector(pushEditItemsButton))
        ]
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
        
        setupToDoListTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func setupToDoListTableView() {
        view.addSubview(toDoListTableView)
        setupToDoListTableViewConstraints()
        toDoListTableView.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .systemGray6
            default:
                return .systemBackground
            }
        }
        toDoListTableView.alwaysBounceVertical = false
        registerToDoListCell()
    }
    
    private func setupToDoListTableViewConstraints() {
        toDoListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toDoListTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            toDoListTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            toDoListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            toDoListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        toDoListTableView.layer.cornerRadius = 10
    }

    
    @objc
    func pushAddItemButton() {
        let alertController = UIAlertController(title: "Создание нового задания", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Название"
        }

        let alertAction1 = UIAlertAction(title: "Создать", style: .cancel) { (alert) in
            //add new item
            let newItem = alertController.textFields![0].text
            if newItem != "" {
                addItem(nameItem: newItem!)
                self.toDoListTableView.reloadData()
            }
        }

        let alertAction2 = UIAlertAction(title: "Отменить", style: .default) { (alert) in

        }

        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    func pushEditItemsButton() {
        toDoListTableView.setEditing(!toDoListTableView.isEditing, animated: false)
        self.toDoListTableView.reloadData()
    }
    
    private func registerToDoListCell() {
        toDoListTableView.register(toDoListViewControllerCell.self, forCellReuseIdentifier: "toDoListViewControllerCell")
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        removeItem(at: indexPath.row)
        toDoListTableView.deleteRows(at: [indexPath], with: .fade)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            removeItem(at: indexPath.row)
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveItem(from: fromIndexPath.row, to: to.row)
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteNoteAction =
        UIContextualAction(style: .destructive, title: "Удалить", handler: {_,_,_ in
            self.deleteItem(at: indexPath)
        })
        deleteNoteAction.image = UIImage(systemName: "trash")
   
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteNoteAction])
        
        return swipeConfiguration
    }
}

extension toDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeState(at: indexPath.row)
//        if changeState(at: indexPath.row) {
//            tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "check.png")
//        } else {
//            tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "uncheck.png")
//        }
        tableView.reloadData()
    }
    
    
}

extension toDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ToDoItems.count
    }

     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = toDoListTableView.dequeueReusableCell(withIdentifier: "toDoListViewControllerCell", for: indexPath) as? toDoListViewControllerCell else {
            fatalError()
        }
        print(7563)
//        cell.textLabel?.text = ToDoItems[indexPath.row]["Name"] as? String
//
//        if (ToDoItems[indexPath.row]["isCompleted"] as? Bool) == true {
//            cell.imageView?.image = UIImage(named: "check.png")
//        } else {
//            cell.imageView?.image = UIImage(named: "uncheck.png")
//        }
//
        cell.configure(status: ToDoItems[indexPath.row]["isCompleted"] as? Bool ?? false,
                       text: ToDoItems[indexPath.row]["Name"] as? String ?? "Ошибка при получении текста",
                       isEdit: toDoListTableView.isEditing)
        cell.selectionStyle = .none
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
