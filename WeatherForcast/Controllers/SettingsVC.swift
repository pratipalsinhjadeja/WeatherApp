//
//  SettingsVC.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 05/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import UIKit

protocol UpdateCitySettingDelegate {
    func refreshWeatherData(_ viewController: SettingsVC , isRemoveData: Bool)
}

class SettingsVC: UIViewController {

    @IBOutlet weak var tblSettings: UITableView!
    var delegate: UpdateCitySettingDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        // Do any additional setup after loading the view.
    }
    func setupViews(){
        self.navigationItem.title = Texts.AppSettings
        
        let btnClose =  Helper.barButtonItem(selector: #selector(self.btnCloseTapped), controller: self, image: UIImage(named: "close")!)
        self.navigationItem.leftBarButtonItem = btnClose
        
        self.tblSettings.tableFooterView = UIView()
    }
    
    @IBAction func btnCloseTapped(){
        self.dismiss(animated: true) {
            
        }
    }

}

extension SettingsVC {
    func showAlert(){
        
        let alertController = UIAlertController(title: Texts.removeAllCities, message: Texts.removeAllInfo, preferredStyle: .alert)
        let btnYes = UIAlertAction(title: Texts.yesTitle, style: .default) { (action:UIAlertAction) in
            
            do{
                try DataOperation.singleton.deleteAllCities()
                self.dismiss(animated: true, completion: {
                    self.callWeatherDetailVCDelegate(isRemoveData: true)
                })
            }catch{
                print(error.localizedDescription)
            }
        }
        
        let btnNo = UIAlertAction(title: Texts.noTitle, style: .cancel) { (action:UIAlertAction) in
        }
        
        alertController.addAction(btnYes)
        alertController.addAction(btnNo)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayWeatherUnits(){
        let alert = UIAlertController(title: Texts.selectUnit, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: WeatherUnits.Imparical.rawValue, style: .default , handler:{ (UIAlertAction)in
            UserDefaults.standard.setValue(WeatherUnits.Imparical.rawValue, forKey: UnitKey.weatherUnitKey)
            self.updateRow()
            self.callWeatherDetailVCDelegate(isRemoveData: false)
        }))
        
        alert.addAction(UIAlertAction(title: WeatherUnits.Standard.rawValue, style: .default , handler:{ (UIAlertAction)in
            UserDefaults.standard.setValue(WeatherUnits.Standard.rawValue, forKey: UnitKey.weatherUnitKey)
            self.updateRow()
            self.callWeatherDetailVCDelegate(isRemoveData: false)
        }))
        
        alert.addAction(UIAlertAction(title: WeatherUnits.Metric.rawValue, style: .default , handler:{ (UIAlertAction)in
            UserDefaults.standard.setValue(WeatherUnits.Metric.rawValue, forKey: UnitKey.weatherUnitKey)
            self.updateRow()
            self.callWeatherDetailVCDelegate(isRemoveData: false)
        }))
        
        alert.addAction(UIAlertAction(title: Texts.dismissTitle, style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion:nil)
    }
    
    func updateRow(){
        self.tblSettings.beginUpdates()
        self.tblSettings.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        self.tblSettings.endUpdates()
    }
    
    func callWeatherDetailVCDelegate(isRemoveData: Bool){
        self.delegate?.refreshWeatherData(self, isRemoveData: isRemoveData)
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell  =
                tableView.dequeueReusableCell(withIdentifier: "RightDetailCell") else {
                    return UITableViewCell()
            }
            
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = Texts.weatherUnit
            
            let strUnit = UserDefaults.standard.string(forKey: UnitKey.weatherUnitKey)!
            cell.detailTextLabel?.text = strUnit
            
            return cell
            
        } else if indexPath.row == 1 {
            guard let cell  =
                tableView.dequeueReusableCell(withIdentifier: "BasicCell") else {
                    return UITableViewCell()
            }
            cell.textLabel?.text = Texts.removeAllCities
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.displayWeatherUnits()
        }
        else if indexPath.row == 1 {
            self.showAlert()
        }
    }
}

