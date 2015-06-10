//
//  VCMapView.swift
//  SpotDemoMap
//
//  Created by Nick Brandaleone on 6/8/15.
//  Copyright (c) 2015 Nick Brandaleone. All rights reserved.
//

/*
I use an extension so as to not clutter up the main VC file.
These are the MapView Delegate method implementations.
*/

import MapKit

extension ViewController : MKMapViewDelegate {
    
    // This method gets called every time you add an annotation to the map
    // Each annotation must have a title, subtitle and coordinate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if let annotation = annotation as? ParkingSpot {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            
            view.pinColor = annotation.pinColor()
            return view
        }
        return nil  // if annotation is not a ParkingSpot
    }
    
    // This method is called when the callout button is pushed
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
        calloutAccessoryControlTapped control: UIControl!) {
            
            let location = view.annotation as! ParkingSpot
            
            // The app must ignore clicks when the spot is unavailable. Perhaps remove callout icon entirely?
            if location.category == ParkingCategory.Closed { return }
            
            // launch action sheet. I will create an e-commerce transction in future (Stripe?)
            let optionMenu = UIAlertController(title: "Rent parking spot", message: "Choose Option", preferredStyle: .ActionSheet)
            
            let amexAction = UIAlertAction(title: "Amex", style: .Default, handler:
                {(alert: UIAlertAction!) -> Void in
                    println("process AMEX transaction")
            })
            let mastercardAction = UIAlertAction(title: "MasterCard", style: .Default, handler: {(alert: UIAlertAction!) -> Void in
                println("process MasterCard transaction")
            })
            let paypalAction = UIAlertAction(title: "PayPal", style: .Default, handler: {(alert: UIAlertAction!) -> Void in
                println("process PayPal transaction")
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(alert: UIAlertAction!) -> Void in
                println("E-commerce transaction cancelled")
            })
            
            // Add actions to ActionSheet
            optionMenu.addAction(amexAction)
            optionMenu.addAction(mastercardAction)
            optionMenu.addAction(paypalAction)
            optionMenu.addAction(cancelAction)
            
            // Show ActionSheet
            self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
}