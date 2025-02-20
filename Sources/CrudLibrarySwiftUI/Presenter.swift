//
//  Presenter.swift
//  CrudLibrarySwiftUI
//
//  Created by JECASTAÑOSM on 19/02/25.
//

// TaskListPresenter.swift
import Foundation
import Combine

protocol TaskListPresenterProtocol {
    var tasks: [Task] { get }
    func fetchTasks()
    func addTask()
    func updateTask(_ task: Task)
    func deleteTask(_ task: Task)
}

@available(iOS 13.0, *)
class TaskListPresenter: TaskListPresenterProtocol, ObservableObject {
    @Published var tasks: [Task] = []

    private var interactor: TaskInteractorProtocol
    
    init(interactor: TaskInteractorProtocol = TaskInteractor()) {
        self.interactor = interactor
        fetchTasks()
    }
    
    func fetchTasks() {
        interactor.fetchTasks { tasks in
            if let tasks = tasks {
                self.tasks = tasks
            }
        }
    }
    
    func addTask() {
        let newTask = Task(id: 0, title: "New Task", completed: true)
        interactor.addTask(newTask) { task in
            if let task = task {
                self.tasks.append(task)
            }
        }
    }
    
    func updateTask(_ task: Task) {
        var updatedTask = task
        updatedTask.title = "Updated: \(task.title)"
        interactor.updateTask(updatedTask) { task in
            if let task = task {
                if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
                    self.tasks[index] = task
                }
            }
        }
    }
    
    func deleteTask(_ task: Task) {
        interactor.deleteTask(task) { success in
            if success {
                self.tasks.removeAll { $0.id == task.id }
            }
        }
    }
}
