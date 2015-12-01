//
//  HomeTableViewController.swift
//  France3Refonte
//
//  Created by Maxence DE CUSSAC on 30/10/2015.
//  Copyright © 2015 Maxence DE CUSSAC. All rights reserved.
//

import UIKit
import Foundation

enum Application {
    case Outremer
    case Regions
}

class HomeTableViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var viewFooter: UILabel!
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var labelSelection: UILabel!
    lazy var dataSource = [String]()
    lazy var selectedRegion = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        generateDataSource()
        
        // Do any additional setup after loading the view, typically from a nib.
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.tag = 10
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideBlur"))
        tapGesture.delegate = self
        view.viewWithTag(20)?.addGestureRecognizer(tapGesture)
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
        view.insertSubview(blurEffectView, aboveSubview: view.viewWithTag(30)!)

        tapGesture = UITapGestureRecognizer(target: self, action: Selector("goToHomePage"))
//        tapGesture.delegate = self
        self.viewFooter.addGestureRecognizer(tapGesture)
    }
    func generateDataSource() {
        if dataSource.isEmpty {
            var test = ""
            do {
                let path = NSBundle.mainBundle().pathForResource("regions", ofType: "csv")
                test = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
                let regions = test.componentsSeparatedByString("\r\n")
                for region in regions {
                    var name = ""
                    var temp = region.componentsSeparatedByString(";")
                    name = temp[0]
                    dataSource.append(name)
                }
            }
            catch {
                print((error))
            }
        }
    }
    
    func hideBlur() {
        let viewsToHide:[UIView] = [view.viewWithTag(10)!, view.viewWithTag(20)!]
        let screenFrame = UIScreen.mainScreen().bounds
        
        for view in viewsToHide {
            var frame = view.frame
            frame.origin.y = CGRectGetMaxY(screenFrame)
            UIView.animateWithDuration(0.5, animations: {
                view.frame = frame
                }, completion: { finished in
                    if finished {
                        view.removeFromSuperview()
                    }
            })
        }
    }
    
    //MARK: TableViewManagement
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("selectionCityReuseIdentifier") as? SelectionCell
        if cell == nil {
            cell = SelectionCell(style: UITableViewCellStyle.Default, reuseIdentifier: "selectionCityReuseIdentifier")
        }
        cell!.labelCity.text = dataSource[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 10, y: 0, width: tableView.bounds.size.width - 10, height: 50))
        headerView.backgroundColor = UIColor.whiteColor()
        
        if (section == 0) {

            
            let label = UILabel(frame: headerView.frame)
            label.font = labelSelection.font
            label.textColor = labelSelection.textColor
            label.text = labelSelection.text
            label.sizeToFit()
            headerView.addSubview(label)
            
            headerView.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: headerView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20))
        }
        
        return headerView;

    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Selection par région"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SelectionCell
        
        // Pour changer l'état du switch
        cell.switchSelection.selected = !cell.switchSelection.selected
        
        if (!selectedRegion.contains(cell.labelCity.text!) && cell.switchSelection.selected){
            selectedRegion.append(cell.labelCity.text!)
        } else if (selectedRegion.contains(cell.labelCity.text!) && !cell.switchSelection.selected) {
            let index = selectedRegion.indexOf(cell.labelCity.text!)
            selectedRegion.removeAtIndex(index!)
        }
        
        // Modifie visuellement la sélection courante du switch
        cell.switchSelection.setOn(cell.switchSelection.selected, animated: true)
        // si une région est sélectionnée afficher le footer.
        viewFooter.hidden = selectedRegion.count == 0
        

        viewFooter.userInteractionEnabled = true
        // Pour éviter la surbrillance
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func goToHomePage() {
        print("works")
    }
}

class SelectionCell: UITableViewCell {
    
    @IBOutlet weak var switchSelection: UISwitch!
    @IBOutlet weak var labelCity: UILabel!
}

// Pour trier des tableaux
//        dataSource.sortInPlace()
//        print("array before duplicates \(dataSource)")
//        var temp = Array(Set(dataSource))
//        temp.sortInPlace()
//        print("after duplicates \(temp)")

