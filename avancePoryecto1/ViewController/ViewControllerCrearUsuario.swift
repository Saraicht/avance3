//
//  ViewControllerCrearUsuario.swift
//  avancePoryecto1
//
//  Created by mauro on 11/15/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewControllerCrearUsuario: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Crear la UIImageView
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: "fondo3") // Reemplaza "nombreImagen" con el nombre de tu imagen
        backgroundImageView.contentMode = .scaleAspectFill  // Asegura que la imagen ocupe toda la pantalla
        // Añadir la imagen al fondo
        view.insertSubview(backgroundImageView, at: 0)
    }
    
    @IBAction func registrarUsuarioTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = passwordConfirmTextField.text,
              !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            print("Campos incompletos")
            return
        }
        
        // Verificar que las contraseñas coincidan
        guard password == confirmPassword else {
            print("Las contraseñas no coinciden")
            return
        }
        
        // Crear usuario en Firebase
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error al crear el usuario: \(error.localizedDescription)")
            } else {
                guard let uid = authResult?.user.uid else { return }
                Database.database().reference().child("usuarios").child(uid).child("email").setValue(email)
                print("Usuario creado exitosamente")
                // Navegar a la siguiente pantalla
                self.performSegue(withIdentifier: "registroCompletoSegue", sender: nil)
            }
        }
    }
}
