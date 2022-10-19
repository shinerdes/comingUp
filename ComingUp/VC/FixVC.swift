
import FSCalendar
import UIKit

var fixDate = ""

class FixVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITextViewDelegate {
    
    @IBOutlet weak var fixTitleTextField: UITextField!
    @IBOutlet weak var fixImageView: UIImageView!

    @IBOutlet weak var fixTextView: UITextView!
    @IBOutlet weak var fixDateLbl: UILabel!
    let imagePicker = UIImagePickerController()
    var pickImage = UIImage()
    var pickInfo: [UIImagePickerController.InfoKey : Any]?
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var scrollView: UIView!
    
    @IBOutlet weak var calendarBtn: UIButton!
    
    var checkScroll = 0
    
    var receiveId = 0
    var receiveTitle = ""
    var receiveDate = ""
    var receiveImageHead = ""
    var receiveContent = ""
    var receiveCreateDate = ""
    var receiveIndex = 0
   // var receiveDate = ""
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    
    let todoListViewModel = TodoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoListViewModel.loadTasks()
        

        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        calendarBtn.setTitle("", for: .normal)
        
        imagePicker.delegate = self
        fixTitleTextField.text = receiveTitle
        
        fixDateLbl.text = receiveDate
        fixTextView.text = receiveContent
        fixTextView.isEditable = true
        fixTextView.layer.cornerRadius = 5


        
        fixTextView.delegate = self
        fixTextView.isScrollEnabled = true
        fixTextView.font = UIFont.systemFont(ofSize: 17.0)
       
        fixImageView.image = load(fileName: receiveImageHead)
        fixImageView.layer.cornerRadius = 5
        
        scroll.isScrollEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(Pickdate), name: .date, object: nil)

        
        print(receiveDate)
        
        print("receiveDate")
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        scrollView.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {

        fixDateLbl.text = receiveDate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        fixDate = ""
    }
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
       // let fileUrl = URL(fileURLWithPath: fileName)

        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

