import Foundation

struct TaskAPIService {
    
    private func generateMockedList() -> [Task] {
        return [Task("task1"), Task("task2"), Task("Task3")]
    }

    func getTasks(success: @escaping([Task]) -> Void) {
        let random = 3.0 / Double.random(in: 2.0 ... 6.0)
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + random) {
            success(self.generateMockedList())
        }
    }

}
