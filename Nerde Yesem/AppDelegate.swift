//
//  AppDelegate.swift
//  Nerde Yesem
//
//  Created by umur yavuz on 28.06.2019.
//  Copyright © 2019 umur yavuz. All rights reserved.
//

import UIKit
import Moya
import CoreLocation
import LocalAuthentication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationServices = LocationService()
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let service = MoyaProvider<YelpService.BusinessesProvider>()
    var location : CLLocation?
    let jsonDecoder = JSONDecoder()
    var navController : UINavigationController!
    var login: Bool = false

    func applicationDidBecomeActive(_ application: UIApplication) {
        if login{
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            switch locationServices.status {
            case .notDetermined, .denied, .restricted:
                locationServices.requestLocationAuthorization()
                getLocation()
            default:
                getLocation()
                let nav = storyBoard.instantiateViewController(withIdentifier: "RestaurantNavigationController") as? UINavigationController
                window?.rootViewController = nav
                self.navController = nav
                (nav?.topViewController as? RestaurantTableViewController)?.delegate = self
            }
            window?.makeKeyAndVisible()
        }else{
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let initnav = storyBoard.instantiateViewController(withIdentifier: "Login") as? LoginViewController
        self.window?.rootViewController = initnav
        self.window?.makeKeyAndVisible()
        
        return true
        
        
    }
    
    func loginWithTouchID() -> Bool{
        let context : LAContext = LAContext()
        var res = false
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please login with your Touch ID to see restaurants", reply: {(result, failure) in
                if result{
                    res = true
                    self.login = true
                }
                if (failure != nil){
                    res = false
                    self.login = false
                    print(failure?.localizedDescription ?? "Failed to authenticate")
                }
            })
        }else{
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Please enter your password to see restaurants because too many false Touch ID attempt occured", reply: {(r,f) in
                if r{
                    res = true
                    self.login = true
                }
                if (f != nil){
                    res = false
                    self.login = false
                }
            })
        }
        
        return res
    }
    
    func getLocation(){
        self.locationServices.getLocation()
        locationServices.newLocation = {[weak self] result in
            switch result{
            case .success(let location):
                self?.location = location
                self?.loadRestaurants(location: location)
            case .failure(let error):
                assertionFailure("Error \(error)")
            }}
        
    }
    
    func loadRestaurants(location : CLLocation){
        self.service.request(.search(lat: location.coordinate.latitude, long: location.coordinate.longitude), completion: {(result) in
            switch result{
            case .success(let response):
                let root = try? self.jsonDecoder.decode(Root.self, from: response.data)
                let viewModel = root?.businesses
                    .compactMap(RestaurantListViewModel.init)
                    .sorted(by: { $0.distance < $1.distance})
                if let nav = self.window?.rootViewController as? UINavigationController,
                    let restaurantsListViewController = nav.topViewController as? RestaurantTableViewController {
                    restaurantsListViewController.viewModels = viewModel ?? []
                }
                print(root)
                break
            case .failure(let error):
                print("Error \(error)")
                break
            }
        })
    }
    
    func loadRestaurantDetails(id : String){
        self.service.request(.details(id: id), completion: {[weak self](result) in
            switch result{
            case .success(let response):
                guard let sSelf = self else {return}
                if let details = try? sSelf.jsonDecoder.decode(Details.self, from: response.data){
                    let detailsVM = DetailsViewModel.init(details: details)
                    (sSelf.navController?.topViewController as? RestaurantDetailsViewController)?.viewModel = detailsVM
                }
            case .failure(let error):
                assertionFailure("Error \(error)")
            }
        })
    }
}

extension AppDelegate: ListActions{
    func didTapCell(_ viewModel: RestaurantListViewModel) {
        loadRestaurantDetails(id: viewModel.id)
    }
}

