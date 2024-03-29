//
//  PhotoTableTableViewController.swift
//  LaurensInstagram
//
//  Created by Apple on 7/29/19.
//  Copyright © 2019 Lauren Workosky. All rights reserved.
//

import UIKit

class PhotoTableTableViewController: UITableViewController {
    var photos : [Photos] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getPhotos(){
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            if let coreDataPhotos = try? context.fetch(Photos.fetchRequest()) as? [Photos] {
                // if let unwrappedPhotos = coreDataPhotos {
                //  photos = unwrappedPhotos
                photos = coreDataPhotos
                tableView.reloadData()
                // }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPhotos()
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return photos.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        // Configure the cell...
        let cellPhoto = photos[indexPath.row]
        cell.textLabel?.text = cellPhoto.caption
        if let cellPhotoImageData = cellPhoto.imageData {
            if let cellPhotoImage = UIImage(data: cellPhotoImageData){
                cell.imageView?.image = cellPhotoImage
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSegue", sender: photos[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let photoDetailView = segue.destination as? PhotoDetailViewController {
                if let photoToSend = sender as? Photos {
                    photoDetailView.photo = photoToSend
                }
            }
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // print("Howdy")
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let photoToDelete = photos[indexPath.row]
                context.delete(photoToDelete)
                
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                getPhotos()
            }
        }
    }
    
    
}
