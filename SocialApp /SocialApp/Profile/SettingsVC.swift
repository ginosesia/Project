//
//  SettingsVC.swift
//  SocialApp
//
//  Created by Gino Sesia on 03/09/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

import Firebase
import UIKit



class SettingsVC: UIViewController, UITableViewDelegate  {
  
    
    //MARK: - Properties
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!

    //MARK: - Handlers
    
        
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
                
        tableView.separatorColor = .clear

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        switch section {
            case .Social: return SocialOptions.allCases.count
            case .Communications: return CommunicationsOptions.allCases.count
            case .Account: return AccountOptions.allCases.count
        }

    }
        
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black

        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = UIColor(red: 0/255, green: 171/255, blue: 154/255, alpha: 1)
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        title.text = SettingsSection(rawValue: section)?.description

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        switch section {
            case .Social:
                print(SocialOptions(rawValue: indexPath.row)?.description as Any)
            case .Communications:
                print(CommunicationsOptions(rawValue: indexPath.row)?.description as Any)
            case .Account:
                print(AccountOptions(rawValue: indexPath.row)?.description as Any)
            
        }
   
    }
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }


    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.backgroundColor = .black
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 130)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()
    }
    
    func configureUI() {
        configureTableView()
//        navigationController?.navigationBar.prefersLargeTitles = true

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
            navigationItem.title = "Settings"
    }

}


