

import UIKit
import FSCalendar

var newDate = ""

public enum ScrollDirection {
    case top
    case center
    case bottom
}

class NewPostVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITextViewDelegate {
    
    
    
    
    var newTitle: String = ""
    var newContents: String = ""
    var newImageHead: String = "" // image 파일을 끄집어 내야
    var newCreateDate: String = ""
    var newFavorite: Bool = false
    
    let img = UIImage()
    var pickImage = UIImage()
    var pickInfo: [UIImagePickerController.InfoKey : Any]?
    var checkScroll = 0
    
    let todoModel = TodoViewModel()
    
    @IBOutlet weak var DateLbl: UILabel!
    
    @IBOutlet weak var titleTxtView: UITextField!
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var scrollView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
   // @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var calendarBtn: UIButton!
    
    let dateFormatter = DateFormatter()
    let imagePicker = UIImagePickerController()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
  
        //calendar.appearance.titleDefaultColor = UIColor.label


        
        dateFormatter.dateFormat = "yyyy-MM-dd"

//        calendar.delegate = self
 //       calendar.dataSource = self
        //calendar.swipeToChooseGesture.isEnabled = true // 다중선택
        scroll.isScrollEnabled = false
        textView.delegate = self
        textView.isScrollEnabled = true
        textView.layer.cornerRadius = 5
        
        calendarBtn.setTitle("", for: .normal)
    
        textView.font = UIFont.systemFont(ofSize: 17.0)
        
        imageView.layer.cornerRadius = 5

        
        print(dateFormatter.string(from: Date()))
        
        newDate = dateFormatter.string(from: Date())
        
        todoModel.loadTasks() // json load
        
        if let whiteImage = UIImage(named: "whiteBackground") {
            pickImage = whiteImage
            imageView.image = whiteImage
        } else {
            
        }
        print(pickInfo)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Pickdate), name: .date, object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        scrollView.addGestureRecognizer(tapGesture)

     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("searchedTypes")
        DateLbl.text = newDate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        newDate = ""
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        
    }
    

    @IBAction func imageLoadBtnPressed(_ sender: Any) {
        self.openLibrary()
        
        
    }
    
    func openLibrary(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
      
        present(imagePicker, animated: false, completion: nil)
    }

//
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        print(dateFormatter.string(from: date) + " 선택됨")
//        newDate = dateFormatter.string(from: date)
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

    
    @IBAction func unwindToMain(_ unwindSegue: UIButton) {

        performSegue(withIdentifier: "unwindToMainVC", sender: self)



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
    @objc func Pickdate() {
        print("어우어어우")
        print(newDate)
        DateLbl.text = newDate
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
    
    
    @IBAction func CalendarBtnWasPressed(_ sender: Any) {
        let calendarVC = self.storyboard?.instantiateViewController(withIdentifier: "Calendar") as? PopUpCalendarVC
        calendarVC?.modalPresentationStyle = .popover
//        calendarVC?.PopUpcalendar.delegate = self
//        calendarVC?.PopUpcalendar.dataSource = self
        print("아니")
        calendarVC?.enterType = 1
        
        self.present(calendarVC!, animated: true, completion: nil)

    }
    
    
    
    
    @IBAction func enrollBtnWasPressed(_ sender: Any) {
     
        let createDate = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss") // json 저장되는 날짜와 시간
        
        
        if let title = titleTxtView.text {
            //print(title)
            newTitle = title
        } else {
            
        }
        
        if let content = textView.text {
            //print(content)
            newContents = content
        } else {
            
        }
        
        print(createDate)
        print(newDate)
        
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
                    newImageHead = imageName!
                    
                } catch {
                    print("error saving file")
                }
            }
            else {
                print("file already exists")
            } // 이미지 저장
            
            
        }

        
        // 여기서 start
        
        guard let checkEmpty = titleTxtView.text, checkEmpty.isEmpty == false else {
            
            let alert = UIAlertController(title: "타이틀을 입력하세요", message: nil, preferredStyle: UIAlertController.Style.alert)
            present(alert, animated: true, completion: nil)
            
            return
            
        }
         // 날짜 체크
       
        
        let todo = TodoManager.shared.createTodo(title: checkEmpty, content: newContents, date: newDate, imageHead: newImageHead, createDate: createDate)
        todoModel.addTodo(todo)
        print("json 저장 완료") // 일단 image를 제외한 나머지는 ok
       
       
        
        
        
        
        //self.navigationController?.popViewController(animated: true)
        
//        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "mainVC")
//        self.present(mainVC!, animated: true, completion: nil)
//
            
//        if let loadImageURL = pickInfo[UIImagePickerController.InfoKey.imageURL] as? NSURL {
//            let imageUrl = loadImageURL
//
//        } else {
//            let imageUrl = ""
        //        }
        
        /*
         
         
         guard let detail = inputTextField.text, detail.isEmpty == false else { return }
         let todo = TodoManager.shared.createTodo(detail: detail, isToday: isTodayButton.isSelected)
         todoListViewModel.addTodo(todo)
         collectionView.reloadData()
         inputTextField.text = ""
         isTodayButton.isSelected = false
         
         */
        
        
        
        // if let으로 textView 긁어오기
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}





extension NewPostVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        //  info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            imageView.image = image
            pickImage = image
            
            print(info)
            print("불러오기 완료")
            print(image)
            //let imageData = image.pngData()
            
            pickInfo = info
            print(pickInfo)
            


        } else {
            print("실패")
        }
        
        dismiss(animated: true, completion: nil)
    }

}

extension Date {
    
    func toString( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
   
}

extension Notification.Name {
    static let date = Notification.Name("date")
}


public extension UIScrollView {
    func scroll(to direction: ScrollDirection) {
       DispatchQueue.main.async {
           switch direction {
           case .top:
               self.scrollToTop()
           case .center:
               self.scrollToCenter()
           case .bottom:
               self.scrollToBottom()
           }
       }
   }

   private func scrollToTop() {
       setContentOffset(.zero, animated: true)
   }

   private func scrollToCenter() {
      // let centerOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height) / 2)
       let centerOffset = CGPoint(x: 0, y: 222)
       setContentOffset(centerOffset, animated: true)
   }

   private func scrollToBottom() {
       let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
       if(bottomOffset.y > 0) {
           setContentOffset(bottomOffset, animated: true)
       }
   }
}


extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
