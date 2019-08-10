import UIKit

final class WorkoutListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var sortButton: UIBarButtonItem!
    
    private var model: WorkoutListModel!
}

extension WorkoutListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = WorkoutListModel(delegate: self)
        
        // configure sort button
        sortButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(sortButtonClicked))
        navigationItem.leftBarButtonItem = sortButton
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let creationViewController = segue.destination as? WorkoutCreationViewController {
            let workout: Workout = sender as? Workout ?? .defaultWorkout
           
            var workoutDoesExist: Bool
            if sender is Workout {
                workoutDoesExist = true
            } else {
                workoutDoesExist = false
            }
            
            let workoutCreationModel = WorkoutCreationModel(workout: workout, delegate: model, isEditing: workoutDoesExist)
            creationViewController.setup(model: workoutCreationModel)
        }
    }
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
    
    func clearList() {
        model.clear()
    }
}

extension WorkoutListViewController {
    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        let clearAlert = UIAlertController(title: "Clear workout list", message: "Are you sure you want to delete all workouts?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in self.clearList() }
        let noAction = UIAlertAction(title: "No", style: .cancel)
        
        clearAlert.addAction(yesAction)
        clearAlert.addAction(noAction)
        
        self.present(clearAlert, animated: true, completion: nil)
    }
}

extension WorkoutListViewController {
    @objc func sortButtonClicked() {
        let sortAlertController = UIAlertController(title: "Sort workouts by", message: nil, preferredStyle: .alert)
        
        // set up & add an action for each sort mode
        SortBy.allCases.forEach { sortMode in
            let sortAction = UIAlertAction(title: sortMode.name, style: .default) { (action) -> Void in
                self.model.sortList(by: sortMode)
            }
            sortAlertController.addAction(sortAction)
        }
        
        // add cancel action
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        sortAlertController.addAction(cancelButton)
        
        // display the alert controller
        self.present(sortAlertController, animated: true, completion: nil)
    }
}
