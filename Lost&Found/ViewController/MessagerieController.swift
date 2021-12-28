//
//  MessagerieController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 10/12/2021.
//

import Foundation
import SendBirdUIKit

import UIKit

class MessagerieController: SBUChannelListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rightBarButton = nil
        self.leftBarButton = nil
        
        let listQuery = SBDGroupChannel.createMyGroupChannelListQuery()
        
        listQuery?.userIdsExactFilter = [UserDefaults.standard.string(forKey: "_id")!]
        listQuery?.loadNextPage(completionHandler: { (groupChannels, error) in
         //  print("groupe channel : ",groupChannels, "erreur : ",error)
            guard error == nil else {return}
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       
    }
}
