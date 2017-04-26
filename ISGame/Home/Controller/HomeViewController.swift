//
//  HomeViewController.swift
//  ISGame
//
//  Created by 郭毅 on 2017/4/15.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    var _roomList:[[String:Any]] = []
    let _cellIdentifier = "roomListCell"
    
    
    let _tableView = UITableView(frame: CGRect(x:0, y:140, width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 189), style: .plain)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.magenta
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 10, y: 100, width: 100, height: 40)
        button.backgroundColor = UIColor.yellow
        button.setTitle("creat room", for: .normal)
        button.addTarget(self, action: #selector(creatRoomAction), for: .touchUpInside)
        view.addSubview(button)
        
        let queryRoomList = UIButton(type: .custom)
        queryRoomList.frame = CGRect(x: 120, y: 100, width: 100, height: 40)
        queryRoomList.backgroundColor = UIColor.blue
        queryRoomList.setTitle("query room list", for: .normal)
        queryRoomList.addTarget(self, action: #selector(queryRoomListAction), for: .touchUpInside)
        view.addSubview(queryRoomList)
        
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: _cellIdentifier)
        view.addSubview(_tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
   
}

//MARK: Button Action
extension HomeViewController {
    func buttonAction() {

        let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "demo"))
        let urlString = "http://localhost:8080/upload"
        
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(imageData!, withName: "File", fileName: "demo.png", mimeType: "image/png")
        }, to: urlString) { (encodingResult) in
            switch encodingResult {
            case .failure(let error):
                debugPrint(error)
            case .success(request: let uploadRequest, streamingFromDisk: _, streamFileURL: _):
                uploadRequest.responseJSON(completionHandler: { (json) in
                    if let n_value = json.value {
                        debugPrint(n_value)
                    }
                })
            }
        }
    }
    
    func sendMessage() {
        SocketControl.instance.sendTextMessage(text: "嗯嗯", to: "999")
    }
    
    func creatRoomAction() {
        SocketControl.instance.creatRoom { [unowned self] (success) in
            if success {
                let vc = GameViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func queryRoomListAction() {
        SocketControl.instance.queryRoomList { [unowned self] (roomList) in
            self._roomList = roomList
            self._tableView.reloadData()
        }
    }
}

//MARK: TableView - Datasource & Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: _cellIdentifier)!
        if _roomList.count > indexPath.row {
            if let room_id = _roomList[indexPath.row]["room_id"] as? String {
                cell.textLabel?.text = room_id
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _roomList.count
    }
}
