//
//  ViewControllerInicio.swift
//  avancePoryecto1
//
//  Created by mauro on 11/15/24.
//

import UIKit

class ViewControllerInicio: UIViewController {
    
    @IBAction func btnCerrarSesion(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //BOTONES
    @IBAction func btnBienes(_ sender: Any) {
        performSegue(withIdentifier: "irBienes", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Crear la UIImageView
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: "fondo4") // Reemplaza "nombreImagen" con el nombre de tu imagen
        backgroundImageView.contentMode = .scaleAspectFill  // Asegura que la imagen ocupe toda la pantalla
        // Añadir la imagen al fondo
        view.insertSubview(backgroundImageView, at: 0)
    }
    
}
