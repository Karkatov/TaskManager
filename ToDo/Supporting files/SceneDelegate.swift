

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = setWindow(scene)
    }
    
    private func setWindow(_ scene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        let todoTableVC = TasksListTableView()
        navigationController.viewControllers = [todoTableVC]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return window
    }
}

