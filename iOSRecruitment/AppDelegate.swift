import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let rootNavigationViewController: UINavigationController = UINavigationController()
    var coordinator: TaskCoordinator?

    private func setupRootViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.rootNavigationViewController
        self.window?.makeKeyAndVisible()
    }

    private func setupCoordinator() {
        self.coordinator = TaskCoordinator(navigationController: self.rootNavigationViewController)
        self.coordinator?.start()
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.setupRootViewController()
        self.setupCoordinator()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}
