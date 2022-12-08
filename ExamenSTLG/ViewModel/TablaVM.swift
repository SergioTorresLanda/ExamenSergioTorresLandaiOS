//
//  UserViewModel.swift
//  ExamenSTLG
//
//  Created by Sergio Torres Landa González on 06/12/22.
//

import Foundation
import Combine
import CoreMedia

//El mediador entre el Model y la View (View Controller)
class TablaVM {
  var userList:[UserModel] = []
    var reloadData = PassthroughSubject<Void,Error>()
    
    @Published var isLoading : Bool?
    //Consulta al Model (Hacemos como si estuviera llamando a una API)
    func getUsers(){
        isLoading=true
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.userList = UserModel.getUsers()
            self.reloadData.send()
            self.isLoading=false
        }
    }
    
}
