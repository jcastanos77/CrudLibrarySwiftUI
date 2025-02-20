
// TaskInteractor.swift
import Foundation

protocol TaskInteractorProtocol {
    func fetchTasks(completion: @escaping ([Task]?) -> Void)
    func addTask(_ task: Task, completion: @escaping (Task?) -> Void)
    func updateTask(_ task: Task, completion: @escaping (Task?) -> Void)
    func deleteTask(_ task: Task, completion: @escaping (Bool) -> Void)
}

class TaskInteractor: TaskInteractorProtocol {
    private let apiService = APIService()
    
    func fetchTasks(completion: @escaping ([Task]?) -> Void) {
        apiService.fetchTasks { result in
            switch result {
            case .success(let tasks):
                completion(tasks)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func addTask(_ task: Task, completion: @escaping (Task?) -> Void) {
        apiService.createTask(task) { result in
            switch result {
            case .success(let task):
                completion(task)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func updateTask(_ task: Task, completion: @escaping (Task?) -> Void) {
        apiService.updateTask(task) { result in
            switch result {
            case .success(let task):
                completion(task)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func deleteTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        apiService.deleteTask(task) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}
