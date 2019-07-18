import UIKit

final class WorkoutListTableViewCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    #warning("TODO: Add calories burned label to code & storyboard")
    @IBOutlet private weak var caloriesBurnedLabel: UILabel!
    
    private(set) var workout: Workout!
    
    func setup(with workout: Workout) {
        self.workout = workout
        
        nameLabel.text = workout.name
        dateLabel.text = workout.date.toString(format: .yearMonthDay)
        durationLabel.text = "\(workout.duration) minutes"
        caloriesBurnedLabel.text = "\(workout.totalCalories) calories"
    }
}
