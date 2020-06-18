import UIKit
//2nd view for the sender of the message
//user's messages are to be sent to the right side of the screen
class Chat2TableViewCell: UITableViewCell {

    @IBOutlet var lblSender: UILabel!
    
    @IBOutlet var imgSender: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()


    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
