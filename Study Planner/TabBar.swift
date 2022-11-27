//
//  TabBar.swift
//  Study Planner
//
//  Created by Viktor Andreev on 26.11.2022.
//

import UIKit

final class tabBarController: UITabBarController {
    
    private let images = ["note.text", "checkmark.circle"]
    private let titles = ["Заметки", "Задачи"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {

        
        let vc1 = UINavigationController(rootViewController: notesViewController())
        let vc2 = UINavigationController(rootViewController: toDoListViewController())
        
        vc1.tabBarItem.title = titles[0]
        vc2.tabBarItem.title = titles[1]
        
        setViewControllers([vc1, vc2], animated: false)
        
        guard let items = tabBar.items else {
            return
        }
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
            if (i == 1) {
                items[i].selectedImage = UIImage(systemName: images[i] + ".fill")
            } else {
                items[i].selectedImage = UIImage(systemName: images[i], withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            }
        }
        
        tabBar.tintColor = itemColor()
        tabBar.unselectedItemTintColor = itemColor()
        modalPresentationStyle = .fullScreen
        
        setupShadow()
        
        if #available(iOS 15.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            let tabBarItemAppearance = UITabBarItemAppearance()

            tabBarItemAppearance.normal.titleTextAttributes = [.foregroundColor: itemColor()]
            tabBarItemAppearance.normal.iconColor = itemColor()
            tabBarItemAppearance.selected.titleTextAttributes = [.foregroundColor: itemColor()]
            tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
            
            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    private func setupShadow()
    {
        tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowOffset = .zero
        tabBar.layer.shadowRadius = 2
    }
    
    private func itemColor() -> UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .white
            default:
                return .black
            }
        }
    }
}
