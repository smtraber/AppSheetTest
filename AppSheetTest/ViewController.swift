//
//  ViewController.swift
//  AppSheetTest
//
//  Created by Sean Traber on 9/10/19.
//  Copyright © 2019 Sean. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var users: Users?
    var userDetails = [User]()
    let hud = LoadingHUD(frame: CGRect(origin: .zero, size: UIScreen.main.bounds.size))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Youngest Users"
        hud.show()
        
        performSelector(inBackground: #selector(fetchUsers), with: nil)

    }

    
    @objc func fetchUsers(token: String? = nil) {
        
        let urlString: String
        if let token = token {
            urlString = "https://appsheettest1.azurewebsites.net/sample/list?token=\(token)"
        } else {
            urlString = "https://appsheettest1.azurewebsites.net/sample/list"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    
    func fetchUserDetails(userID: Int) -> User? {
        
        var user: User?
        let urlString = "https://appsheettest1.azurewebsites.net/sample/detail/\(userID)"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                user = parseUserDetails(json: data)
                
                //skip over this user if they don't have a valid U.S. phone number
                guard let phone = user?.number else {
                    return nil
                }
                if !isPhoneValid(phone) {
                    return nil
                }
            }
        }
        
        return user
        
    }
    
    
    func parseUserDetails(json: Data) -> User? {
        
        var user: User?
        let decoder = JSONDecoder()
        
        if let jsonResponse = try? decoder.decode(User.self, from: json) {
            user = User(id: jsonResponse.id, age: jsonResponse.age, name: jsonResponse.name, number: jsonResponse.number, photo: jsonResponse.photo, bio: jsonResponse.bio)
        }
        
        return user
    }
    
    
    func parse(json: Data) {
        
        let decoder = JSONDecoder()
        
        if let jsonResponse = try? decoder.decode(Users.self, from: json) {
            if users != nil {
                let newUsers = jsonResponse.result
                users!.result += newUsers
                
                //continue getting more user id's as long as the result contains a token,
                //so we get the full list of user id's
                if let nextToken = jsonResponse.token {
                    fetchUsers(token: nextToken)
                    return
                }
                
            } else {
                //First call: This initializes the array
                users = Users(result: jsonResponse.result, token: jsonResponse.token)
                if let nextToken = jsonResponse.token {
                    fetchUsers(token: nextToken)
                    return
                }
            }
            
            if let ids = users?.result {
                for id in ids {
                    if let details = fetchUserDetails(userID: id) {
                        
                        //add the first 5 user's details to the userDetails array
                        if userDetails.count < 5 {
                            userDetails.append(details)
                            
                            //Once we get the initial 5 in the array, we sort them by age
                            if userDetails.count == 5 {
                                userDetails = userDetails.sorted { $0.age < $1.age }
                            }
                        } else {
                            //Since the array is sorted by age, the oldest person is the last entry
                            guard let newAge = userDetails.last?.age else {
                                continue
                            }
                            
                            //check if the new user is younger than our current oldest,
                            //and therefore should be added into the array
                            if details.age < newAge {
                                
                                //loop through the items in the array to find the correct spot
                                //to insert this user and keep the array sorted.
                                //then remove the last element as it is no longer one of the 5 youngest
                                for i in 0...4 {
                                    if userDetails[i].age > details.age {
                                        userDetails.insert(details, at: i)
                                        userDetails.remove(at: 5)
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            //now that we have our 5 youngest, re-sort the array alphabetically by name,
            //then reload the table view with this data
            userDetails = userDetails.sorted { $0.name < $1.name }
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            hud.performSelector(onMainThread: #selector(LoadingHUD.hide), with: nil, waitUntilDone: false)
        }
    }
    
    func isPhoneValid(_ input: String) -> Bool {
        
        //make sure the phone number has exactly 10 digits
        let result = input.filter("01234567890".contains)
        if result.count == 10 {
            return true
        } else {
            return false
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDetails.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let details = userDetails[indexPath.row]
        cell.textLabel?.text = "Name: \(details.name)"
        cell.detailTextLabel?.text = "Age: \(details.age)"
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let details = userDetails[indexPath.row]
        
        //Create an instance of the details view and pass it the user for the selected row
        let vc = storyboard?.instantiateViewController(withIdentifier: "Details") as! UserDetailsViewController
        vc.userID = details.id
        vc.selectedUser = details
        navigationController?.pushViewController(vc, animated: true)
    }

}

