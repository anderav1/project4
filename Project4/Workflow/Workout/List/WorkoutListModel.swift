import Foundation
import struct UIKit.CGFloat

protocol WorkoutListModelDelegate: class {
    func dataRefreshed()
    func clearList()
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

enum SortBy: Int, CaseIterable {
    case dateDescending = 0, dateAscending, caloriesDescending, durationDescending, defaultOrder
    
    var name: String {
        switch self {
        case .dateDescending: return "Date (descending)"
        case .dateAscending: return "Date (ascending)"
        case .caloriesDescending: return "Calories (descending)"
        case .durationDescending: return "Duration (descending)"
        case .defaultOrder: return "Sort by..."
        }
    }
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
        delegate?.dataRefreshed()
    }
}

extension WorkoutListModel: WorkoutCreationModelDelegate {
    func save(workout: Workout) {
        // check for duplicate ids & replace if applicable
        if let existingWorkoutIndex = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[existingWorkoutIndex] = workout
        } else {
            workouts.append(workout)
        }
        
        persistence?.save(workout: workout)
        delegate?.dataRefreshed()
    }
}

extension WorkoutListModel {
    // deletes all workouts in the list
    func clear() {
        persistence?.clearWorkoutList()
        workouts = []
        delegate?.dataRefreshed()
    }
}
