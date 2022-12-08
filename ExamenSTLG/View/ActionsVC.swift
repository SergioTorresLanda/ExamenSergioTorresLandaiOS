//
//  ActionsVC.swift
//  ExamenSTLG
//
//  Created by Sergio Torres Landa González on 06/12/22.
//

import UIKit

class ActionsVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
   
    @IBOutlet weak var viewSV: UIView!
    @IBOutlet weak var nombreView: UIStackView!
    @IBOutlet weak var telefonoView: UIStackView!
    @IBOutlet weak var sexoView: UIStackView!
  
    @IBOutlet weak var fechaView: UIStackView!
    @IBOutlet weak var colorView: UIStackView!
    @IBOutlet weak var camaraView: UIStackView!
    
    @IBOutlet weak var fotoView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nombreTF: UITextField!
    @IBOutlet weak var telefonoTF: UITextField!
    @IBOutlet weak var sexoPickerView: UIPickerView!
    @IBOutlet weak var diaPV: UIPickerView!
    @IBOutlet weak var mesPV: UIPickerView!
    @IBOutlet weak var anoPV: UIPickerView!
    @IBOutlet weak var colorPV: UIPickerView!
    @IBOutlet weak var fotoImg: UIImageView!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet weak var camaraHeight: NSLayoutConstraint!
    @IBOutlet weak var nombreHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneHeight: NSLayoutConstraint!
    @IBOutlet weak var sexHeight: NSLayoutConstraint!
    @IBOutlet weak var fechaHeight: NSLayoutConstraint!
    @IBOutlet weak var fotoHeight: NSLayoutConstraint!
    @IBOutlet weak var colorHeight: NSLayoutConstraint!
    @IBOutlet weak var SVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    var activeField: UITextField?
    var arrayEditions:[String]=[]
    let genders = ["-Seleccionar-","Femenino","Masculino"]//1
    let days = ["--","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]//2
    let months = ["--","01","02","03","04","05","06","07","08","09","10","11","12"]//3
    var years:[String] = ["----"]//4
    let colores = ["-Seleccionar-","verde","rojo","azul","morado","naranja","amarillo"]//5
    let defaults = UserDefaults.standard
    var imgData:Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateYears()
        addTapGestures()
        addDoneButtonOnKeyboard()
        setearFormatosTextField()
        imagePicker.delegate = self
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        updateBtn.applyGradient(colours: [UIColor(named: "color_gradient_start") ?? UIColor.blue, UIColor(named: "color_gradient_end") ?? UIColor.blue])
        let rB = CAShapeLayer()
        rB.bounds = rB.frame
        rB.path = UIBezierPath(roundedRect: self.updateBtn.bounds, byRoundingCorners: [.bottomLeft , .bottomRight, .topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        updateBtn.layer.mask = rB
    }
    
    func addTapGestures(){
        let tapG1 = UITapGestureRecognizer(target: self, action: #selector(ActionsVC.TF1))
        fotoImg.addGestureRecognizer(tapG1)
        let tapG2 = UITapGestureRecognizer(target: self, action: #selector(ActionsVC.TF2))
        uploadImage.addGestureRecognizer(tapG2)
        
        //https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/images%2FApkings%20sergio.torreslanda%40gmail.com?alt=media&token=e9b3192d-e867-4eac-879b-71bc720e30a7
    }
    
    @objc func TF1(gesture: UIGestureRecognizer) {
        print("Camara click")
        performSegue(withIdentifier: "camara", sender: self)
    }
    
    @objc func TF2(gesture: UIGestureRecognizer) {
        fotoImg.loadS(urlS: "https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/images%2FApkings%20sergio.torreslanda%40gmail.com?alt=media&token=e9b3192d-e867-4eac-879b-71bc720e30a7")
        //No estaba activa la URL de la imagen provista en el documento, puse una mia.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        if !arrayEditions.contains("Nombre"){
            nombreView.isHidden=true
            nombreHeight.constant=0
        }
        if !arrayEditions.contains("Camara"){
            camaraView.isHidden=true
            camaraHeight.constant=0
        }
        if !arrayEditions.contains("Foto"){
            fotoView.isHidden=true
            fotoHeight.constant=0
        }
        if !arrayEditions.contains("Numero"){
            telefonoView.isHidden=true
            phoneHeight.constant=0
        }
        if !arrayEditions.contains("Fecha"){
            fechaView.isHidden=true
            fechaHeight.constant=0
        }
        if !arrayEditions.contains("Sexo"){
            sexoView.isHidden=true
            sexHeight.constant=0
        }
        if !arrayEditions.contains("Color"){
            colorView.isHidden=true
            colorHeight.constant=0
        }
        
        //poner foto si existe una captura
        ponerFoto()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
   
    func ponerFoto(){
    imgData = defaults.object(forKey: "foto") as? Data
        if imgData != nil {
            fotoImg.image = UIImage(data: imgData!)
        }
    }
    
    
    @IBAction func updateClick(_ sender: Any) {
        // Verificar caracteres aceptados en nombre
        let nameValue: String = nombreTF.text!
        do {
           let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
           if regex.firstMatch(in: nameValue, options: [], range: NSMakeRange(0, nameValue.count)) != nil {
               
               errorLabel.text="No se aceptan caracteres especiales en nombre"
               errorLabel.isHidden=false
               errorLabel.textColor=UIColor.red
                return
           }
       }
       catch {}
        //Verifica nombre a 35 dígitos máximo
        if arrayEditions.contains("Nombre") {
            if !nombreTF.hasText || nombreTF.text!.count>35{
                showError(texto: "Nombre a 35 dígitos máximo")
                return
            }
            //guarda el dato
            let nameValue: String = nombreTF.text!
            self.defaults.set(nameValue, forKey: "nombre")
        }
        //Verifica numero a 10 dígitos máximo
        if arrayEditions.contains("Numero") {
            if !telefonoTF.hasText || telefonoTF.text!.count>10{
                showError(texto: "Número a 10 dígitos")
                return
            }
            //guarda el dato
            let phone: String = telefonoTF.text!
            self.defaults.set(phone, forKey: "telefono")
        }
        //Verifica sexo seleccionado
        if arrayEditions.contains("Sexo") {
            guard
                self.sexoPickerView.selectedRow(inComponent: 0) != 0
            else {
                showError(texto: "Selecciona tu sexo")
                return
            }
            //guarda el dato
            let sex = genders[sexoPickerView.selectedRow(inComponent: 0)]
            self.defaults.set(sex, forKey: "sexo")
        }
        //Verifica fecha de nacimiento seleccionada
        if arrayEditions.contains("Fecha") {
            guard
                self.diaPV.selectedRow(inComponent: 0) != 0
            else {
                showError(texto: "Selecciona tu día de nacimiento")
                return
            }
            guard
                self.mesPV.selectedRow(inComponent: 0) != 0
            else {
                showError(texto: "Selecciona tu mes de nacimiento")
                return
            }
            guard
                self.anoPV.selectedRow(inComponent: 0) != 0
            else {
                showError(texto: "Selecciona tu año de nacimiento")
                return
            }
            let fecha = String(days[diaPV.selectedRow(inComponent: 0)])+"-"+String(months[mesPV.selectedRow(inComponent: 0)])+"-"+String(years[anoPV.selectedRow(inComponent: 0)])
            self.defaults.set(fecha, forKey: "fecha")
        }
        //Verifica color seleccionado
        if arrayEditions.contains("Color") {
            guard
                self.colorPV.selectedRow(inComponent: 0) != 0
            else {
                showError(texto: "Selecciona tu color favorito")
                return
            }
            let color = colores[colorPV.selectedRow(inComponent: 0)]
            self.defaults.set(color, forKey: "color")
        }
        //Todo OK
        showSuccess()
    }
    
    func showError(texto:String){
        errorLabel.isHidden = false
        errorLabel.textColor=UIColor.red
        errorLabel.text = texto
    }
    func showSuccess(){
        errorLabel.isHidden=false
        errorLabel.text="Datos guardados"
        errorLabel.textColor=UIColor.green
    }
    
    func setupUI (){
        sexoPickerView.delegate = self
        diaPV.delegate = self
        mesPV.delegate = self
        anoPV.delegate = self
        colorPV.delegate = self
        colorPV.dataSource = self
        sexoPickerView.dataSource = self
        diaPV.dataSource = self
        mesPV.dataSource = self
        anoPV.dataSource = self
        nombreTF.delegate=self
        telefonoTF.delegate=self
        
        registerForKeyboardNotifications()
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
             doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        nombreTF.inputAccessoryView = doneToolbar
        telefonoTF.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        nombreTF.resignFirstResponder()
        telefonoTF.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // For showing/hiding keyboard
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasShown(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height+100, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        self.view.endEditing(true)
        
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        formatoScrollView()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
        formatoScrollView()
    }
    
    func formatoScrollView(){
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
        rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }
    
    func setearFormatosTextField(){
        nombreTF.attributedPlaceholder  = NSAttributedString(string: "Nombre completo", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "CCCPH")!.withAlphaComponent(1)])
        telefonoTF.attributedPlaceholder  = NSAttributedString(string: "A 10 digitos", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "CCCPH")!.withAlphaComponent(1)])
    }
    

    //MARK: PICKERVIEW
    func generateYears(){
        for i in 1970...2004 {
            let s = String(i)
            years.append(s)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return genders.count
        case 2:
            return days.count
        case 3:
            return months.count
        case 4:
            return years.count
        case 5:
            return colores.count
        default:
            return 0
        }
    
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return genders[row]
        case 2:
            return days[row]
        case 3:
            return months[row]
        case 4:
            return years[row]
        case 5:
            return colores[row]
        default:
            return nil
        }
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

extension ActionsVC: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.fotoImg.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func loadS(urlS: String) {
        guard let url = URL(string:urlS)else{
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        //imageCache.setObject(image, forKey: urlS as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}
