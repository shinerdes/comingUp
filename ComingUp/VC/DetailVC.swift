//
//  DetailVC.swift
//  AdvancedToDoApp
//
//  Created by 김영석 on 2020/11/04.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit



class DetailVC: UIViewController {
    
    var detailId = 0
    var detailTitle = ""
    var detailDate = ""
    var detailContent = ""
    var detailImageHead = ""
    var detailCreateDate = ""
    var detailIndex = 0
    
    
    let todoListViewModel = TodoViewModel()
    
    @IBOutlet weak var detailTitleLbl: UILabel!
    @IBOutlet weak var detailDateLbl: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet weak var deteleBtn: UIButton!
    @IBOutlet weak var fixBtn: UIButton!
    
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImageView.layer.cornerRadius = 5
        detailTextView.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailTitleLbl.text = self.detailTitle
        detailDateLbl.text = self.detailDate
        detailTextView.text = self.detailContent
        detailImageView.image = self.load(fileName: detailImageHead)
        detailTextView.isEditable = false
        
        detailTextView.font = UIFont.systemFont(ofSize: 17.0)
        
        print(detailIndex)
        
        todoListViewModel.loadTasks()
        
        //deteleBtn.setImage(#imageLiteral(resourceName: "trash"), for: .normal)
        //fixBtn.setImage(#imageLiteral(resourceName: "fix"), for: .normal)
        
    }
    
    @IBAction func fixBtnWasPressed(_ sender: Any) {

        performSegue(withIdentifier: "sgFix", sender: detailIndex)
    }
    
    @IBAction func returnDetail(_ sender: UIStoryboardSegue){
        if let from = sender.source as? FixVC {
            detailTitle = from.receiveTitle
            detailContent = from.receiveContent
            detailDate = from.receiveDate
            detailImageHead = from.receiveImageHead
            detailIndex = from.receiveIndex
            detailId = from.receiveId
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

//        let vc = segue.destination as! OpenSourceVC
//        let cell = sender as! UITableViewCell
//        let indexPath = tableView.indexPath(for: cell)
//        vc.showLicense = openSourceItems[(indexPath?.row)!]
        
        if segue.identifier == "sgFix" {

            let vc = segue.destination as! FixVC
            vc.receiveTitle = detailTitle
            vc.receiveDate = detailDate
            vc.receiveContent = detailContent
            vc.receiveImageHead = detailImageHead
            vc.receiveCreateDate = detailCreateDate
            vc.receiveId = detailId
            vc.receiveIndex = detailIndex
//            vc = source //setting the titleString created from my ToDoListDetailViewController and setting it to contentTitle

          }
        
        
        
        // detailView.receiveItem(items[((indexPath as NSIndexPath?)?.row)!])

    }

    
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
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
    
    
    
    
    @IBAction func deteleBtnWasPressed(_ sender: Any) {
        
        
        let todo = Todo(id: detailId, title: detailTitle, content: detailContent, date: detailDate, imageHead: detailImageHead, favorite: false, createDate: detailCreateDate)
        
        todoListViewModel.deleteTodo(todo)
        
        if detailImageHead != "" {
            
            
            let fileManager = FileManager.default
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            
            print(dirPath)

            do {
                let folderPath = dirPath
                let paths = try fileManager.contentsOfDirectory(atPath: dirPath)
                for path in paths
                {
                    
                    print("일단 돌아가나 확인")
                    
                    print(path)
                    if detailImageHead == path {
                        print("이야 같다")
                        
                        // 제거 ~~~~
                        
                        try fileManager.removeItem(atPath: "\(folderPath)/\(detailImageHead)")
                        
                    }
                    
                }
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            
            // 삭제 처리
        } else {
            // 냅둠
        }

       
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
