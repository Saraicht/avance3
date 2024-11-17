//
//  ViewControllerLogin.swift
//  avancePoryecto1
//
//  Created by mauro on 11/15/24.
//

import UIKit
import FirebaseAuth

class ViewControllerLogin: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Crear la UIImageView
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: "fondo1") // Reemplaza "nombreImagen" con el nombre de tu imagen
        backgroundImageView.contentMode = .scaleAspectFill  // Asegura que la imagen ocupe toda la pantalla
        // Añadir la imagen al fondo
        view.insertSubview(backgroundImageView, at: 0)
    }
    
    @IBAction func irCrearUsuario(_ sender: Any) {
        performSegue(withIdentifier: "irCrearUsuario2", sender: self)
    }
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
                    let password = passwordTextField.text, !password.isEmpty else {
                    print("Campos incompletos")
                    mostrarAlerta(titulo: "Error", mensaje: "Por favor, completa todos los campos.")
                    return
                }
                
                Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                    if let error = error {
                        print("Error al iniciar sesión: \(error.localizedDescription)")
                        
                        // Mostrar alerta con opciones para Crear o Cancelar
                        DispatchQueue.main.async {
                            let alerta = UIAlertController(
                                title: "Usuario no encontrado",
                                message: "¿Deseas crear una nueva cuenta?",
                                preferredStyle: .alert
                            )
                            
                            let crearAction = UIAlertAction(title: "Crear", style: .default) { _ in
                                self.performSegue(withIdentifier: "irCrearUsuario2", sender: nil)
                            }
                            let cancelarAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                            
                            alerta.addAction(crearAction)
                            alerta.addAction(cancelarAction)
                            self.present(alerta, animated: true, completion: nil)
                        }
                    } else {
                        // Inicio de sesión exitoso
                        DispatchQueue.main.async {
                            print("Inicio de sesión exitoso")
                            self.performSegue(withIdentifier: "irPaginaPrincipal", sender: nil)
                        }
                    }
                }
        // Método para mostrar alertas simples
           func mostrarAlerta(titulo: String, mensaje: String) {
               let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
               alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(alerta, animated: true, completion: nil)
           }

    }
}
