//
//  DriverStandings.swift
//  SpeedHub
//
//  Created by MacMini on 3.10.2021.
//

import Foundation
import UIKit

protocol MyTask : Codable {
    
    associatedtype Response : Codable
    associatedtype Request : Codable

    var request : Request { get set}
    
    var url : URL? { get }
    
}


extension MyTask {
    
    var url : URL? {
        get {
            do {
                let data = try JSONEncoder().encode(self.request)
                guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                    return nil
                }
                var str = baseURL.absoluteString
                var keys = dictionary.map({ $0.key})
                
                keys.sort()
                
               
                
                for i in keys {
                    str.append("/\(dictionary[i] ?? "")")
                }
                
                
                str.append(".json")
                return URL(string: str)
            
            } catch let error {
                print(error)
                return nil
            }
            
            
        }
    }
}

struct DriverStandingRequest :  Codable {
    
    let season : String
    let zname : String = "driverStandings"
    
    
    
}

struct DriverStandingResponse : Codable {
    let MRData : MRDataDriverStandings
}


struct MRDataDriverStandings : Codable {
    let StandingsTable : DriverStandingList
}
struct DriverStandingList : Codable {

    let StandingsLists : [DriverStanding]
}
struct DriverStanding :  Codable {
    
    let DriverStandings : [DriverRow]
}

struct DriverRow : Codable , Hashable {
    let positionText : String
    let points : String
    let wins : String
    let Driver : Driver
    let Constructors : [Constructor]
}

struct Driver : Codable , Hashable {
    let givenName, familyName, dateOfBirth : String
}

struct Constructor : Codable, Hashable {
    let name, nationality : String
    
    var color : UIColor {
        switch name {
        case "Mercedes":
            return UIColor(red: 0/255, green: 210/255, blue: 150/255, alpha: 1)
        case "Red Bull":
            return UIColor(red: 6/255, green: 0/255, blue: 239/255, alpha: 1)
        case "McLaren":
            return UIColor(red: 255/255, green: 135/255, blue: 0/255, alpha: 1)
        case "Ferrari":
            return UIColor(red: 220/255, green: 0/255, blue: 0/255, alpha: 1)
        case "Alpine F1 Team":
            return UIColor(red: 0/255, green: 144/255, blue: 255/255, alpha: 1)
        case "AlphaTauri" :
            return UIColor(red: 43/255, green: 69/255, blue: 98/255, alpha: 1)
        case "Aston Martin" :
            return UIColor(red: 0/255, green: 111/255, blue: 98/255, alpha: 1)
        case "Williams" :
            return UIColor(red: 0/255, green: 90/255, blue: 255/255, alpha: 1)
        case "Alfa Romeo" :
            return UIColor(red: 144/255, green: 0/255, blue: 0/255, alpha: 1)
        case "Haas F1 Team" :
            if #available(iOS 13.0, *) {
                return UIColor.systemGray6
            } else {
                return UIColor.lightGray
                // Fallback on earlier versions
            }
            
            
        default :
          return  UIColor.darkGray
        }
    }
}





struct DriverStandingTask : MyTask {
    
    var request: DriverStandingRequest
    
    typealias Response = DriverStandingResponse
    
    typealias Request = DriverStandingRequest
    
    
    
}



struct FavRace : Codable {
    let request : RaceResultRequest
    let response  : RaceResultResponse
}


@propertyWrapper struct RaceMotor {
    
    let raceURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("races").appendingPathExtension("plist")
    
    let decoder = PropertyListDecoder()
    let encoder = PropertyListEncoder()
    
    var wrappedValue : [FavRace] {
        
        get {
            if let data = try? Data(contentsOf: raceURL) {
                return try! decoder.decode([FavRace].self, from: data)
            }
            
            return []
        }
        
        set {
            let data = try! encoder.encode(newValue)
            try! data.write(to: raceURL)
        }
    }
}


struct RaceResultRequest : Codable {
    let ayear, round : String
    let zname = "results"
}


struct RaceResultResponse : Codable {
    let MRData : RaceMRData
}


struct RaceMRData : Codable {
    let RaceTable : OneRaceTable
}

struct OneRaceTable : Codable {
    let Races : [OneRace]
}

struct OneRace : Codable {
    
    let raceName : String
    let Circuit : Circuit
   
    let Results : [OneDriver]
    
    
}


struct OneDriver : Codable {
  
        let positionText : String
        let points : String
        
        let Driver : Driver
        let Constructor : Constructor
 
}

