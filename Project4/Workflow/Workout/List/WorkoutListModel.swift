import Foundation
import struct UIKit.CGFloat

protocol WorkoutListModelDelegate: class {
    func dataRefreshed()
}

final class WorkoutListModel {
    private let persistence: WorkoutPersistenceInterface?
    private var workouts: [Workout]
    private var sortMode = SortBy.defaultOrder
    
    private weak var delegate: WorkoutListModelDelegate?
    
    let rowHeight: CGFloat = 64.0
    
    var count: Int { return workouts.count }
    
    init(delegate: WorkoutListModelDelegate) {
        self.delegate = delegate
        
        let persistence = ApplicationSession.sharedInstance.persistence
        self.persistence = persistence
        workouts = persistence?.savedWorkouts ?? []
    }
}

extension WorkoutListModel {
    func workout(atIndex index: Int) -> Workout? {
        return workouts.element(at: index)
    }
}

#warning("TODO: Implement sorting functionality for workout list")
enum SortBy: String, CaseIterable {
    case dateDescending = "Date (descending)"
    case dateAscending = "Date (ascending)"
    case caloriesDescending = "Calories (descending)"
    case durationDescending = "Duration (descending)"
    case defaultOrder = "Sort by..."
}

extension WorkoutListModel {
    func sortList(by criterium: SortBy) {
        switch criterium {
        case .dateDescending: workouts.sort(by: { $0.date > $1.date })
        case .dateAscending: workouts.sort(by: { $0.date < $1.date })
        case .caloriesDescending: workouts.sort(by: { $0.totalCalories > $1.totalCalories })
        case .durationDescending: workouts.sort(by: { $0.duration > $1.duration })
        case .defaultOrder: return
        }
    }
}

extension WorkoutListModel: WorkoutCreationModelDelegate {
    func save(workout: Workout) {
        workouts.append(workout)
        persistence?.save(workout: workout)
        delegate?.dataRefreshed()
    }
}
