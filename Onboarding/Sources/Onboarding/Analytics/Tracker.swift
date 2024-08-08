import Foundation

protocol Tracker {
    var firebaseService: FirebaseService { get set }
    func track(_ trackable: TrackingInterface)
}

extension Tracker {
    func track(_ trackable: TrackingInterface) {
        trackable.services.forEach { provider in
            switch provider {
            case .firebase(let name, let params):
                firebaseService.sendEvent(name: name,
                                          params: params)
            }
        }
    }
}
