

import UIKit

class MainTableCell: UITableViewCell {


    @IBOutlet weak var TodoTitleLbl: UILabel!
    @IBOutlet weak var TodoDateLbl: UILabel!
    @IBOutlet weak var TodoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
       // let fileUrl = URL(fileURLWithPath: fileName)
        
        if fileName == "" {
            return nil
        }

        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configure(title: String, date: String, image: String) {
        TodoDateLbl.text = date
        TodoTitleLbl.text = title
        TodoImageView.image = load(fileName: image)
        
    }

}
