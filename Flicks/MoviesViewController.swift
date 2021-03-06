//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Naveen Kashyap on 1/9/17.
//  Copyright © 2017 Naveen Kashyap. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieSearch: UISearchBar!
    var endpoint: String!
    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    var selectedImage: UIImageView?
    
    func reloadData(){
        tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = filteredMovies {
            return movies.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell
        let movie = filteredMovies?[indexPath.row]
        cell?.movie = movie
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
        let urlString = "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)"
        let url = URL(string: urlString)!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.filteredMovies = self.movies
                    self.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        }
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredMovies = searchText.isEmpty ? movies : movies?.filter(
            {(movie: NSDictionary) -> Bool in
                let movieString = movie["original_title"] as? String
                return movieString?.range(of: searchText, options: .caseInsensitive) != nil
        })
        reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredMovies = movies
        reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // initialize main table
        tableView.dataSource = self
        tableView.delegate = self
        
        // initialize search bar
        movieSearch.delegate = self
        movieSearch.sizeToFit()
        navigationItem.titleView = movieSearch
        
        // pull down to refresh
        let refreshControlTable = UIRefreshControl()
        refreshControlTable.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControlTable, at: 0)
        
        // get data from network and place into movies/filteredMovies dictionary
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.filteredMovies = self.movies
                    self.reloadData()
                }
            }
        }
        task.resume()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        selectedImage = cell.imageView
        let indexPath = tableView.indexPath(for: cell)
        let movie = filteredMovies![indexPath!.row]
        
        // Get the new view controller using 
        let detailViewController = segue.destination as! DetailViewController
        
        // Pass the selected object to the new view controller.
        detailViewController.movie = movie
    }

}
