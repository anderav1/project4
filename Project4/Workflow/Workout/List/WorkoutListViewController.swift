import UIKit

final class WorkoutListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var sortPicker: UIPickerView!
    
    private var model: WorkoutListModel!
    
    let sortModes = ["Sort by...", "Date (descending)", "Date (ascending)", "Calories (descending)", "Duration (descending)"]
}

extension WorkoutListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = WorkoutListModel(delegate: self)
        sortPicker.dataSource = self
        sortPicker.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let creationViewController = segue.destination as? WorkoutCreationViewController {
            let workout: Workout = sender as? Workout ?? .defaultWorkout
            let workoutCreationModel = WorkoutCreationModel(workout: workout, delegate: model)
            creationViewController.setup(model: workoutCreationModel)
        }
    }
    
    #warning("TODO: Utilize WorkoutListModel sorting functions to sort the workout list")
    // sortList(by:)
    
}

extension WorkoutListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as! WorkoutListTableViewCell
        cell.setup(with: model.workout(atIndex: indexPath.row)!)
        
        return cell
    }
}

extension WorkoutListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return model.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! WorkoutListTableViewCell
        
        performSegue(withIdentifier: "WorkoutCreation", sender: cell.workout)
    }
}

extension WorkoutListViewController: WorkoutListModelDelegate {
    func dataRefreshed() {
        tableView.reloadData()
    }
}

#warning("TODO: Implement UIPickerView functionality for sort picker")
extension WorkoutListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortModes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortModes[row]
    }
    
    #warning("TODO: After user changes sort mode, table view should refresh to reflect the new mode")
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sortSelection: String = sortModes[row]
        SortBy.allCases.forEach {
            if $0.rawValue == sortSelection {
                model.sortList(by: $0)
                tableView.reloadData()
            }
        }
    }
}
