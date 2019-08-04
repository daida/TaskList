import Foundation

// MARK: - TaskAPIService

/// Retrive `Task` array from remote API
/// Here it's from a mocked task list, the network latency is simulated by a delayed dispatching
struct TaskAPIService: TaskAPIServiceInterface {

    // MARK: Private properties

    /// DispatchQueue used only for `Task` API fetching
    private let dispatchQueue = DispatchQueue(label: "taskApiService", qos: .userInitiated)

    // MARK: Public methods

    /// Retrive `Task` Array from the remote API
    ///
    /// - Parameter completion: completion closure with an array of `Task`
    /// Because it's a mocked list, there is no error handling.
    func getTasks(completion: @escaping APIServiceCompletion) {
        let random = 3.0 / Double.random(in: 2.0 ... 6.0)
        self.dispatchQueue.asyncAfter(deadline: .now() + random) {
            completion(self.generateMockedList())
        }
    }
}
