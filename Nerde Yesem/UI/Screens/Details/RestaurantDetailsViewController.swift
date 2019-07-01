//
//  RestaurantDetailsViewController.swift
//  Nerde Yesem
//
//  Created by umur yavuz on 28.06.2019.
//  Copyright © 2019 umur yavuz. All rights reserved.
//

import UIKit
import MapKit
import AlamofireImage

class RestaurantDetailsViewController: UIViewController {
    @IBOutlet weak var detailsRestaurantView: DetailRestaurantView!
    
    var viewModel: DetailsViewModel?{
        didSet{
              updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        detailsRestaurantView?.collectionView?.register(RestaurantCell.self, forCellWithReuseIdentifier: "ImageCell")
        detailsRestaurantView?.collectionView?.dataSource = self
        detailsRestaurantView?.collectionView?.delegate = self
    }
    

    func updateView(){
        if let vm = viewModel{
            self.navigationItem.title = vm.name
            detailsRestaurantView?.lbl_hours.text = vm.isOpen
            detailsRestaurantView?.lbl_price.text = vm.price
            detailsRestaurantView?.lbl_ratings.text = vm.rating
            detailsRestaurantView?.lbl_location.text = vm.phoneNumber
            detailsRestaurantView?.collectionView.reloadData()
            centerMap(for: viewModel!.coordinate)
        }
    }
    
    func centerMap(for coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        detailsRestaurantView?.mapView?.addAnnotation(annotation)
        detailsRestaurantView?.mapView?.setRegion(region, animated: true)
    }

}

extension RestaurantDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.imageUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! RestaurantCell
        if let url = viewModel?.imageUrls[indexPath.item] {
            cell.imageView.af_setImage(withURL: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        detailsRestaurantView?.pageController?.currentPage = indexPath.item
    }
}

