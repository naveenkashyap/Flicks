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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    
    @IBOutlet weak var movieSearch: UISearchBar!
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    
    @IBAction func useCollectionView(_ sender: AnyObject) {
        collectionView.isHidden = false
        tableView.isHidden = true
        reloadData()
    }
    
    @IBAction func useTableView(_ sender: AnyObject) {
        tableView.isHidden = false
        collectionView.isHidden = true
        reloadData()
    }
    
    @IBAction func onTap(_ sender: AnyObject) {
        searchBarCancelButtonClicked(movieSearch)
    }
    
    func reloadData(){
        tableView.reloadData()
        collectionView.reloadData()
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = filteredMovies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = filteredMovies {
            return movies.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell
        let movie = filteredMovies?[indexPath.row]
        let title = movie?["original_title"] as? String
        let overview = movie?["overview"] as? String
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let posterPath = movie?["poster_path"] as? String
        
        let posterURL = URL(string: baseURL + posterPath!)
        
        cell?.titleLabel.text = title
        cell?.overviewLabel.text = overview
        cell?.posterView.setImageWith(posterURL!)
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as? MovieCollectionCell
        let movie = filteredMovies?[indexPath.row]
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let posterPath = movie?["poster_path"] as? String
        
        let posterURL = URL(string: baseURL + posterPath!)
        
        cell?.posterImage.setImageWith(posterURL!)
        
        return cell!
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
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
        
        // initialize main collection
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // start the app in table mode
        collectionView.isHidden = true
        tableView.isHidden = false
        
        // initialize search bar
        movieSearch.delegate = self
        
        // pull down to refresh
        let refreshControlTable = UIRefreshControl()
        refreshControlTable.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControlTable, at: 0)
        
        let refreshControlCollection = UIRefreshControl()
        refreshControlCollection.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControlCollection, at: 0)
        
        // get data from network and place into movies/filteredMovies dictionary
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
