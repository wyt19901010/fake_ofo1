//
//  TalkViewController.swift
//  fake_ofo
//
//  Created by YUTONG WU on 2018/3/30.
//  Copyright © 2018年 Big. All rights reserved.
//

import UIKit
import SWRevealViewController

class TalkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "window_success_Normal").withRenderingMode(.alwaysOriginal)
      if let revealVC = revealViewController(){
        revealVC.rearViewRevealWidth = 380
        navigationItem.leftBarButtonItem?.target = revealVC
        navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(revealVC.panGestureRecognizer())
      }
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
