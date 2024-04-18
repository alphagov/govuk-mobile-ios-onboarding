import Foundation

import Coordination

class MockCoordinator: ParentCoordinator {
    var childCoordinators: [any Coordination.ChildCoordinator] = []
    func start() {}
}
