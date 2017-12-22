//
//  AddTaskController.swift
//  ChatForWork
//
//  Created by DevOminext on 12/20/17.
//  Copyright © 2017 Nguyen Dinh Dung. All rights reserved.
//

import UIKit

class AddTaskController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, DateViewDelegate, ChatPartnerDelegate {
    lazy var customNavBar = UIView()
    lazy var cancelButton = UIButton()
    lazy var navTitleView = UILabel()
    lazy var doneButton = UIButton()
    lazy var textContainer = UITextView()
    var dueDateLabel = UILabel()
    var chatPartnerName = UILabel()
    var myTableView = UITableView()
    let cellId = "cellId"
    var leftViewArray = ["Chat", "Due Date", "Assignee"]
    var taskDate: String = "ABC"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        self.myTableView.keyboardDismissMode = .interactive
        
        self.view.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.isScrollEnabled = false
        myTableView.register(myCustomCell.self, forCellReuseIdentifier: cellId)
//        setupViews()
        setupKeyBoardObservers()
    }
    
    func setDateText(date: String) {
        self.taskDate = date
        dueDateLabel.text = date
        self.view.reloadInputViews()
    }
    
    func getChatPartnerInfo(name: String) {
        self.chatPartnerName.text = name
        self.view.reloadInputViews()
    }
    
    func setupKeyBoardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillEnd), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
            textContainerBottomConstraint?.constant = -(keyboardHeight) - 160
            UIView.animate(withDuration: keyboardDuration!, animations: {
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func handleKeyboardWillEnd(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        textContainerBottomConstraint?.constant = -160
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
        self.navigationController?.isNavigationBarHidden = true
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! myCustomCell
        cell.leftView.text = leftViewArray[indexPath.row]
        cell.leftView.textColor = .darkText
        cell.leftView.textAlignment = .left
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let message = MessageController()
            message.check = 1
            message.delegate = self
            self.navigationController?.pushViewController(message, animated: true)
        } else if indexPath.row == 1 {
        let dateView = DateViewController()
        dateView.delegate = self
            self.navigationController?.pushViewController(dateView, animated: true) 
        } else if indexPath.row == 2 {
            return
        }
    }
    
    func showMessageController(check: Int) {
        let message = MessageController()
        message.check = check
        self.navigationController?.pushViewController(message, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    var textContainerBottomConstraint: NSLayoutConstraint?
    
    func setupViews() {
        customNavBar.backgroundColor = UIColor(r: 5, g: 5, b: 5)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        
        navTitleView.text = "Add Task"
        navTitleView.textColor = .white
        navTitleView.textAlignment = .center
        
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.setTitle("Done", for: .normal)
        
        textContainer.backgroundColor = .white
        textContainer.translatesAutoresizingMaskIntoConstraints = false
        textContainer.textContainerInset = UIEdgeInsetsMake(12, 12, 12, 12)
        textContainer.text = "Task decription"
        textContainer.textColor = .lightGray
        
        chatPartnerName.textColor = .blue
        chatPartnerName.textAlignment = .right
        chatPartnerName.text = MyObject.instance().userNameFromMessage
        
        dueDateLabel.textColor = .blue
        dueDateLabel.textAlignment = .right
        dueDateLabel.text = MyObject.instance().addTaskText1
        
        view.addSubview(customNavBar)
        customNavBar.addSubview(cancelButton)
        customNavBar.addSubview(navTitleView)
        customNavBar.addSubview(doneButton)
        
        view.addSubview(textContainer)
        view.addSubview(myTableView)
        view.addSubview(chatPartnerName)
        view.addSubview(dueDateLabel)
        
        customNavBar.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 64)
        cancelButton.anchor(nil, left: self.view.leftAnchor, bottom: customNavBar.bottomAnchor, right: nil, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40)
        navTitleView.anchor(nil, left: self.view.centerXAnchor, bottom: customNavBar.bottomAnchor, right: nil, topConstant: 0, leftConstant: -50, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 40)
        doneButton.anchor(nil, left: nil, bottom: customNavBar.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 50, heightConstant: 40)
        
        textContainer.topAnchor.constraint(equalTo: self.customNavBar.bottomAnchor, constant: 30).isActive = true
        textContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        textContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        textContainerBottomConstraint = textContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -160)
        textContainerBottomConstraint?.isActive = true

        myTableView.anchor(textContainer.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 120)
        
        chatPartnerName.anchor(textContainer.bottomAnchor, left: nil, bottom: nil, right: textContainer.rightAnchor, topConstant: 32, leftConstant: 0, bottomConstant: 0, rightConstant: 50, widthConstant: 150, heightConstant: 16)
        
        dueDateLabel.anchor(textContainer.bottomAnchor, left: nil, bottom: nil, right: textContainer.rightAnchor, topConstant: 72, leftConstant: 0, bottomConstant: 0, rightConstant: 50, widthConstant: 150, heightConstant: 16)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  textContainer.textColor == UIColor.lightGray {
            textContainer.selectedTextRange = textContainer.textRange(from: textContainer.beginningOfDocument, to: textContainer.beginningOfDocument)
            textContainer.text = "Task decription"
            doneButton.isEnabled = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textContainer.text as NSString?
        let updatedText = currentText?.replacingCharacters(in: range as NSRange, with: text)
        
        if (updatedText?.isEmpty)! {
            doneButton.isEnabled = false
            textContainer.text = "Task decription"
            textContainer.textColor = UIColor.lightGray
            textContainer.selectedTextRange = textContainer.textRange(from: textContainer.beginningOfDocument, to: textContainer.beginningOfDocument)
            return true
        }
            
        else if textContainer.textColor == UIColor.lightGray && !text.isEmpty {
            textContainer.text = nil
            textContainer.textColor = UIColor.darkText
            doneButton.isEnabled = true
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textContainer.text.isEmpty {
            textContainer.text = "Task decription"
            textContainer.textColor = UIColor.lightGray
            doneButton.isEnabled = false
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textContainer.textColor == UIColor.lightGray {
                textContainer.selectedTextRange = textContainer.textRange(from: textView.beginningOfDocument, to: textContainer.beginningOfDocument)
                textContainer.text = "Task decription"
                doneButton.isEnabled = false
            }
        }
    }

}

class myCustomCell: UITableViewCell {
    lazy var leftView = UILabel()
    lazy var rightLogo = UIImageView()
    lazy var rightImageView1 = UIImageView()
    lazy var rightImageView2 = UIImageView()
    lazy var rightImageView3 = UIImageView()
    lazy var rightImageView4 = UIImageView()
    lazy var numberOfUserLabel = UILabel()
    
    func setupViews() {
        leftView.textColor = .darkText
        
        rightImageView1.layer.cornerRadius = 18
        rightImageView1.layer.masksToBounds = true
        rightImageView2.layer.cornerRadius = 18
        rightImageView2.layer.masksToBounds = true
        rightImageView3.layer.cornerRadius = 18
        rightImageView3.layer.masksToBounds = true
        rightImageView4.layer.cornerRadius = 18
        rightImageView4.layer.masksToBounds = true
        
        contentView.addSubview(leftView)
        contentView.addSubview(rightLogo)
        contentView.addSubview(rightImageView1)
        contentView.addSubview(rightImageView2)
        contentView.addSubview(rightImageView3)
        contentView.addSubview(rightImageView4)
        
        leftView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 20)
        rightLogo.anchor(contentView.topAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 30, heightConstant: 16)
        rightImageView1.anchor(contentView.topAnchor, left: nil, bottom: contentView.bottomAnchor, right: rightLogo.leftAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 2, rightConstant: 0, widthConstant: 36, heightConstant: 36)
        rightImageView2.anchor(contentView.topAnchor, left: nil, bottom: contentView.bottomAnchor, right: rightImageView1.leftAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 2, rightConstant: 4, widthConstant: 38, heightConstant: 38)
        rightImageView3.anchor(contentView.topAnchor, left: nil, bottom: contentView.bottomAnchor, right: rightImageView2.leftAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 2, rightConstant: 4, widthConstant: 38, heightConstant: 38)
        rightImageView4.anchor(contentView.topAnchor, left: nil, bottom: contentView.bottomAnchor, right: rightImageView3.leftAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 2, rightConstant: 4, widthConstant: 38, heightConstant: 38)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
