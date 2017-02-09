//
//  MovieCell.swift
//  Flicks
//
//  Created by Naveen Kashyap on 1/9/17.
//  Copyright © 2017 Naveen Kashyap. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    var movie: NSDictionary! {
        didSet{
            let title = movie?["original_title"] as? String
            let overview = movie?["overview"] as? String
            
            let baseURL = "https://image.tmdb.org/t/p/w500"
            
            if let posterPath = movie?["poster_path"] as? String {
                let posterURL = URL(string: baseURL + posterPath)!
                let imageRequest = URLRequest(url: posterURL)
                posterView.setImageWith(
                    imageRequest,
                    placeholderImage: nil,
                    success: { (imageRequest, imageResponse, image) -> Void in
                        
                        // imageResponse will be nil if the image is cached
                        if imageResponse != nil {
                            self.posterView.alpha = 0.0
                            self.posterView.image = image
                            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                self.posterView.alpha = 1.0
                            })
                        } else {
                            self.posterView.image = image
                        }
                },
                    failure: { (imageRequest, imageResponse, error) -> Void in
                        // do something for the failure condition
                })
            }
            
            titleLabel.text = title
            overviewLabel.text = overview

        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
