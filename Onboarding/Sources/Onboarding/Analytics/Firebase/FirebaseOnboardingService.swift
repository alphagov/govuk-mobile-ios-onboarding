import Foundation
import FirebaseAnalytics

 class OnboardingFirebaseService: FirebaseService {
    func sendEvent(name: String,
                   params: [String: String]) {
        Analytics.logEvent(name, parameters: params)
        print(name)
        print(params)
    }
}
