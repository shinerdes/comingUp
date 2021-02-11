//
//  MainVC.swift
//  AdvancedToDoApp
//
//  Created by 김영석 on 2020/10/28.
//  Copyright © 2020 FastCampus. All rights reserved.
//


// 남은 작업


// 오토레이 아웃 // 마지막 파이널
// 프로젝트 이름 리네이밍
import UIKit
import ViewAnimator

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //@IBOutlet weak var newPostBtn: UIButton!
    @IBOutlet weak var comingUpTitleLbl: UILabel!
    @IBOutlet weak var comingUpDateLbl: UILabel!
    
   
    private var items = [Any?]()
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    private let animations = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
    
    // var iconArray = Array<String>() // icon
    // dateArray 정렬 -> 오늘 날짜에 가장 가까운 date의 index를 뽑아내서 다시 pass
    
    
    
    var comingUpNextTitle = "돌아오는 일정은 없습니다"
    var comingUpNextDate = ""
    
    let todoListViewModel = TodoViewModel()
    
    var titleArray = Array<String>()
    var contentArray = Array<String>()
    var dateArray = Array<String>()
    var createDateArry = Array<String>()
    var imageArray = Array<String>()
    var idArray = Array<Int>()
    var favoriteArray = Array<Bool>()
    
    var passTitle = ""
    var passContent = ""
    var passDate = ""
    var passCreateDate = ""
    var passImage = ""
    var passId = 0
    var passIndex = 0
    
    var index: Int = 0
    
    let date = Date()
    var sortDateArray: [Date] = []
  
    
    var sortStringDateArray = Array<String>()
    
    var dateFormatter = DateFormatter()

    
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        todoListViewModel.loadTasks()
        
        print("테스트")
        print(todoListViewModel.loadTasks())
        
    
        
        
        
       
        
        //let fullPath =
        
        //if let imsiContent = try? String(
        
        // Do any additional setup after loading the view.
        
        // table View
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadJson()
        
        print("절취선")
        comingUp()
        
    
        NotificationCenter.default.addObserver(self, selector:"reloadData", name:
        NSNotification.Name(rawValue: "reloadTableView"), object: nil)
        self.tableView.reloadData()
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        UIView.animate(views: tableView.visibleCells, animations: animations, completion: {
//
//        })

        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        titleArray.removeAll()
        contentArray.removeAll()
        dateArray.removeAll()
        createDateArry.removeAll()
        imageArray.removeAll()
        idArray.removeAll()
        favoriteArray.removeAll()
        
    }
    
    func reload() {
        self.tableView.reloadData()
        print(titleArray)
        print(dateArray)
    }
    
    func reloadData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("Work SO !!")
            self.tableView.reloadData()
        }
    }
    

    
    @IBAction func getNewFriendData(_ sender: UIStoryboardSegue){
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

//        let vc = segue.destination as! OpenSourceVC
//        let cell = sender as! UITableViewCell
//        let indexPath = tableView.indexPath(for: cell)
//        vc.showLicense = openSourceItems[(indexPath?.row)!]
        
        if segue.identifier == "sgDetail" {

            let vc = segue.destination as! DetailVC
            vc.detailTitle = passTitle
            vc.detailContent = passContent
            vc.detailDate = passDate
            vc.detailImageHead = passImage
            vc.detailCreateDate = passCreateDate
            vc.detailId = passId
            vc.detailIndex = passIndex
//            vc = source //setting the titleString created from my ToDoListDetailViewController and setting it to contentTitle

          }
        
        
        
        // detailView.receiveItem(items[((indexPath as NSIndexPath?)?.row)!])

    }

    
    private func setupActivityIndicator() {
        activityIndicator.center = CGPoint(x: view.center.x, y: 100.0)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    

    func loadJson() {
        
        let fileName = "todos"
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("json")
        print("File PAth: \(fileURL.path)")
        do {
            
            let data = try Data(contentsOf: URL(fileURLWithPath: fileURL.path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            //print(jsonResult)
            
            
            if let idCount = jsonResult as? [[String:Any]]{
                for dic in idCount {
                    guard let title = dic["title"] as? String else { return }
                    guard let content = dic["content"] as? String else { return }
                    guard let imageHead = dic["imageHead"] as? String else { return }
                    guard let date = dic["date"] as? String else { return }
                    guard let createDate = dic["createDate"] as? String else { return }
                    guard let id = dic["id"] as? Int else { return }
                    guard let favorite = dic["favorite"] as? Bool else { return }
                    idArray.append(id)
                    titleArray.append(title)
                    contentArray.append(content)
                    dateArray.append(date)
                    imageArray.append(imageHead)
                    createDateArry.append(createDate)
                    favoriteArray.append(favorite)
                    
                    
                    print(title)
                    print(content)
                    print(imageHead)
                    print(date)
                    print(createDate)
                    print(id)
                    print(favorite)
                    
                    print("------------")
                }
                
            }
            
            print(idArray)
            print(titleArray)
            print(contentArray)
            print(dateArray)
            print("imageArray")
            print(imageArray)
            print(createDateArry)
            print(favoriteArray)
            
            
            
            
        } catch {
            
        }
        
        
        
    }
    
    
    func comingUp() {
        dateFormatter.dateFormat = "yyyy-MM-dd"// yyyy-MM-dd"
        
    
        
        for dat in dateArray {
            let date = dateFormatter.date(from: dat)
            if let date = date {
                sortDateArray.append(date)
            }
        }
   
        var ready = sortDateArray.sorted(by: { $0.compare($1) == .orderedAscending })
        let today = dateFormatter.string(from: date)
     
        
        for i in 0..<ready.count {
            print(i)
            sortStringDateArray.append(ready[i].toString(dateFormat: "yyyy-MM-dd"))
        }
        // 여기서 없을경우 끝내야함
        

        for _ in 0..<sortStringDateArray.count {
            if sortStringDateArray[0] < today {
                sortStringDateArray.remove(at: 0)
            }
            print("일단 몇번인지 확인")
        }
       
        
        
        


        var imsi = 0
        
        // 여기서 sortStringDateArray[0]값이 coming up next 날짜
        if sortStringDateArray.count != 0 {
            
            for i in 0..<dateArray.count {
                if dateArray[i] == sortStringDateArray[0] {
                    
                    imsi = i // index값
                    print(titleArray[imsi]) // 타이틀 나옴
                    comingUpNextTitle = titleArray[imsi]
                    comingUpNextDate = sortStringDateArray[0]
                    break
                }
            }
            
        }


        print("--------")
        print(comingUpNextTitle)
        print(comingUpNextDate)

        comingUpTitleLbl.text = comingUpNextTitle
        comingUpDateLbl.text = comingUpNextDate
        
        
        comingUpNextTitle = "돌아오는 일정은 없습니다"
        comingUpNextDate = ""
        

        sortStringDateArray.removeAll()
        sortDateArray.removeAll()
    
       
    }
    
    
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return idArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableCell", for: indexPath) as! MainTableCell
        
        cell.backgroundColor = tableView.backgroundColor
        cell.TodoImageView.layer.cornerRadius = 10
        cell.TodoImageView.layer.borderWidth = 1
        cell.TodoImageView.layer.borderColor = UIColor.clear.cgColor
        // 뷰의 경계에 맞춰준다
        cell.TodoImageView.clipsToBounds = true
        cell.configure(title: titleArray[indexPath.row], date: dateArray[indexPath.row], image: imageArray[indexPath.row])
        // image를 파일에서 끄집어 내야하는듯?
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // go to detailVC
        
        
        
        
//        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as? DetailVC else {
//            return
//        }
//
//        // 보내줘야 할 것들
//        // 제목 , date, content, image, create date
//        detailVC.detailTitle = titleArray[indexPath.row]
//        detailVC.detailDate = dateArray[indexPath.row]
//        detailVC.detailContent = contentArray[indexPath.row]
//        detailVC.detailImageHead = imageArray[indexPath.row]
//        detailVC.detailCreateDate = createDateArry[indexPath.row]
//        detailVC.detailId = idArray[indexPath.row]
//        detailVC.detailIndex = indexPath.row
        
        passTitle = titleArray[indexPath.row]
        passDate = dateArray[indexPath.row]
        passContent = contentArray[indexPath.row]
        passImage = imageArray[indexPath.row]
        passCreateDate = createDateArry[indexPath.row]
        passId = idArray[indexPath.row]
        passIndex = indexPath.row
        
        performSegue(withIdentifier: "sgDetail", sender: indexPath.row)
      
        
//        self.present(detailVC, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
  
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


@IBDesignable
class DesignableView: UIView {
}

extension UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
