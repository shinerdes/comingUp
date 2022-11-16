
import UIKit

class OpenSourceViewCell: UITableViewCell {

    @IBOutlet weak var openSourceLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(title: String) {
        openSourceLbl.text = title
    
    }

}
