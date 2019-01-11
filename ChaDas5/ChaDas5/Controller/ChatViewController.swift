

import UIKit
import Firebase
import MessageKit
import FirebaseFirestore
import MessageInputBar

class ChatViewController: MessagesViewController, MessagesProtocol {

  private var messageListener: ListenerRegistration?

  private let user: User
  private let channel: Channel


  deinit {
    messageListener?.remove()
  }

  init(user: User, channel: Channel) {
    self.user = user
    self.channel = channel
    super.init(nibName: nil, bundle: nil)

    title = channel.name
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

    static var lcount = 0
  override func viewDidLoad() {
    super.viewDidLoad()

    guard let id = channel.id else {
        self.dismiss(animated: true)
        return
    }

    MessagesManager.instance.messages = []
    MessagesManager.instance.loadMessages(from: self.channel, requester: self)

    let img = UIImage(named: "dismissIcon")
    let dismissButton = UIButton(frame: CGRect(x: 45, y: 50, width: 65, height: 55))
    dismissButton.setImage(img , for: .normal)
    dismissButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    dismissButton.contentMode = .center
    self.view.addSubview(dismissButton)


    maintainPositionOnKeyboardFrameChanged = true
    messageInputBar.inputTextView.tintColor = UIColor.basePink
    messageInputBar.sendButton.setTitleColor(UIColor.buttonPink, for: .normal)
    messageInputBar.sendButton.title = ""
    messageInputBar.sendButton.image = UIImage(named: "sendIcon")
    messageInputBar.sendButton.contentMode = .scaleAspectFill

    messageInputBar.delegate = self
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    
 
    
    messageInputBar.leftStackView.alignment = .center
    messageInputBar.sendButton.title = "Enviar"
    messageInputBar.backgroundView.backgroundColor = UIColor.basePink
    messageInputBar.isTranslucent = true
    messageInputBar.inputTextView.placeholderLabel.text = "Nova mensagem"
    messageInputBar.inputTextView.placeholderLabel.font = UIFont(name: "SFCompactDisplay-Ultralight", size: 18)
    messageInputBar.inputTextView.placeholderLabel.textColor = UIColor.gray
    messageInputBar.inputTextView.backgroundColor = UIColor.white
    messageInputBar.inputTextView.layer.cornerRadius = 15
    messageInputBar.inputTextView.font = UIFont(name: "SFCompactDisplay-Ultralight", size: 18)
    messageInputBar.setLeftStackViewWidthConstant(to: 10, animated: false)

  }

    func readedMessagesFromChannel(messages: [Message]) {
        self.messagesCollectionView.reloadData()

    }

    @objc func buttonAction(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }


  // MARK: - Helpers

  private func save(_ message: String) {
    let messageRep = Message(content: message)
    self.channel.add(message: messageRep)
    self.messagesCollectionView.scrollToBottom()
    insertNewMessage(messageRep)
  }

  private func insertNewMessage(_ message: Message) {

    let isLatestMessage = MessagesManager.instance.messages.index(of: message) == (MessagesManager.instance.messages.count - 1)
    let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage

    if shouldScrollToBottom {
      DispatchQueue.main.async {
        self.messagesCollectionView.scrollToBottom(animated: true)
      }
    }
  }


}



// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {

  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    return isFromCurrentSender(message: message) ? UIColor.basePink : UIColor.lightGray.withAlphaComponent(0.25)
  }


  func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
    return false
  }

  func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
    let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
    return .bubbleTail(corner, .curved)
  }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        avatarView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    
}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {

    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 200, height: 90)
    }

  func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return .zero
  }

  func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return CGSize(width: 0, height: 8)
  }

  func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 0
  }

func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
         return isFromCurrentSender(message: message) ? UIColor.black : UIColor.black
    }
    
    
 

}

// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }

    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return MessagesManager.instance.messages.count
    }


  func currentSender() -> Sender {
    return Sender(id: (UserManager.instance.currentUser?.uid)!, displayName: AppSettings.displayName)
  }

  func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
    return MessagesManager.instance.messages.count
  }

  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return MessagesManager.instance.messages[indexPath.row]
  }

  func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    let name = message.sender.displayName
    return NSAttributedString(
      string: name,
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .caption1),
        .foregroundColor: UIColor(white: 0.3, alpha: 1)
      ]
    )
  }

}

// MARK: - MessageInputBarDelegate

extension ChatViewController: MessageInputBarDelegate  {

  func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
    save(text)
    inputBar.inputTextView.text = ""

  }

}
