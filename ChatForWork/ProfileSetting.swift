////
////  ProfileSetting.swift
////  ChatForWork
////
////  Created by DevOminext on 12/19/17.
////  Copyright © 2017 Nguyen Dinh Dung. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class ProfileSetting: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
//    let cellId = "cellId"
//    let height = UIScreen.main.bounds.height
//    let width = UIScreen.main.bounds.width
//    var titleArray = [String]()
//    var nameArray = [String]()
//    lazy var customNavBar = UIView()
//    lazy var cancelButton = UIButton()
//    lazy var titleLabel = UILabel()
//    lazy var saveButton = UIButton()
//     var inputTextField = UITextField()
//     var okButton = UIButton()
//    var infoTable = UITableView()
//    var user: User?
//    var row: Int?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        user = MyObject.instance().user
//        setupTitleAndName(user: user!)
//        setupCustomNavBar()
//        hideKeyboardWhenTappedAround(bool: true)
//
//        infoTable.dataSource = self
//        infoTable.delegate = self
//        infoTable.backgroundColor = UIColor(r: 235, g: 235, b: 235)
//        infoTable.register(ProfileSettingCustomCell.self, forCellReuseIdentifier: cellId)
//        setupKeyBoardObservers()
//    }
//
//    @objc private func handleDismiss() {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    @objc private func handleSaveInfo() {
//        let values = ["name": nameArray[0], "email": user?.email!, "profileImageUrl": user?.profileImageUrl!, "checkOnline": user?.checkOnline!, "backgroundImageUrl": user?.backgroundImageUrl!, "id": user?.id!, "lastTimeLoggin": user?.lastTimeLoggin!, "lastTimeLogout": user?.lastTimeLogout!, "isTypingCheck": "false", "chattingWith": "NoOne", "chatId": nameArray[1], "organization": nameArray[2], "team": nameArray[3], "jobTitle": nameArray[4], "address": nameArray[5], "url": nameArray[6], "workPhone": nameArray[8], "userExtension": nameArray[9], "mobile": nameArray[10]] as [String : Any]
//        let ref = Database.database().reference().child("user").child((user?.id)!)
//        ref.updateChildValues(values, withCompletionBlock: {
//            (error ,ref) in
//            if error != nil {
//                print(error!)
//                return
//            }
//        })
//
//        handleDismiss()
//
//    }
//
//    private func setupCustomNavBar() {
//        customNavBar.backgroundColor = UIColor(r: 5, g: 5, b: 5)
//        cancelButton.setTitle("Cancel", for: .normal)
//        cancelButton.setTitleColor(.white, for: .normal)
//        cancelButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
//
//        titleLabel.text = "Edit Profile"
//        titleLabel.textAlignment = .center
//        titleLabel.textColor = .white
//
//        saveButton.setTitle("Save", for: .normal)
//        saveButton.setTitleColor(.white, for: .normal)
//        saveButton.addTarget(self, action: #selector(handleSaveInfo), for: .touchUpInside)
//
//        view.addSubview(customNavBar)
//        view.addSubview(infoTable)
//        customNavBar.addSubview(cancelButton)
//        customNavBar.addSubview(titleLabel)
//        customNavBar.addSubview(saveButton)
//
//        customNavBar.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 64)
//        cancelButton.anchor(nil, left: self.view.leftAnchor, bottom: customNavBar.bottomAnchor, right: nil, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40)
//        titleLabel.anchor(nil, left: self.view.centerXAnchor, bottom: customNavBar.bottomAnchor, right: nil, topConstant: 0, leftConstant: -50, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 40)
//        saveButton.anchor(nil, left: nil, bottom: customNavBar.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 50, heightConstant: 40)
//        infoTable.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 64, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//    }
//
//    private func setupTitleAndName(user: User) {
//        titleArray = ["Name :","ChatWorkID :","Organization :", "Team :", "Job Title :", "Address :", "URL :", "Email :", "Work Phone :", "Extension :", "Mobile :"]
//        nameArray = [(user.name) ?? "", (user.chatId) ?? "", (user.organization) ?? "", (user.team) ?? "", (user.jobTitle) ?? "", (user.address) ?? "", (user.url) ?? "", (user.email) ?? "", (user.workPhone) ?? "", (user.userExtension) ?? "", (user.mobile) ?? ""]
//        MyObject.instance().array = nameArray
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 11
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileSettingCustomCell
//        cell.detailTitle.text = titleArray[indexPath.row]
//        cell.detailName.text = nameArray[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        inputTextField.placeholder = "Enter \(titleArray[indexPath.row])"
//        row = indexPath.row
//        showEditor()
//    }
//
//    func tableView(_ taleView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 55
//    }
//
//    func handleUpdate() {
//        nameArray[row!] = self.inputTextField.text!
//        infoTable.reloadData()
//    }
//
//    func showEditor() {
//        okButton.setTitle("OK", for: .normal)
//        okButton.setTitleColor(.white, for: .normal)
//        okButton.backgroundColor = .blue
//        okButton.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
//
//        inputTextField.backgroundColor = .white
//        inputTextField.tintColor = .black
//        view.addSubview(inputTextField)
//        view.addSubview(okButton)
//        inputTextField.anchor(view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
//        okButton.anchor(inputTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
////        inputTextField.frame = CGRect(x: 0, y: height, width: width, height: 50)
////        okButton.frame = CGRect(x: 0, y: height + 50, width: width, height: 50)
//
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
//            self.inputTextField.frame = CGRect(x: 0, y: self.height - 100, width: self.width, height: 50)
//            self.okButton.frame = CGRect(x: 0, y: self.height - 50, width: self.width, height: 50)
//        }, completion: nil)
//    }
//
//    func setupKeyBoardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillEnd), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//
//    func handleKeyboardWillShow(_ notification: Notification) {
//
//        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
//
//            self.inputTextField.frame = CGRect(x: 0, y: height - 100 - keyboardHeight, width: width, height: 50)
//            self.okButton.frame = CGRect(x: 0, y: height - 50 - keyboardHeight, width: width, height: 50)
//
//            UIView.animate(withDuration: keyboardDuration!, animations: {
//                self.view.layoutIfNeeded()
//            })
//        } }
//
//    func handleKeyboardWillEnd(_ notification: Notification) {
//
//        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
//        inputTextField.frame = CGRect(x: 0, y: height, width: width, height: 50)
//        okButton.frame = CGRect(x: 0, y: height, width: width, height: 50)
//        UIView.animate(withDuration: keyboardDuration!, animations: {
//            self.view.layoutIfNeeded()
//        })
//        okButton.removeFromSuperview()
//        inputTextField.removeFromSuperview()
//    }
//}
//
//class ProfileSettingCustomCell: UITableViewCell, UITextViewDelegate {
//    lazy var detailTitle = UILabel()
//    lazy var detailName = UILabel()
//    func setupViews() {
//        detailTitle.textAlignment = .left
//        detailTitle = detailTitle.setUpLabel(labelText: "", textColor: .darkText, size: 16)
//
//        detailName.textAlignment = .right
//        detailName.textColor = .lightGray
//        detailName.backgroundColor = .clear
//        detailName.font = UIFont.systemFont(ofSize: 16)
//
//        contentView.addSubview(detailTitle)
//        contentView.addSubview(detailName)
//
//        detailTitle.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 15, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 20)
//        detailName.anchor(contentView.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 200, heightConstant: 20)
//    }
//
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//
//
