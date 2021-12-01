//
//  OptionsController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 29/11/2021.
//

import Foundation
import UIKit

class OptionsController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let tableau = ["Securite","Modifier Profil","Theme"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableau.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option",for: indexPath)
        let cv = cell.contentView
        let button = cv.viewWithTag(10) as! UIButton
        button.setTitle(tableau[indexPath.row], for: .normal)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableViewOptions: UITableView!
    @IBAction func securityButton(_ sender: Any) {
    }
    @IBAction func themeButton(_ sender: Any) {
    }
}
