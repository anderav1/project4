import Foundation

struct Workout: Codable {
    let id: UUID
    let name: String
    let date: Date
    let duration: Int
    let caloriesPerMin: Int
    
    var totalCalories: Int {
        return duration * caloriesPerMin
    }
    
    // initialize a new workout
    init(name: String, date: Date, duration: Int, caloriesPerMin: Int) {
        // create a new id
        id = UUID()
        
        self.name = name
        self.date = date
        self.duration = duration
        self.caloriesPerMin = caloriesPerMin
    }
    
    // create a copy of an existing workout
    init(id: UUID, name: String, date: Date, duration: Int, caloriesPerMin: Int) {
        // copy the old id
        self.id = id
        
        self.name = name
        self.date = date
        self.duration = duration
        self.caloriesPerMin = caloriesPerMin
    }
        
    func copyWith(name: String, date: Date, duration: Int, caloriesPerMin: Int) -> Workout {
        return Workout(id: self.id, name: name, date: date, duration: duration, caloriesPerMin: caloriesPerMin)
    }
    
}

extension Workout {
    static var defaultWorkout: Workout {
        return Workout(id: UUID(), name: "No Name", date: Date(), duration: 10, caloriesPerMin: 1)
    }
}
