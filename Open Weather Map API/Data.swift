//
//  Data.swift
//  Open Weather Map API
//
//  Created by Andreas Velounias on 02/10/2018.
//  Copyright © 2018 Andreas Velounias. All rights reserved.
//

import UIKit
import CoreData

class CoreData {
    
    func saveData(model: Model) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let weatherEntity = NSEntityDescription.entity(forEntityName: "WeatherData", in: managedContext)!
        
        let weather = NSManagedObject(entity: weatherEntity, insertInto: managedContext)
        
        weather.setValue(model.conditionImageView, forKeyPath: "conditionImage")
        weather.setValue(model.conditionLabel, forKey: "conditionLabel")
        weather.setValue(model.date, forKey: "date")
        weather.setValue(model.location, forKey: "locationName")
        weather.setValue(model.temperatureLabel, forKey: "temperature")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func loadData() -> Model {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherData")
        userFetch.fetchLimit = 1
        userFetch.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: true)]
        
        let users = try! managedContext.fetch(userFetch)
        
        let weatherData: WeatherData = users.first as! WeatherData
        
        let data = Model(location: weatherData.locationName!,
                         conditionImageView: weatherData.conditionImage!,
                         conditionLabel: weatherData.conditionLabel!,
                         temperatureLabel: weatherData.temperature!,
                         date: weatherData.date!)
        
        return data
    }
    
    func deleteData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let nowDate = Date()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherData")
        
        let result = try? managedContext.fetch(fetchRequest)
        let resultData = result as! [WeatherData]
        
        for object in resultData {
            let thenDate = object.value(forKey: "date") as! Date
            if thenDate.addingTimeInterval(86400) < nowDate {
                managedContext.delete(object)
            }
        }
        
        do {
            try managedContext.save()
        }
        catch {
            
        }
    }
}
