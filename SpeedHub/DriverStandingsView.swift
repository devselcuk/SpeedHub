//
//  DriverStandingsView.swift
//  SpeedHub
//
//  Created by MacMini on 3.10.2021.
//

import UIKit

@available(iOS 13.0, *)
class DriverStandingsView: UIView, ModelObservable{
    var task : DriverStandingTask
   lazy var viewModel: ViewModel = DriverStandingsViewModel(delegate: self, task: task)
    
    var driverList : [DriverRow] = []
   let tableView = UITableView()
    
    
    var dataSource : UITableViewDiffableDataSource<Int,DriverRow>!
    
    func update(with model: Codable) {

        if let fetchedModel = model as? DriverStandingResponse {
            self.driverList = fetchedModel.MRData.StandingsTable.StandingsLists.first?.DriverStandings ?? []
            
            applyShot()
        }
        
    }
    
     init(task : DriverStandingTask,frame: CGRect) {
        self.task = task
        super.init(frame: frame)
        
           xxxCommon()
     
    }
    
    required init?(coder: NSCoder) {
        self.task = DriverStandingTask(request: DriverStandingRequest(season: "current"))
        super.init(coder: coder)
        
        xxxCommon()
    }
    
    
    
    private func xxxCommon() {
        viewModel.delegate = self
        tableView.frame = bounds
        insertSubview(tableView, at: 0)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tableView.register(UINib(nibName: "DriverTableViewCell", bundle: nil), forCellReuseIdentifier: "driver")
        
        
        dataSource = UITableViewDiffableDataSource<Int,DriverRow>(tableView: tableView, cellProvider: { tableView, indexPath, driver in
            let cell = tableView.dequeueReusableCell(withIdentifier: "driver") as! DriverTableViewCell
            cell.configureCell(with: driver)
            cell.backgroundColor = .black
            return cell
        })
        
    }
    
    private func applyShot() {
        var sna = NSDiffableDataSourceSnapshot<Int,DriverRow>()
        sna.appendSections([0])
        sna.appendItems(self.driverList, toSection: 0)
        
        dataSource.apply(sna, animatingDifferences: true, completion: nil)
        
    }


}



//extension DriverStandingsView : UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.driverList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "driver") as! DriverTableViewCell
//
//        cell.configureCell(with: driverList[indexPath.row])
//
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        50
//    }
//
//
//}

class PartView: UIView {
    
    
    @IBOutlet weak var gpLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var smallImageView: UIImageView!
    
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var bigImageView: UIImageView!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dfgggdsfsddad()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        dfgggdsfsddad()
    }
    

    
    private func dfgggdsfsddad() {
        let nib = UINib(nibName: "PartView", bundle: Bundle(for: type(of: self)))
        
        
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return}
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
        
        thirdLabel.layer.cornerRadius = 9
        thirdLabel.clipsToBounds = true
        
        gpLabel.layer.cornerRadius = 9
        gpLabel.clipsToBounds = true
        
        
    }

}

class CHLeader: PartView {

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fillView()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fillView()
    }
 
    
  
    
    func fillView() {
        titleLabel.text = "Leader"
        if #available(iOS 13.0, *) {
            smallImageView.image = UIImage(systemName: "1.circle.fill")
            bigImageView.image = UIImage(systemName: "person.fill.viewfinder")
        } else {
            // Fallback on earlier versions
        }
      
        secondLabel.text = "Championship"
        thirdLabel.text = "HAMILTON"
        mainLabel.text = "246.5"
    }
}

class LastView: PartView {

    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
  
    
    
    private func setView() {
        
        titleLabel.text = "Last Winner Of"
        secondLabel.text = "Turkish Grand Prix"
        if #available(iOS 13.0, *) {
            smallImageView.image = UIImage(systemName: "flag.2.crossed.fill")
            bigImageView.image = UIImage(systemName: "flag.2.crossed.fill")
        } else {
            // Fallback on earlier versions
        }
   
        
    }


}


class NextView: PartView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        iloveyouapple()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        iloveyouapple()
    }
    

    
    
    
    private func iloveyouapple() {
        titleLabel.text = "Next Race"
        secondLabel.text  = "Turkish Grand Prix"
        thirdLabel.text = "Remaining Time"
        if #available(iOS 13.0, *) {
            smallImageView.image = UIImage(systemName: "bell.fill")
            bigImageView.image = UIImage(systemName: "bell.fill")
        } else {
            // Fallback on earlier versions
        }
       
        
        let raceDateString = "2021-10-10 12:00"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        mainLabel.text = "5 days 2 hours"
        guard let raceDate = formatter.date(from: raceDateString) else { return}
        
        let now = Date()
        
        let difference = Calendar.current.dateComponents([.day, .hour], from: now, to: raceDate)
        
        let dayCount = difference.day ?? 0
        let hourCount = difference.hour ?? 0
        
        mainLabel.text = "\(dayCount) days \(hourCount) hours"
        
        
        
        
    }

}


class CustomActivityIndicatorView : UIActivityIndicatorView {
    
