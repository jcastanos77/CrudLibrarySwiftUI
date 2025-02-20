//
//  ApiService.swift
//  CrudLibrarySwiftUI
//
//  Created by JECASTAÑOSM on 19/02/25.
//

// APIService.swift
import Foundation
import Alamofire

class APIService {
    private let baseURL = "https://jsonplaceholder.typicode.com/todos"
    
    // Obtener todas las tareas
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        AF.request(baseURL, method: .get)
            .responseDecodable(of: [Task].self) { response in
            switch response.result {
            case .success(let tasks):
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Crear una nueva tarea
    func createTask(_ task: Task, completion: @escaping (Result<Task, Error>) -> Void) {
        AF.request(baseURL, method: .post, parameters: task, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: Task.self) { response in
                switch response.result {
                case .success(let task):
                    completion(.success(task))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // Actualizar una tarea
    func updateTask(_ task: Task, completion: @escaping (Result<Task, Error>) -> Void) {
        let url = "\(baseURL)/\(task.id)"
        AF.request(url, method: .put, parameters: task, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: Task.self) { response in
                switch response.result {
                case .success(let task):
                    completion(.success(task))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // Eliminar una tarea
    func deleteTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/\(task.id)"
        AF.request(url, method: .delete).response { response in
            if let error = response.error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
