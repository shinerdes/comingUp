

import UIKit

class SettingVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    private let openSourceItems: [String] = ["FSCalendar", "ViewAnimator"]
    private let dataItems: [String] = ["모든 데이터 삭제"]
    private let sections: [String] = ["OpenSource", "Data Manager"]
    private let Item: [String] = ["fsCalender", "viewAnimator"]


    @IBOutlet weak var tableView: UITableView!
    
    
    var source = ""
    
    func anotherAlert() {
        let doneAlert = UIAlertController(title: "끝났다", message: nil, preferredStyle: UIAlertController.Style.alert)
        doneAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler : nil))
        self.present(doneAlert, animated: false, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
  
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section]
        
        
    }

   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return openSourceItems.count
            
        } else if section == 1 {
            return dataItems.count
            
        } else {
            return 0
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "openSourceViewCell", for: indexPath) as! OpenSourceViewCell
        
        if indexPath.section == 0 {
            cell.configure(title: "\(openSourceItems[indexPath.row])")
           
            
            
        } else if indexPath.section == 1 {
            cell.configure(title: "\(dataItems[indexPath.row])")
            
        } else {
            return UITableViewCell()
        }
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

//        let vc = segue.destination as! OpenSourceVC
//        let cell = sender as! UITableViewCell
//        let indexPath = tableView.indexPath(for: cell)
//        vc.showLicense = openSourceItems[(indexPath?.row)!]
        
        if segue.identifier == "sgOpenSource" {

            let vc = segue.destination as! OpenSourceVC
            vc.showLicense = source //setting the titleString created from my ToDoListDetailViewController and setting it to contentTitle

          }
        
        // detailView.receiveItem(items[((indexPath as NSIndexPath?)?.row)!])

    }

  
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("Value: \(openSourceItems[indexPath.row])")
            if indexPath.row == 0 {
                print("FS")
                
//                guard let openSourceVC = self.storyboard?.instantiateViewController(withIdentifier: "openSourceVC") as? OpenSourceVC else {
//                    return
//                }
                source = Item[indexPath.row]
                performSegue(withIdentifier: "sgOpenSource", sender: indexPath.row)
                
            
//   self.present(openSourceVC, animated: true, completion: nil)
                
                
            } else if indexPath.row == 1 {
             
                
//                guard let openSourceVC = self.storyboard?.instantiateViewController(withIdentifier: "openSourceVC") as? OpenSourceVC else {
//                    return
//                }
//                openSourceVC.showLicense = "viewAnimatorLicense"
                
                source = Item[indexPath.row]
                performSegue(withIdentifier: "sgOpenSource", sender: indexPath.row)
//      self.present(openSourceVC, animated: true, completion: nil)
            }
            
        } else if indexPath.section == 1 {
            print("Value: \(dataItems[indexPath.row])")
            print("여기는 데이터 다 나가리 영역")
            // 여기는 alert를 해준다.
            
            
            let allRemoveAlert = UIAlertController(title: "초기화", message: "모든 데이터가 삭제됩니다.", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "OK", style: .destructive, handler: { (UIAlertAction) in
                
                let fileManager = FileManager.default
                let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

                print(dirPath)

                do {
                    let folderPath = dirPath
                    let paths = try fileManager.contentsOfDirectory(atPath: dirPath)
                    for path in paths
                    {
                        try fileManager.removeItem(atPath: "\(folderPath)/\(path)")
                    }
                }
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
                
                
                self.anotherAlert()

 
                
            })
                 
                // 여기에 삭제 달리면 됨
                
              
                
                
            
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler : nil)
            
            

            allRemoveAlert.addAction(okAction)
            
            allRemoveAlert.addAction(cancel)
            
            present(allRemoveAlert, animated: true, completion: nil)
            
            
        } else { return
            
        }
        
    }

    @IBOutlet weak var openSourceTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openSourceTableView.dataSource = self
        openSourceTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    
    
//    @IBAction func allRemoveDataBtnWasPressed(_ sender: Any) {
//        
//        let fileManager = FileManager.default
//        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        
//        print(dirPath)
//
//        do {
//            let folderPath = dirPath
//            let paths = try fileManager.contentsOfDirectory(atPath: dirPath)
//            for path in paths
//            {
//                try fileManager.removeItem(atPath: "\(folderPath)/\(path)")
//            }
//        }
//        catch let error as NSError
//        {
//            print(error.localizedDescription)
//        }
//        
//        
//
//        
//
//        // json안에 있는걸 다 날림 + 이미지도 다 날림
//        // todos.json은 생성
//        
//        
//        
//        
//        
//        
//        //json 파일은 생성을 하긴 해야함
//        
//        
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
