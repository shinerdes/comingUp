

import UIKit
import FSCalendar

class PopUpCalendarVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    var dateSelected = ""
    var enterType = 0
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarView: UIView!
    let dateFormatter = DateFormatter()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        calendar.delegate = self
        calendar.dataSource = self
        setCalendarUI()

//        //PopUpcalendar.appearance.titleDefaultColor = UIColor.label
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        calendarView.layer.cornerRadius = 5
        print(enterType)
        print("enterType")
       

        // Do any additional setup after loading the view.
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.post(name: .date, object: nil)
//
//    }

    
    func setCalendarUI() {
        self.calendar.locale = Locale(identifier: "ko_KR")
        
        self.calendar.appearance.weekdayTextColor = UIColor(named: "F0F0F0")?.withAlphaComponent(0.2)

        self.calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        self.calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        self.calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        self.calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        self.calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        self.calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        self.calendar.calendarWeekdayView.weekdayLabels[6].text = "토"

        
        self.calendar.appearance.headerDateFormat = "YYYY년 MM월"
        self.calendar.appearance.headerTitleColor = UIColor(named: "FFFFFF")?.withAlphaComponent(0.9)
        self.calendar.appearance.headerTitleAlignment = .center
        
        // 달에 유효하지 않은 날짜의 색 지정
        self.calendar.appearance.titlePlaceholderColor = UIColor.white.withAlphaComponent(0.2)
        // 평일 날짜 색
        self.calendar.appearance.titleDefaultColor = UIColor.white.withAlphaComponent(0.5)
        // 달에 유효하지않은 날짜 지우기
        self.calendar.placeholderType = .none
        
      
        
    }
    


    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(dateFormatter.string(from: date) + " 선택됨")
        dateSelected = dateFormatter.string(from: date)
    }

    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        switch dateFormatter.string(from: date) {
        case dateFormatter.string(from: Date()):
            return "오늘"
        default:
            return nil
        }
    }


    @IBAction func enrollDateBtnWasPressed(_ sender: Any) {

        if enterType == 1 {
            newDate = dateSelected
            print(dateSelected)
            NotificationCenter.default.post(name: .date, object: nil)
            dismiss(animated: true)
        } else if enterType == 2 {
            fixDate = dateSelected
            print(dateSelected)
            NotificationCenter.default.post(name: .date, object: nil)
            dismiss(animated: true)
        }
        
        
    }
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        
        dismiss(animated: true)

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
