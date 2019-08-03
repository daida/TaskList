import Foundation

struct TaskAPIService {

    func getTasks(success: @escaping([Task]) -> Void) {
        let random = 3.0 / Double.random(in: 2.0 ... 6.0)
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + random) {
            success(self.generateMockedList())
        }
    }
}

extension TaskAPIService {
    private func generateMockedList() -> [Task] {
        let task1 = Task(title: "Afficher une liste de tache", done: false, text: """
    L'objectif est d'afficher une liste de tache dans une collection, ou il sera possible de dire si la tache est terminé ou pas
""")
        let task2 = Task(title: "Afficher le detail d'une tache", done: false, text: """
    L'objectif est d'afficher le detail d'une tache avec son texte descriptif
""")
        let task3 = Task(title: "Sauvegarder l'etat", done: false, text: """
    L'utilisateur doit retrouve sa liste de tache dans l'etat ou il la laisse
""")
            
    let task4 = Task(title: "Rajouter la suppression", done: false, text: """
    L'utilisateur doit pouvoir supprimer une tache depuis la liste ou depuis la page de detail,
    Il faut egallement que sa suppression soit persisté en cas d'arret et de redemarrage de l'app.
""")
        return [task1, task2, task3, task4]
    }

}
