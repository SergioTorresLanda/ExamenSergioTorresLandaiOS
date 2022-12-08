//
//  TablaVC.swift
//  ExamenSTLG
//
//  Created by Sergio Torres Landa González on 07/12/22.
//

import UIKit
import Combine

class TablaVC: UIViewController {
    
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.delegate=self
        tv.dataSource=self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var loading:UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .large)
        loading.color = .black
        loading.translatesAutoresizingMaskIntoConstraints = false
        return loading
    }()
    
    
    var viewModel = TablaVM()
    var anyCancelable : [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //Se suscribe al view model para la tabla y progress bar.
        subscriptions()
        //Configura la tabla
        configTableView()
        //Llama la informacion del view model
        viewModel.getUsers()
    }
    
    func subscriptions(){
        viewModel.reloadData.sink {_ in} receiveValue: { _ in
            self.tableView.reloadData()
        }.store(in: &anyCancelable)
        
        viewModel.$isLoading.sink{ state in
            guard let state = state else {return}
            self.configLoading(state: state)
        }.store(in: &anyCancelable)
    }
    
    private func configTableView(){
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor)
            
        ])
    }
    
    func configLoading(state:Bool){
        if state{
            loading.startAnimating()
            tableView.addSubview(loading)
            NSLayoutConstraint.activate([
                loading.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                loading.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
            ])
            return
        }
        loading.removeFromSuperview()
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

extension TablaVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = viewModel.userList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = user.nombre + " " + user.numero + " " + user.fecha + " " + user.sexo + " " + user.color
        cell.textLabel?.numberOfLines=2
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
