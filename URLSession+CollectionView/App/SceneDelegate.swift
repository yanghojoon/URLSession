//
//  SceneDelegate.swift
//  URLSession+CollectionView
//
//  Created by 양호준 on 2023/10/15.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
        
        let navigationViewController = UINavigationController()
        navigationViewController.view.backgroundColor = .white
        window?.rootViewController = navigationViewController
        
        let viewController = ViewController()
        navigationViewController.pushViewController(viewController, animated: false)
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

