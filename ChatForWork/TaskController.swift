//
//  TaskController.swift
//  ChatForWork
//
//  Created by DevOminext on 12/19/17.
//  Copyright © 2017 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import LBTAComponents

class TaskController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let taskSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.blue
        sc.selectedSegmentIndex = 0
        sc.layer.cornerRadius = 5
        sc.layer.masksToBounds = true
        sc.backgroundColor = .white
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    var taskSegmentContainer = UIView()
    let myTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self as? UITableViewDataSource
        tableView.delegate = self as? UITableViewDelegate
        tableView.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var delegate: MainViewController?
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        setupViews()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc private func handleLoginRegisterChange() {
        if taskSegmentedControl.selectedSegmentIndex == 0 {
            
        } else {
            
        }
    }
    
    func handleAddTask() {
        let addTask = AddTaskController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //show window
        appDelegate.window?.rootViewController = addTask

//        let addTask = MessageController()
//        self.present(addTask, animated: true, completion: nil)
        }
    
    func setupViews(){
        taskSegmentContainer.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        taskSegmentContainer.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(taskSegmentContainer)
        taskSegmentContainer.addSubview(taskSegmentedControl)
        view.addSubview(myTableView)
        
        taskSegmentContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        taskSegmentContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        taskSegmentContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        taskSegmentContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        taskSegmentedControl.topAnchor.constraint(equalTo: taskSegmentContainer.topAnchor, constant: 5).isActive = true
        taskSegmentedControl.bottomAnchor.constraint(equalTo: taskSegmentContainer.bottomAnchor, constant: -5).isActive = true
        taskSegmentedControl.leftAnchor.constraint(equalTo: taskSegmentContainer.leftAnchor, constant: 40).isActive = true
        taskSegmentedControl.rightAnchor.constraint(equalTo: taskSegmentContainer.rightAnchor, constant: -40).isActive = true
        
        myTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 114).isActive = true
        myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        myTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
    }
    
}

