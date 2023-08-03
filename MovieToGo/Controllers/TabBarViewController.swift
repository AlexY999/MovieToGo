import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBarAppearance()
    }
    
    private func configureTabBarAppearance() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.6117647059, blue: 0.02745098039, alpha: 1)
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }
}
