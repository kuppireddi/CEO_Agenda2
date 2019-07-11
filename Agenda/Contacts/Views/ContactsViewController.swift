//
//  ContactsViewController.swift
//  Agenda
//
//  Created by Ankush jain on 29/05/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoCollectionView: UICollectionView!
    var callDict: Contact?
    var currentContact: Contact?
    static let collectionViewCellIdentifier = "executivecell"
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromServer()
        configureUI()
    }
    
    func getDataFromServer() {
        
        let spinner = UIActivityIndicatorView(style: .gray)
        let viewBounds: CGRect = view.bounds
        spinner.center = CGPoint(x: viewBounds.midX, y: viewBounds.midY)
        view.addSubview(spinner) // spinner is not visible until started
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        
        let url = URL.init(string: "https://jsonblob.com/api/jsonBlob/74ebe85b-a3bb-11e9-af2c-3b2de1ac30fa")!
        let task = URLSession.shared.callTask(with: url) { call, response, error in
            if let call = call {
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                    self.callDict = call
                    self.logoCollectionView.reloadData()
                    self.logoCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
                    self.configureUI()
                }
            }
        }
        task.resume()
        
    }
    
    //MARK: Helper Methods
    private func configureUI() {
        hideNavigationBar()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        self.currentContact = self.callDict?.filter({
            $0.company == "TCS"
        })
        self.tableView.reloadData()
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: UITableViewDataSource Methods
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let contact = currentContact?.first  {
            return (contact.nameArray.count)
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        cell.nameLbl.text = currentContact?.first?.nameArray[indexPath.row]
        cell.phoneNumberLbl.text = currentContact?.first?.phoneArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let num = currentContact?.first?.callNumberArray[indexPath.row] {
            let telNo = "telprompt:\(String(describing: num))"
            if let url = URL(string: telNo) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
    }
}

extension ContactsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.callDict?.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactsViewController.collectionViewCellIdentifier, for: indexPath) as? ContactsCollectionViewCell
        cell?.updateUI()
        let imageName =
            self.callDict![indexPath.row].company
        //        if imageName == "USAA" || imageName == "TCS" {
        //            cell?.logoImageView.image = UIImage(named: imageName!)
        //            cell?.logoImageView.isHidden = false
        //            cell?.companyLbl.isHidden = true
        //        } else {
        cell?.companyLbl.text = imageName
        cell?.companyLbl.isHidden = false
        cell?.logoImageView.isHidden = true
        //        }
        
        // return the cell
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedOrg = self.callDict![indexPath.row].company
        self.currentContact = self.callDict?.filter({
            $0.company == selectedOrg
        })
        tableView.reloadData()
        let topIndex = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: topIndex, at: .top, animated: true)
    }
    
}
