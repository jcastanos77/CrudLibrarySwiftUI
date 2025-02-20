//
//  TaskListView.swift
//  CrudLibrarySwiftUI
//
//  Created by JECASTAÑOSM on 19/02/25.
//

import SwiftUI

@available(iOS 13.0, *)
struct TaskListView: View {
    @ObservedObject var presenter: TaskListPresenter
    
    var body: some View {
        NavigationView {
            List(presenter.tasks) { task in
                HStack {
                    VStack(alignment: .leading) {
                        Text(task.title).font(.headline)
                        Text(task.completed ? "Completed" : "Pending").font(.subheadline)
                    }
                    Spacer()
                    Button(action: {
                        presenter.updateTask(task)
                    }) {
                        Text(task.completed ? "Mark as Pending" : "Mark as Completed")
                            .foregroundColor(.blue)
                    }
                    Button(action: {
                        presenter.deleteTask(task)
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Tasks")
            .navigationBarItems(trailing: Button("Add Task") {
                presenter.addTask()
            })
        }
        .onAppear {
            presenter.fetchTasks()
        }
    }
}

@available(iOS 13.0.0, *)
struct TaskListView_Previews: PreviewProvider {
    
    static var previews: some View {
        TaskListView(presenter: TaskListPresenter())
    }
}
