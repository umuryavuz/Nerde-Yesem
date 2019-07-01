//
//  File.swift
//  Nerde Yesem
//
//  Created by umur yavuz on 28.06.2019.
//  Copyright © 2019 umur yavuz. All rights reserved.
//

import UIKit
import MapKit

@IBDesignable class DetailRestaurantView : BaseView{
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var pageController : UIPageControl!
    @IBOutlet weak var lbl_price : UILabel!
    @IBOutlet weak var lbl_hours : UILabel!
    @IBOutlet weak var lbl_ratings : UILabel!
    @IBOutlet weak var lbl_location : UILabel!
    @IBOutlet weak var mapView : MKMapView!
    
    @IBAction func handleControl(_ sender: UIPageControl) {
        
    }
    
}
