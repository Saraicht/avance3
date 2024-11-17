//
//  ViewControllerIntro.swift
//  avancePoryecto1
//
//  Created by mauro on 11/15/24.
//

import UIKit
import GoogleSignIn
import Firebase
import FacebookLogin
import FirebaseAuth

class ViewControllerIntro: UIViewController {
    
    //Botones para aplicar estilos
    @IBOutlet weak var btnFacebok: CustomButton10!
    
    //Botones para ir al Login
    @IBAction func goGetStarted(_ sender: Any) {
        performSegue(withIdentifier: "irLogin", sender: self)
    }
    @IBAction func goLogin(_ sender: Any) {
        performSegue(withIdentifier: "irLogin", sender: self)
    }
    
    //Boton para ie al Crear usuario
    @IBAction func goCrearUsuario(_ sender: Any) {
        performSegue(withIdentifier: "irCrearUsuario", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Crear la UIImageView
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: "fondo2") // Reemplaza "nombreImagen" con el nombre de tu imagen
        backgroundImageView.contentMode = .scaleAspectFill  // Asegura que la imagen ocupe toda la pantalla
        // Añadir la imagen al fondo
        view.insertSubview(backgroundImageView, at: 0)
    }
    
    //Boton para IniciarSesion con Google
    @IBAction func googleSignInTapped(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            if let error = error {
                print("Error al iniciar sesión con Google: \(error.localizedDescription)")
                return
            }
            guard let authentication = user?.authentication else {
                print("No se obtuvo autenticación de Google")
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
            // Iniciar sesión con Firebase usando el credential
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Error al autenticar con Firebase: \(error.localizedDescription)")
                    return
                }
                print("Inicio de sesión exitoso con Google")
                // Navegar a la siguiente pantalla
                self.performSegue(withIdentifier: "irMainScreen", sender: self)
            }
        }
    }
    
    //Boton para IniciarSesion con Google
    @IBAction func btnFacebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        //loginManager.logOut()
        //print("Sesion de Facebook cerrada")
        
        // Inicia el proceso de login con Facebook
        loginManager.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
            if let error = error {
                print("Error al iniciar sesión con Facebook: \(error.localizedDescription)")
                return
            }
                
            guard let result = result, !result.isCancelled else {
                print("Inicio de sesión cancelado por el usuario.")
                return
            }
                
            // Obtén el token de acceso de Facebook
            guard let accessToken = AccessToken.current?.tokenString else {
                print("No se pudo obtener el token de acceso de Facebook.")
                return
            }
            
            // Usa el token de acceso de Facebook para autenticar con Firebase
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Error al autenticar con Firebase: \(error.localizedDescription)")
                    return
                }
                
                // Inicio de sesión exitoso
                print("Inicio de sesión exitoso con Facebook y Firebase. Usuario: \(authResult?.user.email ?? "No email")")
                
                // Realiza una transición a la siguiente pantalla
                self.performSegue(withIdentifier: "irMainScreen", sender: nil)
            }
        }

    }
    
}