    private var animationView = UIView()
    
    private var imageView : UIImageView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pleaseforgiveme()
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        pleaseforgiveme()
    }
    
    private func pleaseforgiveme() {
        
         imageView = UIImageView(image: UIImage(named: "tyre"))
        addSubview(imageView!)
        imageView?.contentMode = .scaleAspectFit
        imageView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView?.layer.cornerRadius = 25
        imageView?.clipsToBounds  = true
        
        addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    
        
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            print("adasd")
            print(self.animationView.bounds)
           
            let path  = UIBezierPath(ovalIn: self.animationView.frame).cgPath
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.path = path
            animation.calculationMode = .paced
            animation.repeatCount = .infinity
            animation.duration = 1
            animation.rotationMode = .rotateAuto
            
            self.imageView?.layer.add(animation, forKey: "keyanim")
        }
        
  
    }
    
    
}


class RaceResultView: UIView, ModelObservable {
    
    
    let tableView = UITableView()
    
    var task = RaceResultTask(request: RaceResultRequest(ayear: "current", round: "1"))
    
    lazy var viewModel: ViewModel = RaceResultViewModel(delegate: self, task: task)
    
    
    var drivers : [OneDriver] = []
    var response : RaceResultResponse?
    
    @RaceMotor var favedRaces : [FavRace]
    
    
    
    var currentItem : FavRace? {
        get {
            if let response = response {
                return FavRace(request: task.request, response: response)
            }
            
            return nil
        }
    }
    
    
    func update(with model: Codable) {
        if let model = model as? RaceResultResponse {
            self.response = model
            self.drivers = model.MRData.RaceTable.Races.first?.Results ?? []
            tableView.reloadData()
        }
       
    }
    
    func addToFav() {
        if let currentItem = currentItem {
            self.favedRaces.append(currentItem)
            
            
            
        }
    }
    
    
    init(task : RaceResultTask ,frame: CGRect) {
        self.task = task
        super.init(frame: frame)
        commonInit()
    }
    
    
    
    required init?(coder: NSCoder) {
       fatalError()
    }
    
    

    private func commonInit() {
        viewModel.delegate = self
        
        tableView.frame = bounds
        insertSubview(tableView, at: 0)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DriverTableViewCell", bundle: nil), forCellReuseIdentifier: "driver")
        
        
        
    }
    
    
    
    

}


extension RaceResultView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        drivers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "driver") as! DriverTableViewCell
        
        let driver = drivers[indexPath.row]
        
        cell.configureCell(with: driver)
        
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    
}


@available(iOS 13.0, *)
class SeasonRacesView: UIView, ModelObservable {
    
    var controller : ViewController?
    
    var task : SeasonRacesTask
    
   lazy var viewModel: ViewModel = SeasonRacesViewModel(delegate: self, task: task)
    
    lazy var raceTask = RaceResultTask(request: RaceResultRequest(ayear: task.request.season, round: "1"))
    
    lazy var raceResultView = RaceResultView(task: raceTask, frame: .zero)
    
