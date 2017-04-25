//
//  PersonalCenterViewController.swift
//  ISGame
//
//  Created by 郭毅 on 2017/4/15.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import UIKit

class PersonalCenterViewController: UIViewController {
    
    fileprivate let _tableView = UITableView(frame: CGRect(x: 0, y: 100, width: 300, height: 300), style: .plain)
    fileprivate let _cellIdentifier = "userListCell"
    
    fileprivate var _userModelList:[SocketUserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        SocketControl.instance.connectHost()
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 10, y: 50, width: 100, height: 30)
        button.setTitle("user list", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: _cellIdentifier)
        _tableView.rowHeight = 40
        view.addSubview(_tableView)
    }
}

//MARK: Button Action
extension PersonalCenterViewController {
    @objc fileprivate func buttonAction() {
        SocketControl.instance.queryUserList { [unowned self] (userList) in
            debugPrint(userList)
            self._userModelList.removeAll()
            self._userModelList.append(contentsOf: userList)
            self._tableView.reloadData()
        }
    }
}

extension PersonalCenterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: _cellIdentifier)!
        cell.selectionStyle = .none
        if _userModelList.count > indexPath.row {
            let model = _userModelList[indexPath.row]
            cell.textLabel?.text = "name" + model.name + " uid" + model.uid
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _userModelList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
