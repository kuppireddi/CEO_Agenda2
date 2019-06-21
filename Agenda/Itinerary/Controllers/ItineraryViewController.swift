//
//  ItineraryViewController.swift
//  Agenda
//
//  Created by Ankush jain on 13/06/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import UIKit
import SPStorkController

struct ExecutiveItinerary {
    var imageName: String
    var executiveName: String
    var domesticPdfName: String
    var internationalPdfName: String
}

class ItineraryViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    var itineraries = [ExecutiveItinerary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeModels()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initializeModels() {
        let executive1 = ExecutiveItinerary(imageName: "Miller", executiveName: "Paul Miller", domesticPdfName: "Itinerary_MILLER_PAUL_YKSOHF_domestic", internationalPdfName: "Itinerary_MILLER_PAUL_NBHMHR_international")
        let executive2 = ExecutiveItinerary(imageName: "", executiveName: "Michael Black", domesticPdfName: "Itinerary_BLACK_MICHAEL_WDKJNQ_domestic", internationalPdfName: "Itinerary_BLACK_MICHAEL_WDKJNQ_international")
        
        itineraries = [executive1, executive2]
    }

}


//MARK: UITableViewDataSource Methods
extension ItineraryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itineraries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItineraryTableViewCell", for: indexPath) as? ItineraryTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let itinerary = itineraries[indexPath.row]
        cell.populate(itinerary)
        
        return cell
    }
}

extension ItineraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showItinerary(indexPath)
    }
    
    func showItinerary(_ indexPath: IndexPath) {
        let infoDetailsVC = UIStoryboard(name: "Info", bundle: nil).instantiateViewController(withIdentifier: "InfoDetailViewController") as? InfoDetailViewController
        if let infoDetailsVC = infoDetailsVC {
            infoDetailsVC.itinerary = itineraries[indexPath.row]
            presentAsStork(infoDetailsVC)
            //navigationController?.pushViewController(infoDetailsVC, animated: true)
        }
    }
}
