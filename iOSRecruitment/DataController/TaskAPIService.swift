import Foundation

// MARK: - TaskAPIService

struct TaskAPIService: TaskAPIServiceInterface {

    // MARK: Private properties
    
    private let dispatchQueue = DispatchQueue(label: "taskApiService", qos: .userInitiated)

    // MARK: Public methods
    
    func getTasks(success: @escaping([Task]) -> Void) {
        let random = 3.0 / Double.random(in: 2.0 ... 6.0)
        self.dispatchQueue.asyncAfter(deadline: .now() + random) {
            success(self.generateMockedList())
        }
    }
}
