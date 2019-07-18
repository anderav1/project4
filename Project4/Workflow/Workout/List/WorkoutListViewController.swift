import UIKit

final class WorkoutListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    private var model: WorkoutListModel!
}

extension WorkoutListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = WorkoutListModel(delegate: self)
        
        //sortButton.action = #selector(showAlert)
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

#warning("TODO: Implement UIAlertController functionality for sort picker")
extension WorkoutListViewController {
    @objc func showAlert(_ sender: AnyObject) {
        let sortAlertController = UIAlertController(title: "Sort workouts", message: "by:", preferredStyle: .actionSheet)
        
        // set up sorting actions
        var sortAlertButtons = [UIAlertAction]()
        for index in 0...3 {
            if let sortMode = SortBy.init(rawValue: index) {
                sortAlertButtons[index] = UIAlertAction(title: sortMode.name, style: .default) { (action) -> Void in
                    self.model.sortList(by: sortMode)
                    self.dataRefreshed()
                }
                sortAlertController.addAction(sortAlertButtons[0])
            }
        }
        
        // add cancel action
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            // close the alert controller
            sortAlertController.dismiss(animated: true, completion: nil)
        }
        sortAlertController.addAction(cancelButton)
        
        sortAlertController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        sortAlertController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
        sortAlertController.isModalInPopover = true
        
        // display the alert controller
        self.present(sortAlertController, animated: true, completion: nil)
    }
}
