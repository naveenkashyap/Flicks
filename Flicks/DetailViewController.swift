//
//  DetailViewController.swift
//  Flicks
//
//  Created by Naveen Kashyap on 1/15/17.
//  Copyright © 2017 Naveen Kashyap. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailOverview: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var detailInfoView: UIView!
    @IBOutlet weak var detailRating: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailScrollView.contentSize = CGSize(width: detailScrollView.frame.size.width, height: detailInfoView.frame.origin.y + detailInfoView.frame.size.height)
        
        let title = movie["original_title"] as? String
        let overview = movie["overview"] as? String
        let rating = movie["vote_average"] as? Float
        
        detailTitle.text = title
        //detailTitle.sizeToFit()
        detailRating.text = "Rating: \(rating!)"
        detailOverview.text = overview
        detailOverview.sizeToFit()
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie?["poster_path"] as? String {
            let posterURL = URL(string: baseURL + posterPath)
            detailImage.setImageWith(posterURL!)
        }


        // Do any additional setup after loading the view.
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
