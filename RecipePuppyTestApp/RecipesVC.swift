//
//  RecipesVC.swift
//  RecipePuppyTestApp
//
//  Created by Pyvovarov Andrii on 29.02.18.
//  Copyright © 2018 Pyvovarov Andrii. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices

class RecipesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorToLoad: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
     static let shared = RecipesVC()
    
    let realm = try! Realm()
    let cellId = "Cell"
    lazy var fullListArray: Results<Recipe> = { self.realm.objects(Recipe.self) }()
    var searchArray: [Recipe] = []
    var recipe: Recipe!
     var searchMode = false
    
    var notificationToken: NotificationToken? = nil
    
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addSubview(refreshControl)
        
        ServiceData.downloadFullList()
        
        refreshControl.addTarget(self, action:
            #selector(handleRefresh),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        
        searchBar.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        
        
        updateSearchResults(for: searchBar)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backgroundImage = resizeImage(image: UIImage(named: "puppy")!, newWidth: CGFloat(integerLiteral: Int(self.view.frame.size.width * 0.6)))
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .bottomRight
        self.tableView.backgroundView = imageView
    }

    func handleRefresh() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func updateSearchResults(for searchBar: UISearchBar) {
        let searchText = searchBar.text!
        if searchText.isEmpty == false {
            fullListArray = (fullListArray.realm?.objects(Recipe.self))!
            fullListArray = fullListArray.sorted(byKeyPath: "title", ascending: true)
        }
        else {
            fullListArray = (fullListArray.realm?.objects(Recipe.self).sorted(byKeyPath: "title", ascending: true))!
        }
        
        notificationToken?.stop()
        notificationToken = fullListArray.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                
                tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                print("Error: \(error)")
                break
            }
        }
    }
    
    func arrayData() -> [Recipe] {
        return searchMode ? searchArray : Array(fullListArray)
    }
    
    deinit {
        notificationToken?.stop()
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        let rect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData().count
    }
    
    // MARK: - Table View DataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! RecipeCell
        let recipe = arrayData()[indexPath.row]
        
        cell.configureCell(recipe)
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let href = arrayData()[indexPath.row].href!
      
        let svc = SFSafariViewController(url: URL(string: href)!)
        
        DispatchQueue.main.async {
            tableView.reloadData()
        }

        self.present(svc, animated: true, completion: nil)
 
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.8)
    }
    
    // MARK: - Search Bar delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        indicatorToLoad.startAnimating()
        
        ServiceData.getSearchList(searchWord: searchBar.text!, completion: { result in
            if let recipes = result?.recipes {
                self.searchArray = recipes
            } else {
                self.searchArray = []
            }
            self.tableView.reloadData()
            self.indicatorToLoad.stopAnimating()
        })
        searchMode = true
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchMode = false
            searchArray = []
            tableView.reloadData()
            searchBar.endEditing(true)
        }
    }
    
    //MARK: - Fix SearchBar in Landscape mode
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            let orient = UIApplication.shared.statusBarOrientation
            switch orient {
            case .portrait:
                return
            default:
                self.searchBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            print("rotation completed")
        })
        
        super.willTransition(to: newCollection, with: coordinator)
    }
}
