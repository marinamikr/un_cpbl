//
//  SubViewController.swift
//  uni_cpbl
//
//  Created by 原田摩利奈 on 2023/11/26.
//

import UIKit

class SubViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    var storeName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = storeName
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
