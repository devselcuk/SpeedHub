//
//  ViewController.swift
//  SpeedHub
//
//  Created by MacMini on 3.10.2021.
//

import UIKit

@available(iOS 13.0, *)
class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    var year = "current"
    
    var location : Location?
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "map" {
            let vc = segue.destination as! MapViewController
            vc.location = location
        }
    }
    
    func goMap() {
        performSegue(withIdentifier: "map", sender: Any.self)
    }
    
    var driversView = DriverStandingsView(task: DriverStandingTask(request: DriverStandingRequest(season: "current")), frame: .zero)
    var constructorView = ConstructorStandingsView(task: ConstructorTask(request: ConstructorStandingRequest(season: "current")), frame: .zero)
    var racesView = SeasonRacesView(task: SeasonRacesTask(request: SeasonRacesRequest(season: "current")), frame: .zero)
    
    
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        for i in views {
            i.isHidden = true
            i.alpha = 0
        }
        
        UIView.animate(withDuration: 0.5) {
            self.views[sender.selectedSegmentIndex].isHidden = false
            self.views[sender.selectedSegmentIndex].alpha = 1
        }
        
    }
    
    var views : [UIView] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        driversView = DriverStandingsView(task: DriverStandingTask(request: DriverStandingRequest(season: self.year)), frame: .zero)
        constructorView = ConstructorStandingsView(task: ConstructorTask(request: ConstructorStandingRequest(season: self.year)), frame: .zero)
        racesView = SeasonRacesView(task: SeasonRacesTask(request: SeasonRacesRequest(season: self.year)), frame: .zero)
        racesView.controller = self
        driversView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        driversView.frame = containerView.bounds
        containerView.addSubview(driversView)
        
        constructorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        constructorView.frame = containerView.bounds
        containerView.addSubview(constructorView)
        constructorView.isHidden = true
        
        racesView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        racesView.frame = containerView.bounds
        containerView.addSubview(racesView)
        racesView.isHidden = true
        
          views = [driversView, constructorView,racesView]
        
        
        titleLabel.text = "Standings - \(year) season"
        }
        // Do any additional setup after loading the view.



}


import UIKit

class AllSeasonsViewController: UIViewController {
    
    
    
    var seasons : [String] = []
    
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let years = Array(1950...2021)
        seasons = years.map({ "\($0)"})
        // Do any additional setup after loading the view.
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromseason" {
            if #available(iOS 13.0, *) {
                let vc = segue.destination as! ViewController
                vc.year = seasons[index]
            } else {
                // Fallback on earlier versions
            }
           
        }
    }


}

extension AllSeasonsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "season")!
        
        cell.textLabel?.text = seasons[indexPath.row]
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "fromseason", sender: Any.self)
    }
    
    
    
    
    
    
}




class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var listContainerView: UIView!
    
    var request  : RaceResultRequest?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let request = request {
            let raceResultView = RaceResultView(task: RaceResultTask(request: request), frame: listContainerView.bounds)
            raceResultView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            listContainerView.addSubview(raceResultView)
        }
       

        // Do any additional setup after loading the view.
    }
    



}


class MyFavoritesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @RaceMotor var favRaces : [FavRace]
    
    
    var request : RaceResultRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(favRaces)
        
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let vc = segue.destination as! DetailViewController
            if #available(iOS 15.0, *) {
                if let x = vc.sheetPresentationController {
                    x.detents = [.medium()]
                }
            } else {
                // Fallback on earlier versions
            }
            vc.request = self.request
        }
    }
    
}


extension MyFavoritesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favRaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fav")!
        
        cell.textLabel?.text = favRaces[indexPath.row].response.MRData.RaceTable.Races.first?.raceName ?? ""
        
        cell.detailTextLabel?.text = favRaces[indexPath.row].request.ayear
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.request = favRaces[indexPath.row].request
        
        self.performSegue(withIdentifier: "detail", sender: Any.self)
    }
    
}


import MapKit


class MapViewController: UIViewController {

    @IBOutlet weak var centerView: UIView!
    
    let mapView = MKMapView()
    
    var location : Location?
    
    @IBOutlet weak var closeButton: UIButton!
    
    var coordinate : CLLocationCoordinate2D? {
        get {
            if let location = location {
                return CLLocationCoordinate2D(latitude: Double(location.lat) ?? 0, longitude: Double(location.long) ?? 0)
            } else {
                return nil
            }
           
        }
        
    }
    

    
    @IBAction func dissMap(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        centerView.layer.cornerRadius = 16
        centerView.clipsToBounds = true
        
        closeButton.layer.cornerRadius = 15
        
        mapView.frame = centerView.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        centerView.addSubview(mapView)
        mapView.mapType = .hybrid
        
        
        let pointAnnotation = MKPointAnnotation()
        
        if let coordinate = coordinate {
            pointAnnotation.coordinate = coordinate
            
            mapView.addAnnotation(pointAnnotation)
            
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: false)
        }
       
        
        // Do any additional setup after loading the view.
    }
    


}


class HomeViewController: UIViewController {
   
    @IBOutlet weak var histButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        histButton.layer.cornerRadius = 13

        // Do any additional setup after loading the view.
    }
    
    var year = "current"
    
    @IBAction func goToSeason(_ sender: UIButton) {
        self.year = "\(sender.tag)"
        performSegue(withIdentifier: "year", sender: Any.self)
     
                                                 
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "year" {
            if #available(iOS 13.0, *) {
                let vc = segue.destination as! ViewController
                vc.year = self.year
            } else {
                // Fallback on earlier versions
            }
            
         
            
        }
    }
    
    
    @IBAction func goHistory(_ sender: Any) {
        tabBarController?.selectedViewController  = tabBarController!.viewControllers![2]
    }
    
    @IBAction func goAll(_ sender: Any) {
        tabBarController?.selectedViewController  = tabBarController!.viewControllers![1]
    }
    
}
