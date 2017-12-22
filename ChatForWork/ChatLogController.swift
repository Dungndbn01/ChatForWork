//
//  ChatLogController.swift
//  ChatForWork
//
//  Created by Nguyen Dinh Dung on 2017/12/17.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit

class ChatLogController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    weak var backButton = UIButton()
    weak var chatInformationButton = UIButton()
    
    lazy var inputContainerView = UIView()
    lazy var inputTextView = UITextView()
    lazy var showOptionsButton = UIButton()
    lazy var showEmojiButton = UIButton()
    lazy var separatorLine = UIView()
    lazy var showKeyBoardButton = UIButton()
    lazy var showToUserButton = UIButton()
    lazy var sendButton = UIButton()
    var inputContainerBottomAnchor: NSLayoutConstraint?
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    
    lazy var optionsContainer = UIView()
    lazy var upperStackView = UIStackView()
    lazy var bottomStackView = UIStackView()
    lazy var taskButton = UIButton()
    lazy var cameraButton = UIButton()
    lazy var cameraRollButton = UIButton()
    lazy var voiceMessagesButton = UIButton()
    lazy var locationButton = UIButton()
    lazy var chooseFileButton = UIButton()
    
    var chatLogTableView = UITableView(frame: .zero, style: .grouped)
    let cellId = "cellId"
    let headerId = "headerId"
    var messages = [Message]()
    var messagesInSection = [[Message]]()
    var dateStrings = [String]()
    var textForHeaders = [String]()
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    var group: Group? {
        didSet {
            navigationItem.title = group?.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        observeUserMessage()
        inputTextView.delegate = self
        chatLogTableView.dataSource = self
        chatLogTableView.delegate = self
        chatLogTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        chatLogTableView.backgroundColor = UIColor.white
        chatLogTableView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
        chatLogTableView.tableFooterView = UIView(frame: CGRect.zero)
        chatLogTableView.sectionFooterHeight = 0.0
        chatLogTableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        chatLogTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerId)
        UserDefaults.standard.setValue(user?.id, forKey: "UserID")
        UserDefaults.standard.set(group?.id, forKey: "GroupID")
        hideKeyboardWhenTappedAround(bool: true)
        setupNavBar()
        setupInputContainerView()
        setupKeyBoardObservers()
        setupButtonsProperties()
        self.view.backgroundColor = .clear
    }
    
    func setupInputTextView() {
        inputContainerView.addSubview(inputTextView)
        inputContainerView.addSubview(showEmojiButton)
        inputContainerView.addSubview(showOptionsButton)

        inputTextView.anchor(inputContainerView.topAnchor, left: inputContainerView.leftAnchor, bottom: nil, right: inputContainerView.rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 112, widthConstant: 0, heightConstant: 34)
        showEmojiButton.anchor(inputContainerView.topAnchor, left: nil, bottom: nil, right: inputContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        showOptionsButton.anchor(inputContainerView.topAnchor, left: nil, bottom: nil, right: showEmojiButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
    }
    
    func setupInputContainerView() {
        inputContainerView.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        separatorLine.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        
        inputTextView.layer.cornerRadius = 8
        inputTextView.layer.masksToBounds = true
        inputTextView.backgroundColor = .green
        inputTextView.font = UIFont.systemFont(ofSize: 14)
        inputTextView.text = "Type a message..."
        inputTextView.isEditable = true
        inputTextView.textColor = UIColor.lightGray
        inputTextView.textContainerInset = UIEdgeInsetsMake(7, 0, 7, 0)
        inputTextView.scrollsToTop = true
        inputTextView.isScrollEnabled = true
        inputTextView.addObserver(self, forKeyPath: "contentSize", options:[ NSKeyValueObservingOptions.old , NSKeyValueObservingOptions.new], context: nil)
        
        showEmojiButton.setImage(UIImage(named: "SmileICO")?.withRenderingMode(.alwaysTemplate), for: .normal)
        showEmojiButton.tintColor = .black
        showEmojiButton.addTarget(self, action: #selector(handleShowEmoji), for: .touchUpInside)
        showOptionsButton.setImage(UIImage(named: "AddICO")?.withRenderingMode(.alwaysTemplate), for: .normal)
        showOptionsButton.tintColor = .black
        showOptionsButton.addTarget(self, action: #selector(handleShowOptions), for: .touchUpInside)
        
        showKeyBoardButton.setTitle("Aa", for: .normal)
        showKeyBoardButton.setTitleColor(.black, for: .normal)
        showKeyBoardButton.addTarget(self, action: #selector(handleShowKeyboard), for: .touchUpInside)
        
        showToUserButton.setTitle("TO", for: .normal)
        showToUserButton.setTitleColor(.black, for: .normal)
        showToUserButton.addTarget(self, action: #selector(handleShowToUser), for: .touchUpInside)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.lightGray, for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        chatLogTableView.isScrollEnabled = true
        
        view.addSubview(inputContainerView)
        view.addSubview(separatorLine)
        view.addSubview(chatLogTableView)
        
        inputContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        inputContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        inputContainerBottomAnchor = inputContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50)
        inputContainerBottomAnchor?.isActive = true
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 100)
        inputContainerViewHeightAnchor?.isActive = true

        separatorLine.anchor(nil, left: self.view.leftAnchor, bottom: inputContainerView.topAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        chatLogTableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: separatorLine.topAnchor, right: view.rightAnchor, topConstant: 64, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        setupInputTextView()
    }
    
    func handleShowKeyboard() {
        showKeyBoardButton.setTitleColor(.blue, for: .normal)
        showEmojiButton.tintColor = .black
        showToUserButton.setTitleColor(.black, for: .normal)
        showOptionsButton.tintColor = .black
    }
    
    func handleShowToUser() {
        showKeyBoardButton.setTitleColor(.black, for: .normal)
        showEmojiButton.tintColor = .black
        showToUserButton.setTitleColor(.blue, for: .normal)
        showOptionsButton.tintColor = .black

    }
    
    func handleSend() {
//            if let uid = Auth.auth().currentUser?.uid {
//                let typingCheckRef = Database.database().reference(withPath: "user/\(uid)/isTypingCheck")
//                typingCheckRef.setValue("false")
//                observeUserTypingChange(value: 1)
//            }
            
            if inputTextView.text != "" {
                var string: String! = inputTextView.text!
                while string[string.index(before: string.endIndex)] == " " && string != " "{
                    string.remove(at: string.index(before: string.endIndex))
                }
                inputTextView.text = string }
            
            if inputTextView.text == " " {
                inputTextView.text = "Type a message..."
                inputTextView.textColor = UIColor.lightGray
                
                inputTextView.selectedTextRange = inputTextView.textRange(from: inputTextView.beginningOfDocument, to: inputTextView.beginningOfDocument) }
            
            if inputTextView.text != "" && inputTextView.text != " " && inputTextView.textColor != UIColor.lightGray {
                let properties: [String: AnyObject] = ["text": inputTextView.text! as AnyObject]
                sendMessageWithProperties(properties: properties)
                //            inputTextView.text = ""
                
                inputTextView.text = "Type a message..."
                inputTextView.textColor = UIColor.lightGray
                
                inputTextView.selectedTextRange = inputTextView.textRange(from: inputTextView.beginningOfDocument, to: inputTextView.beginningOfDocument)
            }
            inputTextView.textColor = UIColor.lightGray
    }
    
    func handleShowEmoji() {
        showKeyBoardButton.setTitleColor(.black, for: .normal)
        showEmojiButton.tintColor = .blue
        showToUserButton.setTitleColor(.black, for: .normal)
        showOptionsButton.tintColor = .black

        inputTextView.becomeFirstResponder()
    }
    
    func handleShowOptions() {
        showKeyBoardButton.setTitleColor(.black, for: .normal)
        showEmojiButton.tintColor = .black
        showToUserButton.setTitleColor(.black, for: .normal)
        showOptionsButton.tintColor = .blue

        self.setupOptionsContainerView()
//        inputTextView.becomeFirstResponder()
    }
    
    func backButtonClick(sender: UIButton) {
        let chatLog = ChatLogController()
        chatLog.removeFromParentViewController()
        NotificationCenter.default.removeObserver(handleKeyboardWillShow)
        NotificationCenter.default.removeObserver(handleKeyboardWillEnd)

        self.navigationController?.popViewController(animated: true)
    }
    
    func showChatInformation() {
//        self.present(ViewController1(), animated: true, completion: nil)
    }
    
    func setupNavBar() {
        self.navigationItem.hidesBackButton = true
        let leftBarItem = UIBarButtonItem(image: UIImage(named: "backBT")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector (backButtonClick(sender:)))
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "rsz_threedots")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector (showChatInformation))
        navigationItem.rightBarButtonItem = rightBarItem
        navigationItem.rightBarButtonItem?.tintColor = .white
        
    }
    
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        startingImageView.isHidden = true
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.blue
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.removeFromSuperview()
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseInOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                
                let height = (self.startingFrame?.height)! / (self.startingFrame?.width)! * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: nil)
        }
        
    }
    
    func handleZoomOut(tapGesture: UIPanGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            // need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.removeFromSuperview()
            }, completion: { [unowned self] (completion: Bool) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }

}

