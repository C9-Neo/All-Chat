//
//  MapViewController.swift
//  ChatFirebase_TypeA
//
//  Created by UWICIIT-Admin on 2020/5/8.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func addPin(_ sender: UIButton) {
        addPinAlert()
    }
    let locationManager = CLLocationManager()
    let regioninMeters : Double = 10000
            


            override func viewDidLoad() {
                super.viewDidLoad()
                
                checkLocationServices()

            }
            

            // initializes the location manager
            func setUpLocationManager(){
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
            }
             
            //check if location service is turned on or off
             func checkLocationServices() {
               if CLLocationManager.locationServicesEnabled() {
                setUpLocationManager()
                checkLocationAuthorization()
                locationManager.startUpdatingLocation()
                
                let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
                longpress.minimumPressDuration = 1.0
                mapView.addGestureRecognizer(longpress)
               
                
               } else {
                 // Show alert letting the user know they have to turn this on.
               }
             }
            @objc func longPressRemove(gestureRecognizer: UILongPressGestureRecognizer) {
                
               let touchPoint = gestureRecognizer.location(in: mapView)
               let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
               let annotation = MKPointAnnotation()
               annotation.coordinate = newCoordinates
               
                mapView.removeAnnotations(mapView.annotations)
            }
    
            func addPinAlert(){
                
                let alert = UIAlertController(title: "Add Pin", message: "Please paste pin combination", preferredStyle: .alert)
                alert.addTextField{(textField) in textField.text = " "}
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in}))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert](_) in
                    let pin = MKPointAnnotation()
                    let textField = alert?.textFields![0]
                    if textField?.text != " "{
                    let components = textField!.text!.components(separatedBy: "/")
                    if components.count == 3{
                        pin.title = components[0]
                        pin.coordinate = CLLocationCoordinate2D(latitude: Double(components[1])!, longitude: Double(components[2])!)
                    }else{ pin.coordinate = CLLocationCoordinate2D(latitude: Double(components[0])!, longitude: Double(components[1])!)}}
                    
                    self.mapView.addAnnotation(pin)
                }))
                self.present(alert, animated: true, completion: nil)            }
    
    
            
            
            // creates alert to get title and create pin
            func createPin(pin : MKPointAnnotation, position:CLLocationCoordinate2D ) {
                    var message = ""
                
                
                let alert = UIAlertController(title: "Create Pin", message: "Please enter name of pin", preferredStyle: .alert)
                alert.addTextField{(textField) in textField.text = " "}
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert](_) in
                    let textField = alert?.textFields![0]
                    pin.coordinate = position
                    
                    if textField?.text != " "{
                        pin.title = textField!.text!
                        message = textField!.text! + "/" + String(position.latitude) + "/" + String(position.longitude)
                    }else{ message = String(position.latitude) + "/" + String(position.longitude) }
                    UIPasteboard.general.string = message
                    self.mapView.addAnnotation(pin)
                    self.openMapForPlace(position: position, name: textField!.text!)
                    
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in}))
                self.present(alert, animated: true, completion: nil)
                
            }
    
    func openMapForPlace(position:CLLocationCoordinate2D, name:String) {


                let regionDistance:CLLocationDistance = 10000
                let coordinates = CLLocationCoordinate2DMake(position.latitude, position.longitude)
                let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = name
                mapItem.openInMaps(launchOptions: options)

            }
            
            
            @objc func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
                let touchPoint = gestureRecognizer.location(in: mapView)
                let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                let annotation = MKPointAnnotation()
                
                createPin(pin: annotation, position:newCoordinates)
             }
            
            //centers map on the user location or if nonne can be found a set location
            func centerViewOnUserLocation(){
                
                if let location = locationManager.location?.coordinate{
                
                    let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regioninMeters, longitudinalMeters: regioninMeters)
                    mapView.setRegion(region, animated: true)
                }else{
                    let test = CLLocationCoordinate2D.init(latitude: 51.5549, longitude: -0.108436)
                    let region = MKCoordinateRegion.init(center: test, latitudinalMeters: regioninMeters, longitudinalMeters: regioninMeters)
                    mapView.setRegion(region, animated: true)        }
            }

             
            //Informs the application what is to be done dependent on the permissions
             func checkLocationAuthorization() {
               switch CLLocationManager.authorizationStatus() {
               case .authorizedWhenInUse:
                mapView.showsUserLocation = true
                centerViewOnUserLocation()
               
               case .denied:
                 break
               case .notDetermined:
                 locationManager.requestWhenInUseAuthorization()
               case .restricted:
                 break
               case .authorizedAlways:
                 break
               }
             }
    
    
    
        }


        extension MapViewController : CLLocationManagerDelegate{
            
            //moves the map if the user location moves
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                guard let location = locations.last else{return}
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regioninMeters, longitudinalMeters: regioninMeters)
                mapView.setRegion(region, animated: true)
                
            }
            
            //cecks for permission changes
            func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
                checkLocationAuthorization()
            }
        }

    
    
