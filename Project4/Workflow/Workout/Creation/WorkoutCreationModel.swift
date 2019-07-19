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
    
    #warning("TODO: implement min and max calorie burn rates in stepper")
    let minCalorieBurnRate: Double = 1.0
    let maxCalorieBurnRate: Double = 1000.0
    
    private(set) var workout: Workout?
    
    private var isEditing: Bool { return workout != nil }
    var titleText: String { return isEditing ? "Edit Workout" : "Add Workout" }
    var buttonText: String { return isEditing ? "Update" : "Add"}
    
    private weak var delegate: WorkoutCreationModelDelegate?
    private weak var displayDelegate: WorkoutModelDisplayDelegate?
        
    init(workout: Workout, delegate: WorkoutCreationModelDelegate, displayDelegate: WorkoutModelDisplayDelegate) {
        self.workout = workout
        self.delegate = delegate
        self.displayDelegate = displayDelegate
    }
}

extension WorkoutCreationModel {
    func saveWorkout(name: String, date: Date, duration: Int, caloriesPerMin: Int) {
        var workout: Workout {
            guard let workout = self.workout else {
                // new workout
                return Workout(id: UUID(), name: name, date: date, duration: duration, caloriesPerMin: caloriesPerMin)
            }
            // pre-existing workout
            return workout.copyWith(name: name, date: date, duration: duration, caloriesPerMin: caloriesPerMin)
        }
        
        delegate?.save(workout:
            Workout(
                id: workout.id,
                name: name.isEmpty ? workout.name : name,
                date: date,
                duration: duration,
                caloriesPerMin: caloriesPerMin
            )
        )
    }
}