struct RaceResultTask : MyTask {
    var request: RaceResultRequest
    
    typealias Response = RaceResultResponse
    
    typealias Request = RaceResultRequest
    
    
}



struct ConstructorStandingRequest : Codable {
    let season : String
    let zname = "constructorStandings"
}


struct ConstructorStandingResponse : Codable {
    let MRData : CMRData
}


struct CMRData  : Codable {
    let StandingsTable : CStandingsTable
}

struct CStandingsTable : Codable {
    let StandingsLists : [CStandingsList]
}

struct CStandingsList : Codable {
    let ConstructorStandings : [ConstructorRow]
}

struct ConstructorRow : Codable {
    let positionText, points, wins : String
    let Constructor : Constructor
}



struct ConstructorTask : MyTask {
    var request: ConstructorStandingRequest
    
    typealias Response = ConstructorStandingResponse
    
    typealias Request = ConstructorStandingRequest
    
    
}


struct SeasonRacesRequest : Codable {
    let season : String
}



struct SeasonRacesResponse : Codable {
    
    let MRData : SeasonRacesMRData
    
}

struct SeasonRacesMRData : Codable {
    let RaceTable : RaceTable
}

struct RaceTable : Codable {
    let Races : [Race]
}

struct Race : Codable {
    let round, raceName : String
    let Circuit : Circuit
}

struct Circuit : Codable {
    let circuitName  : String
    let Location : Location
    
}

struct Location : Codable {
    let lat, long, locality, country : String
}
struct SeasonRacesTask : MyTask {
    var request: SeasonRacesRequest
    
    typealias Response = SeasonRacesResponse
    
    typealias Request = SeasonRacesRequest
      
}


protocol ModelObservable : UIView {
    var viewModel : ViewModel { get set}
    
    func update(with model : Codable)
}




protocol ViewModel {
    
    var delegate : ModelObservable { get set}
    func fetchData<T: MyTask>(with task : T)
    
    init(delegate : ModelObservable, task : Codable)
}



class DriverStandingsViewModel : ViewModel {
  
    
    var delegate: ModelObservable
    
   
    
    required init(delegate: ModelObservable, task : Codable) {
        self.delegate = delegate
        if let task = task as? DriverStandingTask {
            fetchData(with: task)
        }
        
    }
    

    
    
    func fetchData<T>(with task: T) where T : MyTask {
        let manager = NetworkManager(populatedView: delegate)
        
        manager.commence(task: task) { result in
            switch result {
            case .success(let model) :
                DispatchQueue.main.async {
                    self.delegate.update(with: model)
                }
            case .failure(let error) :
                print(error)
            }
        }
        
    }
    
    
    
    
    
    
}

class RaceResultViewModel : ViewModel {
    var delegate: ModelObservable
    
  
    
    required init(delegate: ModelObservable, task: Codable) {
        self.delegate = delegate
        if let task = task as? RaceResultTask {
            fetchData(with: task)
        }
        
    }
    
    func fetchData<T>(with task: T) where T : MyTask {
        
        let manager = NetworkManager(populatedView: delegate)
        manager.commence(task: task) { result in
            switch result {
                
            case .success(let model):
                DispatchQueue.main.async {
                    self.delegate.update(with: model)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}


class SeasonRacesViewModel : ViewModel {

    
    var delegate: ModelObservable
    
    
   
 
    
    required init(delegate: ModelObservable, task : Codable) {
        
        self.delegate = delegate
        
        if let task = task as? SeasonRacesTask {
            fetchData(with: task)
        }
    }
    
    func fetchData<T>(with task: T) where T : MyTask {
        let manager = NetworkManager(populatedView: delegate)
        
        manager.commence(task: task) { result in
            switch result {
            case .success(let model) :
                DispatchQueue.main.async {
                    self.delegate.update(with: model)
                }
              
            case .failure(let error) :
                print(error)
            }
        }
        
    }
    
    
    
    
}




class ConstructorStandingsViewModel : ViewModel {
    var delegate: ModelObservable
  
  
    
    required init(delegate: ModelObservable, task : Codable) {
        self.delegate = delegate
     
        if let task = task as? ConstructorTask {
            fetchData(with: task)
        }
        
    }
    
    
    
    func fetchData<T>(with task: T) where T : MyTask {
        let manager = NetworkManager(populatedView: delegate)
        
        manager.commence(task: task) { result in
            switch result {
            case .success(let model) :
                DispatchQueue.main.async {
                    self.delegate.update(with: model)
                }
                
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    
}