//        let vc = segue.destination as! OpenSourceVC
//        let cell = sender as! UITableViewCell
//        let indexPath = tableView.indexPath(for: cell)
//        vc.showLicense = openSourceItems[(indexPath?.row)!]
        
        if segue.identifier == "sgReturnDetail" {

            let vc = segue.destination as! DetailVC
            vc.detailTitle = receiveTitle
            vc.detailContent = receiveContent
            vc.detailDate = receiveDate
            vc.detailImageHead = receiveImageHead
            vc.detailCreateDate = receiveCreateDate
            vc.detailId = receiveId
            vc.detailIndex = receiveIndex
//            vc = source //setting the titleString created from my ToDoListDetailViewController and setting it to contentTitle

          }
        
        
        
        // detailView.receiveItem(items[((indexPath as NSIndexPath?)?.row)!])

    }
    
    @objc func Pickdate() {
        print("어우어어우")
        print(fixDate)
        fixDateLbl.text = fixDate
        receiveDate = fixDate
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("tap")
        if checkScroll == 1 {
            checkScroll = 0
            dismissKeyboard()
            DispatchQueue.main.async {
                self.scroll.scroll(to: .top)
               
            }
        }
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        print("exampleTextView: BEGIN EDIT")
        checkScroll = 1
        DispatchQueue.main.async {
            
            self.scroll.scroll(to: .center)
            
        }
     }
     
     func textViewDidEndEditing(_ textView: UITextView) {
         print("exampleTextView: END EDIT")
      
         DispatchQueue.main.async {
                
             self.scroll.scroll(to: .top)
         }
     }
    
    
    @IBAction func fixBtnWasPressed(_ sender: Any) {
        
        // createDate에 대한 고민 ? 이걸 수정도 걍 createDate로 찍는게 나을려나
       
        
        if let title = fixTitleTextField.text {
            receiveTitle = title
        } else {
            // 없으면 alert
        }
        
        if let content = fixTextView.text {
            receiveContent = content
        } else {
            // 없으면 alert
        }
        
        
        if pickInfo == nil {
            print("nil이니깐 기본으로 깔아주자")
            // 아니 근데 애초에 안불러온다고 생각하면 되는거 아닌가
       
        } else {
            
            let imageUrl = pickInfo?[UIImagePickerController.InfoKey.imageURL] as? NSURL
            // logs show nil here
            let imageName         = imageUrl?.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let photoURL          = NSURL(fileURLWithPath: documentDirectory)
            let localPath         = photoURL.appendingPathComponent(imageName!) // crashes here due to forced unwrap of imageName (nil)
            
            if !FileManager.default.fileExists(atPath: localPath!.path) {
                do {
                    try pickImage.jpegData(compressionQuality: 1.0)?.write(to: localPath!)
                    print("file saved")
                    print(localPath)
                    print(imageName)
                    receiveImageHead = imageName!
                    
                } catch {
                    print("error saving file")
                }
            }
            else {
                print("file already exists")
            } // 이미지 저장
        
            
        }
        
        
        print("이게 안되네?")
        guard let checkEmpty = fixTitleTextField.text, checkEmpty.isEmpty == false else {
            
            let alert = UIAlertController(title: "타이틀을 입력하세요", message: nil, preferredStyle: UIAlertController.Style.alert)
            present(alert, animated: true, completion: nil)
            
            return
            
            
        }
        
        let todo = Todo(id: receiveIndex, title: receiveTitle, content: receiveContent, date: receiveDate, imageHead: receiveImageHead, favorite: false, createDate: receiveCreateDate)
        todoListViewModel.updateTodo(todo)
        print(todoListViewModel.updateTodo(todo))
        
        performSegue(withIdentifier: "sgReturnDetail", sender: nil)
      
        
//
//        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as? DetailVC else {
//            return
//        }
//
//        detailVC.detailTitle = receiveTitle
//        detailVC.detailDate = receiveDate
//        detailVC.detailContent = receiveContent
//        detailVC.detailImageHead = receiveImageHead
//        detailVC.detailCreateDate = receiveCreateDate
//        detailVC.detailId = receiveId
//        detailVC.detailIndex = receiveIndex
//
//
//        self.present(detailVC, animated: true, completion: nil)
//
        
        //
        
        // 올려져있는걸 json update
        // receive data 갱신해서 넘기기
        
    }

    @IBAction func CalendarBtnWasPressed(_ sender: Any) {
        let calendarVC = self.storyboard?.instantiateViewController(withIdentifier: "Calendar") as? PopUpCalendarVC
        calendarVC?.modalPresentationStyle = .popover
//        calendarVC?.PopUpcalendar.delegate = self
//        calendarVC?.PopUpcalendar.dataSource = self
        print("아니")
        calendarVC?.enterType = 2
        
        self.present(calendarVC!, animated: true, completion: nil)
    }
    

    
    @IBAction func fixImageLoadBtnWasPressed(_ sender: Any) {
        self.openLibrary()
    }
    
    func openLibrary(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
      
        present(imagePicker, animated: false, completion: nil)
    }
    
    
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        print(dateFormatter.string(from: date) + " 선택됨")
//        receiveDate = dateFormatter.string(from: date)
//    }
//
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        switch dateFormatter.string(from: date) {
//        case dateFormatter.string(from: Date()):
//            return "오늘"
//        default:
//            return nil
//        }
//
//    }
//
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension FixVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        //  info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            fixImageView.image = image
            pickImage = image
            
            print(info)
            print("불러오기 완료")
            print(image)
            //let imageData = image.pngData()
            
            pickInfo = info
            print(pickInfo)
            
            
//            do {
//                //let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//
//                //try imageData?.write(to: "\(documentsPath)myImage", options: [])
//                try imageData?.write(to: URL(string: "\(documentsPath)/myImage")!, options: .atomic)
//                print("저장완")
//
//            } catch {
//                print("Error")
//                print(error)
//            }


        } else {
            print("실패")
        }
        
        dismiss(animated: true, completion: nil)
    }

}


