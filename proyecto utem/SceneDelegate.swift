import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Crear ventana
        let window = UIWindow(windowScene: windowScene)

        // Cargar tu pantalla de login
        let rootVC = PantallaLogin()
        let navController = UINavigationController(rootViewController: rootVC)

        // Mostrarla
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}


