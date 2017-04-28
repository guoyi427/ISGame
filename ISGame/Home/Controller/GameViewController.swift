//
//  GameViewController.swift
//  ISGame
//
//  Created by kokozu on 2017/4/26.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var room_id:String
    
    fileprivate let _textField = UITextField(frame: CGRect(x: 10, y: 80, width: UIScreen.main.bounds.width - 80, height: 30))
    fileprivate let _tableView = UITableView(frame: CGRect(x:0, y:110, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 110), style: .plain)
    
    fileprivate let _cellIdentifier = "gameCellID"
    fileprivate var _chatHistoryList:[[String:Any]] = []
    
    init(roomID:String) {
        room_id = roomID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        view.backgroundColor = UIColor.white
        title = "房间"+room_id
        
        
        _textField.placeholder = "输入内容"
        view.addSubview(_textField)
        
        let sendButton = UIButton(type: .custom)
        sendButton.frame = CGRect(x: UIScreen.main.bounds.width - 60, y: 80, width: 50, height: 30)
        sendButton.setTitle("发送", for: .normal)
        sendButton.backgroundColor = UIColor.green
        sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        view.addSubview(sendButton)
        
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: _cellIdentifier)
        view.addSubview(_tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SocketControl.instance.reciveGroupDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SocketControl.instance.outRoom(roomID: room_id)
    }
}

//MARK: Button
extension GameViewController {
    @objc fileprivate func sendButtonAction() {
        guard let content = _textField.text else {
            debugPrint("group message empty")
            return
        }
        
        if room_id.characters.count == 0 {
            debugPrint("roomid empty")
        }
        
        SocketControl.instance.sendGroupMessage(msg: content, roomID: room_id)
        _textField.text = ""
    }
}

//MARK: TableView Delegate & Datasource
extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: _cellIdentifier)!
        cell.selectionStyle = .none
        
        if _chatHistoryList.count > indexPath.row {
            let messageDic = _chatHistoryList[indexPath.row]
            if let message = messageDic["content"] as? String {
                cell.textLabel?.text = message
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _chatHistoryList.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _textField.resignFirstResponder()
    }
}

//MARK: SocketController Delegate
extension GameViewController: SocketControlReceiveGroup {
    func socketControlReceiveGroupMessage(messageDic: [String : Any]) {
        debugPrint(messageDic)
        _chatHistoryList.insert(messageDic, at: 0)
        _tableView.reloadData()
    }
}
