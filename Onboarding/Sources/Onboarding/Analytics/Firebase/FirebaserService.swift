import Foundation

protocol FirebaseService {
    func sendEvent(name: String, params: [String: String])
}
