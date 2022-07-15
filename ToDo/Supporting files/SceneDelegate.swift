

import UIKit
import LocalAuthentication

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = setWindow(scene)
        blurEffect()
    }
    
    private func setWindow(_ scene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        let todoTableVC = TasksListTableView()
        navigationController.viewControllers = [todoTableVC]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        checkUser()
        return window
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        if window?.viewWithTag(10) == nil {
            blurEffect()
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        checkUser()
    }
    
    func checkUser() {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please authenticate to proceed.") { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.window!.viewWithTag(10)?.removeFromSuperview()
                    }
                } else {
                    guard let error = error else { return }
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func blurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.window!.frame
        blurView.tag = 10
        self.window?.addSubview(blurView)
    }
}

