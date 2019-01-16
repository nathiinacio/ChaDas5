

import UIKit
import Firebase
import MessageKit
import FirebaseFirestore
import MessageInputBar


class ChatViewController: MessagesViewController, MessagesProtocol {

  private var messageListener: ListenerRegistration?
  private let db = Firestore.firestore()
    
  private let user: User
  private let channel: Channel


  deinit {
    messageListener?.remove()
  }

  init(user: User, channel: Channel) {
    self.user = user
    self.channel = channel
    super.init(nibName: nil, bundle: nil)

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
    
    
    let complainButtonImg = UIImage(named: "complainIcon")
    let complainButton = UIButton(frame: CGRect(x: 250, y: 50, width: 65, height: 55))
    complainButton.setImage(complainButtonImg , for: .normal)
    complainButton.addTarget(self, action: #selector(complainAction), for: .touchUpInside)
    complainButton.contentMode = .center
    self.view.addSubview(complainButton)
    


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
    
    messagesCollectionView.scrollToBottom()
    scrollsToBottomOnKeyboardBeginsEditing = true
    maintainPositionOnKeyboardFrameChanged = true

  }

    func readedMessagesFromChannel(messages: [Message]) {
        self.messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom()

    }

    @objc func buttonAction(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func complainAction(sender: UIButton!) {
        
        let alert = UIAlertController(title: "Deseja mesmo bloquear esse usuário?", message: "Vocês não verão postagens um do outro mais! Esse usuário também será mandado para análise.", preferredStyle: .alert)
        
        
        let bloquear = UIAlertAction(title: "Bloquear Usuário", style: .default, handler: { (action) -> Void in
            
            
            var firstUser: String?
            var secondUser: String?
            
    
            
            guard let id = self.channel.id else {
                return
            }

            
            let docRef = FBRef.db.collection("channels").document(id)
            
            docRef.getDocument(source: .cache) { (document, error) in
                if let document = document {
                    
                    firstUser = document.get("firstUser") as? String
                    secondUser  = document.get("secondUser") as? String
                    print (firstUser!)
                    print (secondUser!)
                    self.db.collection("users").document(firstUser!).collection("block").document(secondUser!).setData(["id" : secondUser!])
                    self.db.collection("users").document(secondUser!).collection("block").document(firstUser!).setData(["id" : firstUser!])
                    
                    
                }
                
            }
            
            
            
            

        })
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .default ) { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(bloquear)
        alert.addAction(cancelar)
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.buttonPink
        
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
    self.messagesCollectionView.scrollToBottom(animated: true)
  }
    

}



// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {

  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    return isFromCurrentSender(message: message) ? UIColor.basePink : UIColor.lightGray.withAlphaComponent(0.25)
  }


  func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
    return true
  }

  func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
    let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
    return .bubbleTail(corner, .curved)
  }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
       avatarView.removeFromSuperview()
        
    }
    
    
}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {

  func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return .zero
  }

  func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return CGSize(width: 0, height: 8)
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
    return Sender(id: (UserManager.instance.currentUser)!, displayName: AppSettings.displayName)
  }

  func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
    return MessagesManager.instance.messages.count
  }

  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return MessagesManager.instance.messages[indexPath.row]
  }

}

// MARK: - MessageInputBarDelegate

extension ChatViewController: MessageInputBarDelegate  {

  func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
    save(text)
    inputBar.inputTextView.text = ""

  }

}
