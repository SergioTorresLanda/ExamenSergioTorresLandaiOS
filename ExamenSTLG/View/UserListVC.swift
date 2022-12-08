//
//  UserListVC.swift
//  ExamenSTLG
//
//  Created by Sergio Torres Landa González on 06/12/22.
//

import UIKit

class UserListVC: UIViewController {

    @IBOutlet weak var camaraSwtich: UISwitch!
    @IBOutlet weak var fotoSwitch: UISwitch!
    @IBOutlet weak var nombreSwitch: UISwitch!
    @IBOutlet weak var telefonoSwitch: UISwitch!
    @IBOutlet weak var fechaSwitch: UISwitch!
    @IBOutlet weak var sexoSwitch: UISwitch!
    @IBOutlet weak var colorSwitch: UISwitch!
    
    @IBOutlet weak var editarBtn: UIButton!
    @IBOutlet weak var verTabla: UIButton!
    
    
    var arrayList:[String]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        //formato de botones
        editarBtn.applyGradient(colours: [UIColor.purple, UIColor.red])
        let rB = CAShapeLayer()
        rB.bounds = rB.frame
        rB.path = UIBezierPath(roundedRect: self.editarBtn.bounds, byRoundingCorners: [.bottomLeft , .bottomRight, .topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        editarBtn.layer.mask = rB
        
        verTabla.applyGradient(colours: [UIColor.blue, UIColor.green])
        let rB2 = CAShapeLayer()
        rB2.bounds = rB.frame
        rB2.path = UIBezierPath(roundedRect: self.verTabla.bounds, byRoundingCorners: [.bottomLeft , .bottomRight, .topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        verTabla.layer.mask = rB2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        arrayList=[]
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editar" {
        let newVC = segue.destination as! ActionsVC
            newVC.arrayEditions = (sender as! [String])
        }
    }
    
    
    @IBAction func verTablaClick(_ sender: Any) {
        
        performSegue(withIdentifier: "tabla", sender: self)
    }
    
    @IBAction func editarClick(_ sender: Any) {
    
        if camaraSwtich.isOn {
            arrayList.append("Camara")
        }
        if fotoSwitch.isOn {
            arrayList.append("Foto")
        }
        if nombreSwitch.isOn {
            arrayList.append("Nombre")
        }
        if telefonoSwitch.isOn {
            arrayList.append("Numero")
        }
        if fechaSwitch.isOn {
            arrayList.append("Fecha")
        }
        if sexoSwitch.isOn {
            arrayList.append("Sexo")
        }
        if colorSwitch.isOn {
            arrayList.append("Color")
        }
        
        //Verificar al menos una opcion seleccioanda
        if !(colorSwitch.isOn || camaraSwtich.isOn || fotoSwitch.isOn || nombreSwitch.isOn || telefonoSwitch.isOn || fechaSwitch.isOn || sexoSwitch.isOn){
            
            
            let alert = UIAlertController(title: "¡Ups!", message: "Selecciona al menos una categoría para editar", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "¡Entendido!", style: .default, handler: { (action: UIAlertAction!) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        performSegue(withIdentifier: "editar", sender: arrayList)
    }
    

}

extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
        gradient.cornerRadius = 5
    }
}
