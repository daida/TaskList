//
//  TaskApiServiceMock.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 04/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

// MARK: Mock extension

extension TaskAPIService {
    
    /// Return an Array of `Task`
    ///
    /// - Returns: an array of `Task`
    func generateMockedList() -> [Task] {
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
L'utilisateur doit pouvoir supprimer une tache depuis la liste ou depuis la page de detail, Il faut egallement que sa suppression soit persisté en cas d'arret et de redemarrage de l'app.
""")
        
        let task5 = Task(title: "Afficher une liste de tache", done: false, text: """
L'objectif est d'afficher une liste de tache dans une collection, ou il sera possible de dire si la tache est terminé ou pas
""")
        let task6 = Task(title: "Afficher le detail d'une tache", done: false, text: """
L'objectif est d'afficher le detail d'une tache avec son texte descriptif
""")
        let task7 = Task(title: "Sauvegarder l'etat", done: false, text: """
L'utilisateur doit retrouve sa liste de tache dans l'etat ou il la laisse
""")
        
        let task8 = Task(title: "Rajouter la suppression", done: false, text: """
L'utilisateur doit pouvoir supprimer une tache depuis la liste ou depuis la page de detail, Il faut egallement que sa suppression soit persisté en cas d'arret et de redemarrage de l'app.
""")
        
        let task9 = Task(title: "Afficher une liste de tache", done: false, text: """
L'objectif est d'afficher une liste de tache dans une collection, ou il sera possible de dire si la tache est terminé ou pas
""")
        let task10 = Task(title: "Afficher le detail d'une tache", done: false, text: """
L'objectif est d'afficher le detail d'une tache avec son texte descriptif
""")
        let task11 = Task(title: "Sauvegarder l'etat", done: false, text: """
L'utilisateur doit retrouve sa liste de tache dans l'etat ou il la laisse
""")
        
        let task12 = Task(title: "Rajouter la suppression", done: false, text: """
L'utilisateur doit pouvoir supprimer une tache depuis la liste ou depuis la page de detail, Il faut egallement que sa suppression soit persisté en cas d'arret et de redemarrage de l'app.
""")
        
        let task13 = Task(title: "Afficher une liste de tache", done: false, text: """
L'objectif est d'afficher une liste de tache dans une collection, ou il sera possible de dire si la tache est terminé ou pas
""")
        let task14 = Task(title: "Afficher le detail d'une tache", done: false, text: """
L'objectif est d'afficher le detail d'une tache avec son texte descriptif
""")
        let task15 = Task(title: "Sauvegarder l'etat", done: false, text: """
L'utilisateur doit retrouve sa liste de tache dans l'etat ou il la laisse
""")
        
        let task16 = Task(title: "Rajouter la suppression", done: false, text: """
L'utilisateur doit pouvoir supprimer une tache depuis la liste ou depuis la page de detail, Il faut egallement que sa suppression soit persisté en cas d'arret et de redemarrage de l'app.
""")
        return [task1, task2, task3, task4, task5, task6, task7, task8, task9, task10, task11, task12, task13, task14,  task15, task16]
    }
    
}
