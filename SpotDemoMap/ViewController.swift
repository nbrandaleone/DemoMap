//
//  ViewController.swift
//  SpotDemoMap
//
//  Created by Nick Brandaleone on 6/8/15.
//  Copyright (c) 2015 Nick Brandaleone. All rights reserved.
//

/* This is the primary screen.  It has been split into 2 views, the Map on top showing available parking spots,
    and the table view with details below.  Clicking on the pins will allow for summary detail, and e-commerce transactions.
    I have skipped the complexity of choosing date/times, which must be addressed.

    UX Candy: The mapView can expand or contact its frame size depending on user interaction.
        Perhaps more advanced UITapGestureRecognizer in the future?

    TODO: Add AutoLayout Constraints to handle rotations and other devices. Built for iPhone 6

    REVIEW: Potential concern with large amount of data on map.  Check out fascinating post:
        https://robots.thoughtbot.com/how-to-handle-large-amounts-of-data-on-maps
*/


import UIKit
import MapKit

private let kTableHeaderHeight: CGFloat = 320.0

class ViewController: UITableViewController, UIScrollViewDelegate, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var isShutterOpen: Bool = false     // tracks whether the MapView is fully open (true) or normal size (false)
    
    /* Dummy mock data */
    var items = [
        ParkingSpot(category: .Open, summary: "$20 per day. Near downtown.",
            coordinate: CLLocationCoordinate2D(latitude: 42.355535, longitude: -71.061105)),
        ParkingSpot(category: .Closed, summary: "$100 per week. Walking distance to T.",
            coordinate: CLLocationCoordinate2D(latitude: 42.354853, longitude: -71.061770)),
        ParkingSpot(category: .Closed, summary: "$35 per day. In Financial District.",
            coordinate: CLLocationCoordinate2D(latitude: 42.356552, longitude: -71.061639)),
        ParkingSpot(category: .Open, summary: "$35 per day. Two day minimum.",
            coordinate: CLLocationCoordinate2D(latitude: 42.355295, longitude: -71.062642)),
        ParkingSpot(category: .Open, summary: "$125 per week. Great restaurants nearby.",
            coordinate: CLLocationCoordinate2D(latitude: 42.355275, longitude: -71.061015))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up tableView height
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Use the header view screen real-estate, so we can manipulate it as a MapView
        tableView.tableHeaderView = nil
        mapView = MKMapView(frame: CGRectMake(0, -kTableHeaderHeight,
            tableView.frame.size.width, kTableHeaderHeight))
        tableView.addSubview(mapView)
        
        mapView.delegate = self // Delegate methods in VCMapView file
        
        // zoom into rectangle with ParkingSpot items
        let rectToDisplay = self.items.reduce(MKMapRectNull) {
            (mapRect: MKMapRect, spot: ParkingSpot) -> MKMapRect in
            let parkingPointRect = MKMapRect(origin: MKMapPointForCoordinate(spot.coordinate),
                size: MKMapSize(width: 0, height: 0))
            return MKMapRectUnion(mapRect, parkingPointRect)
        }
        
        // Add 1 more entry for demo purposes
        items.append(ParkingSpot(category: .Open, summary: "$400 per month. Walking distance to Harvard.",
            coordinate: CLLocationCoordinate2D(latitude: 42.369727, longitude: -71.115200)))
        
        // Put all parking spots on the map
        mapView.addAnnotations(items)
        
        // Change the content inset/offset of the tableView
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        
        // Display zoomed rect with some padding, so pins show nicely at edges
        mapView.setVisibleMapRect(rectToDisplay, edgePadding: UIEdgeInsetsMake(25, 25, 25, 25), animated: true)
    }
    
    // Tracks when the user scrolls the views
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // We are interested only if scrollView is from the TableView
        if scrollView is UITableView {
        
            // User is pulling down on on the TableView. Snaps the MapView to cover the entire sceen
            if tableView.contentOffset.y < -kTableHeaderHeight && isShutterOpen == false {
                
                UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
                    self.tableView.contentInset.top = 2 * kTableHeaderHeight
                    self.mapView.frame = CGRectMake(0, -2 * kTableHeaderHeight, self.tableView.frame.size.width, 2 * kTableHeaderHeight)
                    self.tableView.contentOffset = CGPoint(x: 0, y: -2 * kTableHeaderHeight)
                    }, completion: {_ in self.isShutterOpen = true})
                
                // Add a new table entry to be used to reset the View back to normal size
                self.items.insert(ParkingSpot(category: .Reset, summary: "Click to reset map and table",
                coordinate: CLLocationCoordinate2D(latitude: 42.0, longitude: -71.0)), atIndex: 0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View functions
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        
        // It is not necessary to have the typical optional binding, as we have set the reuse identifier in IB.
        // This will create a new cell if nil is returned
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ParkingItemCell
        cell.parkingItem = item
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
 
    // Check for "reset" to put the views back to normal size
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 && self.isShutterOpen == true {
            UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
                self.tableView.contentInset.top = kTableHeaderHeight
                self.mapView.frame = CGRectMake(0, -kTableHeaderHeight, self.tableView.frame.size.width, kTableHeaderHeight)
                self.tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
                }, completion: {_ in self.isShutterOpen = false})
            
            // remove "reset" table entry. As it is possible to have multiple reset entries, we will filter items array.
            let newItems = items.filter({$0.category != ParkingCategory.Reset})
            self.items = newItems
            self.tableView.reloadData()
        }
        
        // Have the map zoom to the location specified in the table
        if self.isShutterOpen == false {
            let parkingRegion = MKCoordinateRegionMakeWithDistance(items[indexPath.row].coordinate, 50, 50)   // 50 meters on a side
            mapView.setRegion(parkingRegion, animated: true)
        }
    }
}


