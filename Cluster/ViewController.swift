//
//  ViewController.swift
//  Markers
//
//  Created by Subodh on 26/08/19.
//  Copyright © 2019 Subodh. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    var allTolls = [Toll]() {
        didSet {
        }
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllTolls()
    }
    
    private func getAllTolls() {
        guard let path = Bundle.main.path(forResource: "masterdata", ofType: "json") else {return}
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            guard let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: AnyObject] else { return }
            
            guard let result = jsonResult["result"] as? [[String: AnyObject]] else { return }
            
            let tolls = result.map {Toll(object: $0)}
            self.allTolls = tolls
            self.addClusters()
            
        } catch {
            // handle error
        }
    }
    
   // let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [ 9, 50, 100, 200, 500 ], backgroundImages: [UIImage.init(named: "clustericon2")!,UIImage.init(named: "clustericon3")!,UIImage.init(named: "clustericon3")!,UIImage.init(named: "clustericon3")!,UIImage.init(named: "clustericon3")!])


    private func addClusters() {
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [ 9,10,100, 200, 500 ], backgroundImages: [UIImage.init(named: "clustericon1")!,UIImage.init(named: "clustericon2")!,UIImage.init(named: "clustericon3")!,UIImage.init(named: "clustericon3")!,UIImage.init(named: "clustericon3")!])
            let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
            let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
            renderer.delegate = self
            clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
            self.enumerateAllTolls()
            clusterManager.cluster()
            clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    private func enumerateAllTolls() {
        for toll in self.allTolls {
            let cd = CLLocationCoordinate2DMake(toll.latitude, toll.longitude)
            let markerView = self.createTollMarker((toll.name ?? "Toll"))
            let marker = self.mapView.createMarker(markerView)
            let item = POIItem.init(position: cd, marker: marker, userData: toll)
            clusterManager.add(item)
        }
        self.mapView.animate(to: GMSCameraPosition(latitude: 19.0361, longitude: 72.8172, zoom: 9.25))
    }
}

extension ViewController:GMUClusterManagerDelegate {
    // MARK: - GMUClusterManagerDelegate
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
        return false
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(String(describing: poiItem.userData))")
        } else {
            NSLog("Did tap a normal marker")
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        clusterManager.clearItems()
    }
}

/// Point of Interest Item which implements the GMUClusterItem protocol.
class POIItem: NSObject, GMUClusterItem {
    @objc var marker: GMSMarker!
    var position: CLLocationCoordinate2D
    var userData: Toll!
    
    init(position: CLLocationCoordinate2D, marker: GMSMarker, userData: Toll) {
        self.position = position
        self.marker = marker
        self.userData = userData
    }
}

extension ViewController: GMUClusterRendererDelegate {
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {

        if let clusterItem = object as? POIItem {
            print("Avaneesh POIItem \(clusterItem)")
            return clusterItem.marker
        } else {
            print("Avaneesh object \(object)")
            //return clusterItem.marker
            return nil
        }
        return nil

    }
    
    func renderer(_ renderer: GMUClusterRenderer, didRenderMarker marker: GMSMarker) {
    }
}

