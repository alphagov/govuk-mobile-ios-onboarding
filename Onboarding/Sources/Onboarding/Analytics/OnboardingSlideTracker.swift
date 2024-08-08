import Foundation

class OnboardingSlideTracker: Tracker {
    var firebaseService: FirebaseService

    init(firebaseService: FirebaseService = OnboardingFirebaseService()) {
        self.firebaseService = firebaseService
    }
}
