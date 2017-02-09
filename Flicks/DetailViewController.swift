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
            let posterURL = URL(string: baseURL + posterPath)!
            let smallImageRequest = URLRequest(url: posterURL)
            let largeImageRequest = URLRequest(url: posterURL)
            detailImage.setImageWith(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.detailImage.alpha = 0.0
                    self.detailImage.image = smallImage;
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        self.detailImage.alpha = 1.0
                        
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        self.detailImage.setImageWith(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                self.detailImage.image = largeImage;

                        },
                            failure: { (request, response, error) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                    })
            },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })
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