    func update(with model: Codable) {
        if let model = model as? SeasonRacesResponse {
            races = model.MRData.RaceTable.Races
            currentRace = races.first
                var actions = [UIAction]()
                for i in races.indices {
                    
                    let action = UIAction(title: races[i].raceName, identifier: UIAction.Identifier("\(i + 1)"), handler: handler)
                    
                    actions.append(action)
                }
                
            if #available(iOS 14.0, *) {
                button.menu = UIMenu(title: "Races",  children: actions)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    

    
    let button = UIButton(type: .system)
    
    let locationButton = UIButton(type: .system)
    
    let favButton = UIButton(type: .system)
    var currentRace : Race?
    var races : [Race] = []
    
    var handler : (UIAction) -> () = {(action : UIAction) in
        
    }
  
    
      
    
    init(task : SeasonRacesTask,frame: CGRect) {
        self.task = task
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder: NSCoder) {
        self.task = SeasonRacesTask(request: SeasonRacesRequest(season: "current"))
        super.init(coder: coder)
        commonInit()
    }
    

    
    @objc func goMap() {
        controller?.location = currentRace?.Circuit.Location
        controller?.goMap()
        print("aaa bbbccc")
    }
    
    
    @objc func addFav() {
        raceResultView.addToFav()
        let alert = UIAlertController(title: "Successful", message: "Race has been add to your favorite races", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "DONE", style: .default, handler: nil)
        
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil)
    }
    
    private func commonInit() {
        viewModel.delegate = self
        self.handler = {(action : UIAction) in
            let round  = action.identifier.rawValue
            let index = (Int(action.identifier.rawValue) ?? 0) - 1
            self.currentRace = self.races[index]
            self.raceTask = RaceResultTask(request: RaceResultRequest(ayear: self.task.request.season, round: round))
            
            self.raceResultView.viewModel.fetchData(with: self.raceTask)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            button.showsMenuAsPrimaryAction = true
            button.changesSelectionAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
        }
       
        
//        let closure = { (action : UIAction) in
//
//
//        }
//
//        let menus = UIMenu(title: "Race", children: [UIAction(title: ,  handler: )])
        
        insertSubview(button, at: 0)
        
        button.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        button.tintColor = .systemPink
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.gray()
            configuration.cornerStyle = .capsule
            
            
            configuration.title = "LAST RACE"
            configuration.image = UIImage(systemName: "chevron.down")
            configuration.imagePadding = 8
            configuration.buttonSize = .mini
            
         
            
            button.configuration = configuration
        } else {
            // Fallback on earlier versions
        }
     
        
       
        
        insertSubview(raceResultView, at: 0)
        raceResultView.translatesAutoresizingMaskIntoConstraints = false
        
        raceResultView.topAnchor.constraint(equalTo: button.bottomAnchor, constant : 16).isActive = true
        raceResultView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        raceResultView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        raceResultView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        
        if #available(iOS 15.0, *) {
            var locconfiguration  = UIButton.Configuration.tinted()
            locconfiguration.cornerStyle = .capsule
            
          
            var container = AttributeContainer()
            container.font = UIFont.systemFont(ofSize: 10, weight: .light)
            // 1
            locconfiguration.attributedTitle = AttributedString("Circuit\nLocation", attributes: container)
            
            insertSubview(locationButton, at: 0)
            locationButton.translatesAutoresizingMaskIntoConstraints = false
            
            locationButton.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            locationButton.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
            locationButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            locationButton.leftAnchor.constraint(equalTo: button.rightAnchor, constant: 16).isActive = true
            
            locconfiguration.image = UIImage(systemName: "mappin")
            locconfiguration.imagePadding = 4
            locationButton.configuration = locconfiguration
            locationButton.tintColor = .systemMint
            
            locationButton.addTarget(self, action: #selector(goMap), for: .touchUpInside)
            
            
            var favConfiguration = locconfiguration
           
            favConfiguration.attributedTitle = AttributedString("Add to\nFavorites", attributes: container)
            favConfiguration.image = UIImage(systemName: "heart.fill")
            
            insertSubview(favButton, at: 0)
            favButton.translatesAutoresizingMaskIntoConstraints = false
            
            favButton.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            favButton.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
            favButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            favButton.rightAnchor.constraint(equalTo: button.leftAnchor, constant: -16).isActive = true
            favButton.tintColor = .systemPink
            
            favButton.configuration = favConfiguration
            
            
            favButton.addTarget(self, action: #selector(addFav), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        
        
    
        
        
    }
}


class ConstructorStandingsView: UIView, ModelObservable {
    
    var task : ConstructorTask
    
   lazy var viewModel: ViewModel = ConstructorStandingsViewModel(delegate: self, task: task)
    
    var list : [ConstructorRow] = []
    
    func update(with model: Codable) {
        if let model = model as? ConstructorStandingResponse {
            list = model.MRData.StandingsTable.StandingsLists.first?.ConstructorStandings ?? []
            
            tableView.reloadData()
        }
    }
    

    let tableView =  UITableView()
    
    init(task : ConstructorTask,frame: CGRect) {
        self.task = task
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        self.task = ConstructorTask(request: ConstructorStandingRequest(season: "current"))
        super.init(coder: coder)
        commonInit()
    }
    
    
    
    private func commonInit() {
        viewModel.delegate = self
        tableView.frame = bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(tableView, at: 0)
        tableView.register(UINib(nibName: "DriverTableViewCell", bundle: nil), forCellReuseIdentifier: "driver")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    

}


extension ConstructorStandingsView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "driver") as! DriverTableViewCell
        
        
        let constructor = list[indexPath.row]
        
        cell.configureCell(with: constructor)
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    
    
}


class DriverTableViewCell: UITableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var givenNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var constructorNameLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var teamColorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numLabel.layer.cornerRadius = 8
        numLabel.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(with driver : DriverRow) {
        numberLabel.text = driver.positionText
        givenNameLabel.text = driver.Driver.givenName
        familyNameLabel.text = driver.Driver.familyName.uppercased()
        constructorNameLabel.text = driver.Constructors.first?.name ?? ""
        numLabel.text = driver.points
        teamColorImageView.tintColor = driver.Constructors.first?.color
    }
    
    
    func configureCell(with constructor : ConstructorRow) {
        numberLabel.text = constructor.positionText
        familyNameLabel.text = constructor.Constructor.name.uppercased()
        givenNameLabel.text = ""
        constructorNameLabel.text = "\(constructor.wins) wins"
        numLabel.text = constructor.points
        teamColorImageView.tintColor = constructor.Constructor.color
    }
    
    func configureCell(with driver : OneDriver) {
        numberLabel.text = driver.positionText
        givenNameLabel.text = driver.Driver.givenName
        familyNameLabel.text = driver.Driver.familyName.uppercased()
        constructorNameLabel.text = driver.Constructor.name
        numLabel.text = driver.points
        teamColorImageView.tintColor = driver.Constructor.color
    }
    
}
