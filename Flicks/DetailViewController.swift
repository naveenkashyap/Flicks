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
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = movie["original_title"] as? String
        let overview = movie["overview"] as? String
        
        detailTitle.text = title
        detailOverview.text = overview

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
