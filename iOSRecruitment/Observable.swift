import Foundation

public class Observable<ObservedType> {
    
    public typealias Observer = (Observable<ObservedType>, ObservedType) -> Void
    private var observers: [Observer]
    public var value: ObservedType {
        didSet {
            notifyObservers(value)
        }
    }
    
    public init(_ value: ObservedType) {
        self.value = value
        observers = []
    }
    
    public func bind(observer: @escaping Observer) {
        self.observers.append(observer)
    }
    
    private func notifyObservers(_ value: ObservedType) {
        self.observers.forEach { [unowned self](observer) in
            observer(self, value)
        }
    }
}
