//
//  MainViewController.swift
//  Students
//
//  Created by Michael Stoffer on 5/21/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - @IBOutlets and Variables
    @IBOutlet var sortSegmentedControl: UISegmentedControl!
    @IBOutlet var filterSegmentedControl: UISegmentedControl!

    private let studentController = StudentController()
    private var studentsTableViewController: StudentTableViewController! {
        didSet {
            self.updateDataSource()
        }
    }

    private var students: [Student] = [] {
        didSet {
            self.updateDataSource()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.studentController.loadFromPersistentStore { (students, error) in
            if let error = error {
                print("There was an error loading students \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.students = students ?? []
            }
        }
    }

    // MARK: - @IBActions and Methods
    @IBAction func sort(_ sender: UISegmentedControl) {
        self.updateDataSource()
    }

    @IBAction func filter(_ sender: UISegmentedControl) {
        self.updateDataSource()
    }
    
    private func updateDataSource() {
        var sortedAndFilteredStudents: [Student]
        
        switch self.filterSegmentedControl.selectedSegmentIndex {
            case 1: // filter for iOS
                sortedAndFilteredStudents = self.students.filter({ $0.course == "iOS" })
            case 2: // filter for Web
                sortedAndFilteredStudents = self.students.filter({ $0.course == "Web" })
            case 3: // filter for UX
                sortedAndFilteredStudents = self.students.filter({ $0.course == "UX" })
            default:
                sortedAndFilteredStudents = self.students
        }
        
        if self.sortSegmentedControl.selectedSegmentIndex == 0 {
            sortedAndFilteredStudents = sortedAndFilteredStudents.sorted(by: { $0.firstName < $1.firstName })
        } else {
            sortedAndFilteredStudents = sortedAndFilteredStudents.sorted(by: { $0.lastName < $1.lastName })
        }
        
        self.studentsTableViewController.students = sortedAndFilteredStudents
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StudentListEmbedSegue" {
            self.studentsTableViewController = segue.destination as? StudentTableViewController
        }
    }

}
