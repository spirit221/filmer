//
//  ViewController.swift
//  Filmer
//
//  Created by Sergey Gusev on 04.03.2018.
//  Copyright © 2018 Sergey Gusev. All rights reserved.
//
import SystemConfiguration
import UIKit
import Foundation
class ViewController: UIViewController, UIScrollViewDelegate{
    let randomFilmList = RandomFilmList()
    var imageCache = NSMutableDictionary()
    var nameFilm = ""
    var poster = #imageLiteral(resourceName: "picture1")
    var overview: String = ""
    var releaseDate: String = ""
    var swipeGesture  = UISwipeGestureRecognizer()
    //let detailed = DetailedViewController()
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.detailed.delegate = self
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left]
        scrollView.delegate = self
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        let tap = UITapGestureRecognizer(target: self, action:  #selector(self.handleTap(_:)))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true
        for direction in directions {
            swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwView(_:)))
            image.addGestureRecognizer(swipeGesture)
            swipeGesture.direction = direction
            image.isUserInteractionEnabled = true
            image.isMultipleTouchEnabled = true
        }
        test()
    }
    @IBAction func randomFilm(_ sender: UIButton) {
        test()
    }
    func test () {
        UIView.transition(with: self.view, duration: 3, options: .transitionCrossDissolve, animations: {
            self.randomFilmList.getFilmId() { [weak self] film in
                self?.title = film.nameFilm
              
                self?.image.image = film.poster
                self?.poster = film.poster
                self?.overview = film.overview
                self?.releaseDate = film.releaseDate
            }
        }, completion: nil)
        
    }
    @objc func swipwView(_ sender : UISwipeGestureRecognizer){
        UIView.animate(withDuration: 2.0) {
            if sender.direction == .right || sender.direction == .left {
                self.test()
            }
            self.image.layoutIfNeeded()
            self.image.setNeedsDisplay()
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return image
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let detailed = DetailedViewController(nibName: "DetailedViewController", bundle: nil)
        let transition = CATransition()
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal// kCATransitionPush
        transition.subtype = kCATransitionFromRight
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        detailed.commonInit(overview: overview, releaseDate: releaseDate, poster: poster)
        self.navigationController?.pushViewController(detailed, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        let centralreachability = Reachability()
        if centralreachability.isConnectedToNetwork() == true
        {
            print("Connected")
        }
        else
        {
            let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            controller.addAction(ok)
            
            present(controller, animated: true, completion: nil)
        }
        
    }
    
    
}

