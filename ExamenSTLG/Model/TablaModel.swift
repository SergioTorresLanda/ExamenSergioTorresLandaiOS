//
//  UserModel.swift
//  ExamenSTLG
//
//  Created by Sergio Torres Landa González on 06/12/22.
//

import Foundation

//Donde estaria la llamada a recibir los datos de una API o alguna DataBase
struct UserModel{
    
    let nombre:String
    let numero:String
    let fecha:String
    let sexo:String
    let color:String
    
    static func getUsers() -> [UserModel] {
        let defaults = UserDefaults.standard
        let nombre = defaults.string(forKey: "nombre") ?? "Sergio"
        let numero = defaults.string(forKey: "telefono") ?? "0000000000"
        let fecha = defaults.string(forKey: "fecha") ?? "00-00-1900"
        let sexo = defaults.string(forKey: "sexo") ?? "SinSexo"
        let color = defaults.string(forKey: "color") ?? "SinColor"
        
        return (1..<51).map({UserModel(nombre: "\(nombre)\($0)", numero: numero, fecha: fecha, sexo: sexo, color: color)})
    }
}
