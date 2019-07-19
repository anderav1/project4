import Foundation

protocol WorkoutCreationModelDelegate: class {
    func save(workout: Workout)
}

protocol WorkoutModelDisplayDelegate: class {
    func workoutEntryUpdated()
}

final class WorkoutCreationModel {
    let minimumStepperValue: Double = 2.0
    let maximumStepperValue: Double = 90.0
    
    let minCalorieBurnRate: Double = 1.0
    let maxCalorieBurnRate: Double = 1000.0
    
    private(set) var workout: Workout
    
    private var isEditing: Bool
    
    var titleText: String { return isEditing ? "Edit Workout" : "Add Workout" }
    var buttonText: String { return isEditing ? "Update" : "Add"}
    
    private weak var delegate: WorkoutCreationModelDelegate?
    //private weak var displayDelegate: WorkoutModelDisplayDelegate?
        
    init(workout: Workout, delegate: WorkoutCreationModelDelegate, /*displayDelegate: WorkoutModelDisplayDelegate,*/ isEditing: Bool) {
        self.workout = workout
        self.delegate = delegate
       // self.displayDelegate = displayDelegate
        self.isEditing = isEditing
    }
}

extension WorkoutCreationModel {
    func saveWorkout(name: String, date: Date, duration: Int, caloriesPerMin: Int) {
        var workout: Workout {
            guard self.isEditing else {
                // new workout
                return Workout(name: name, date: date, duration: duration, caloriesPerMin: caloriesPerMin)
            }
            // pre-existing workout
            return self.workout.copyWith(name: name, date: date, duration: duration, caloriesPerMin: caloriesPerMin)
        }
        
        delegate?.save(workout:
            Workout(
                id: workout.id,
                name: name.isEmpty ? workout.name : name,
                date: workout.date,
                duration: workout.duration,
                caloriesPerMin: workout.caloriesPerMin
            )
        )
    }
}
