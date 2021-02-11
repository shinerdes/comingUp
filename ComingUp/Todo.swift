//
//  List.swift
//  AdvancedToDoApp
//
//  Created by 김영석 on 2020/11/08.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation


struct Todo: Codable, Equatable {
    
    let id: Int
    var title: String
    var content: String
    var date: String
    var imageHead: String
    var favorite: Bool
    
    var createDate: String
    
  
    
    
    mutating func update(title: String, content: String, date: String, imageHead: String, favorite: Bool) {
        // [x] TODO: update 로직 추가
        self.title = title
        self.content = content
        self.date = date
        self.imageHead = imageHead
        self.favorite = favorite
    }
    
    
    
}

class TodoManager {
    
    static let shared = TodoManager()
    
    static var lastId: Int = 0
    
    var todos: [Todo] = []
    
    func createTodo(title: String, content: String, date: String, imageHead: String, createDate: String) -> Todo {
        // [x] TODO: create로직 추가
        let nextId = TodoManager.lastId + 1
        TodoManager.lastId = nextId
        return Todo(id: nextId, title: title, content: content, date: date, imageHead: imageHead, favorite: false, createDate: createDate)
    
    }
    
    func addTodo(_ todo: Todo) {
        // [x] TODO: add로직 추가
        todos.append(todo)
        saveTodo()
    }
    
    func deleteTodo(_ todo: Todo) {
        // [x] TODO: delete 로직 추가
        todos = todos.filter { $0.id != todo.id }
//        if let index = todos.firstIndex(of: todo) {
//            todos.remove(at: index)
//        }
        saveTodo()
    }
    
    func updateTodo(_ todo: Todo) {
        // [x] TODO: updatee 로직 추가
        
        todos[todo.id].update(title: todo.title, content: todo.content, date: todo.date, imageHead: todo.imageHead, favorite: false)
        saveTodo()
    }
    
    func saveTodo() {
        Storage.store(todos, to: .documents, as: "todos.json")
    }
    
    func retrieveTodo() {
        todos = Storage.retrive("todos.json", from: .documents, as: [Todo].self) ?? []
        
        let lastId = todos.last?.id ?? 0
        TodoManager.lastId = lastId
    }
}

class TodoViewModel {
    
//    enum Section: Int, CaseIterable {
//        case today
//        case upcoming
//
//        var title: String {
//            switch self {
//            case .today: return "Today"
//            default: return "Upcoming"
//            }
//        }
//    }
    
    private let manager = TodoManager.shared
    
    var todos: [Todo] {
        return manager.todos
    }
    
//    var todayTodos: [Todo] {
//        return todos.filter { $0.isToday == true }
//    }
//
//    var upcompingTodos: [Todo] {
//        return todos.filter { $0.isToday == false }
//    }
    
//    var numOfSection: Int {
//        return Section.allCases.count
//    }
    
    func addTodo(_ todo: Todo) {
        manager.addTodo(todo)
    }
    
    func deleteTodo(_ todo: Todo) {
        manager.deleteTodo(todo)
    }
    
    func updateTodo(_ todo: Todo) {
        manager.updateTodo(todo)
    }
    
    func loadTasks() {
        manager.retrieveTodo()
    }
}

