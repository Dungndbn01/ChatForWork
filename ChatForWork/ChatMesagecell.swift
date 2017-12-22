//
//  ChatMesagecell.swift
//  ChatForWork
//
//  Created by DevOminext on 12/18/17.
//  Copyright © 2017 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase

class ChatMessageCell: UITableViewCell, UITextViewDelegate {
    var message: Message? {
        didSet {
            fetchUser()
        }
    }
    
    var dateString: String? {
        didSet {
            dateLabel.backgroundColor = .gray
            dateLabel.textColor = .white
            dateLabel.textAlignment = .center
            dateLabel.layer.cornerRadius = 8
            dateLabel.layer.masksToBounds = true
            dateLabel.text = dateString
            contentView.addSubview(dateLabel)
            dateLabel.anchor(contentView.topAnchor, left: contentView.centerXAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: -50, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 20)
        }
    }
    
    lazy var profileImageView = UIImageView()
    lazy var nameLabel = UILabel()
    lazy var messageText = UITextView()
    lazy var messageTime = UILabel()
    lazy var headerDate = UILabel()
    lazy var dateLabel = UILabel()
    
    let linkAttributes: [String : Any] = [
        NSForegroundColorAttributeName: UIColor.blue,
        NSUnderlineColorAttributeName: UIColor.lightGray,
        NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
    
    private func fetchUser() {
        let userId = message?.fromId
        let ref = Database.database().reference().child("user").child(userId!)
        ref.observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            if let dictionary = DataSnapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupViews(user: user)
                ref.removeAllObservers()
            }
        })
    }
    
    func getDateFromMessage(message: Message, index: Int) -> String{
        let seconds = message.timeStamp?.doubleValue
        let messageTimeStamp = NSDate(timeIntervalSince1970: seconds!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MM/yyyy"
        
        let dateString: String = dateFormatter.string(from: messageTimeStamp as Date)
        let dateString2: String = dateFormatter2.string(from: messageTimeStamp as Date)
        if index == 0 {
            return dateString2 }
        return dateString
    }
    
    func setupViews(user: User) {
        profileImageView.loadImageUsingCacheWithUrlString(urlString: (user.profileImageUrl)!)
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = user.name
        nameLabel.textColor = .lightGray
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        if message?.text != nil {
            messageText.text = message?.text }
        messageText.textColor = .darkText
        messageText.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        messageText.font = UIFont.systemFont(ofSize: 16)
        messageText.isEditable = false
        messageText.isSelectable = true
        messageText.delegate = self
        messageText.backgroundColor = .clear
        messageText.dataDetectorTypes = UIDataDetectorTypes.all
        messageText.linkTextAttributes = linkAttributes
        
        messageTime.text = self.getDateFromMessage(message: message!, index: 1)
        messageTime.font = UIFont.systemFont(ofSize: 14)
        messageTime.textColor = .lightGray
        messageTime.textAlignment = .right

        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageText)
        contentView.addSubview(messageTime)
        
        profileImageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 44, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        nameLabel.anchor(profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 16)
        messageText.anchor(nameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 100)
        messageTime.anchor(profileImageView.topAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 100, heightConstant: 16)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(Coder) has not been implemented")
    }

}