extension ChatLogController {
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
//    }
//
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId)
        header?.backgroundColor = .clear

        let dateLabel = UILabel()
        dateLabel.backgroundColor = .gray
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        dateLabel.layer.cornerRadius = 8
        dateLabel.layer.masksToBounds = true
        dateLabel.text = textForHeaders[section]
        
        header?.addSubview(dateLabel)
        dateLabel.anchor(header?.topAnchor, left: header?.centerXAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: -50, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 20)
        return header
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return textForHeaders.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath) as! ChatMessageCell
        cell.message = messages[indexPath.row]
        cell.dateString = dateStrings[indexPath.row]
        if messages.count == 1 || indexPath.row == 0{
            cell.dateLabel.isHidden = false
        } else {
            if dateStrings[indexPath.row] == dateStrings[indexPath.row - 1] {
                cell.dateLabel.isHidden = true
            } else if dateStrings[indexPath.row] != dateStrings[indexPath.row - 1] {
                cell.dateLabel.isHidden = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = self.view.frame.width - 104
        let height = self.estimateFrameForText(text: messages[indexPath.row].text!, width: width, height: 1000).height
//        if messages.count == 1 || indexPath.row == 0{
//            return (4 + 16 + 4 + height + 44 + 20)
//        } else {
//            if dateStrings[indexPath.row] == dateStrings[indexPath.row - 1] {
//                return (4 + 16 + 4 + height + 4 + 20)
//            } else if dateStrings[indexPath.row] != dateStrings[indexPath.row - 1] {
//                return (4 + 16 + 4 + height + 44 + 20)
//            }
//        }
        return (4 + 16 + 4 + height + 44)
    }
    
        func estimateFrameForText(text: String, width: CGFloat, height: CGFloat) -> CGRect {
            let size = CGSize(width: width, height: height)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
        }

}
