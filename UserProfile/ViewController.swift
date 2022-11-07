//
//  ViewController.swift
//  UserProfile
//
//  Created by 백소망 on 2022/11/02.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var users: [User] = []
    private let url = "https://randomuser.me/api/?results=20&inc=name,email,picture"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getUsers()
    }
    
    private func getUsers() {
        //URLSession의 싱글턴 객체
        let session = URLSession.shared
        guard let requestURL = URL(string: url) else {return}
        
        // 네트워킹 시작
        session.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    //Json타입의 데이터를 디코딩
                    let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                    self.users = userResponse.results
                    DispatchQueue.main.async {
                        //UI작업은 꼭 main 스레드에서 !!
                        self.tableView.reloadData()
                    }
                } catch(let err) {
                    print("Decoding Error")
                    print(err.localizedDescription)
                }
            }
        }.resume()      //모든 task()는 일시정지 상태로 시작하기 때문에 resume()으로 task()를 시작해야 한다
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as? UserProfileCell else {
            return UITableViewCell()
        }
        
        cell.setupView(user: users[indexPath.row])
        return cell
    }
}
