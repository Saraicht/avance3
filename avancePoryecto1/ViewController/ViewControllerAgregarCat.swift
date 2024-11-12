import UIKit
import FirebaseDatabase

class ViewControllerAgregarCat: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imageCat: UIImageView!
    @IBOutlet weak var NombreCat: UITextField!
    @IBOutlet weak var ColorCat: UISegmentedControl!
    
    // Referencia a Realtime Database
    let ref = Database.database().reference()
    
    // Array de colores correspondientes a los segmentos
    let colores: [UIColor] = [.red, .blue, .green, .brown]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray
        
        // Configurar el UITextField
        NombreCat.delegate = self
        
        // Configurar los segmentos del UISegmentedControl
        ColorCat.removeAllSegments()
        let coloresNombres = ["Rojo", "Azul", "Verde", "Cafe"]
        
        for (index, color) in coloresNombres.enumerated() {
            ColorCat.insertSegment(withTitle: color, at: index, animated: false)
        }
        
        // Selecciona el primer segmento por defecto
        ColorCat.selectedSegmentIndex = 0
        
        // Configurar la imagen inicial
        configurarImagenInicial()
        
        // Agregar target para el UISegmentedControl
        ColorCat.addTarget(self, action: #selector(cambiarColor), for: .valueChanged)
    }
    
    func configurarImagenInicial() {
        let config = UIImage.SymbolConfiguration(pointSize: 100, weight: .regular)
        let imagen = UIImage(systemName: "airport.express", withConfiguration: config)?
            .withTintColor(colores[0], renderingMode: .alwaysOriginal)
        imageCat.image = imagen
        imageCat.contentMode = .scaleAspectFit
    }
    
    @objc func cambiarColor() {
        let colorSeleccionado = colores[ColorCat.selectedSegmentIndex]
        let config = UIImage.SymbolConfiguration(pointSize: 100, weight: .regular)
        let imagen = UIImage(systemName: "airport.express", withConfiguration: config)?
            .withTintColor(colorSeleccionado, renderingMode: .alwaysOriginal)
        imageCat.image = imagen
    }
    
    // Validación del TextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 15
    }
    
    @IBAction func AgregarCat(_ sender: Any) {
        guard let nombreCategoria = NombreCat.text, !nombreCategoria.isEmpty, nombreCategoria.count >= 1 else {
            mostrarAlerta(mensaje: "El nombre debe tener al menos 1 caracter")
            return
        }
        
        // Crear el diccionario de datos para la categoría
        let datosCategoria = [
            "nombre": nombreCategoria,
            "color": ColorCat.selectedSegmentIndex,
            "fechaCreacion": ServerValue.timestamp()
        ] as [String : Any]
        
        // Referencia al nodo CATEGORIAS y crear un nuevo child con el nombre de la categoría
        let categoriaRef = ref.child("CATEGORIAS").child(nombreCategoria)
        
        // Guardar en Realtime Database
        categoriaRef.setValue(datosCategoria) { (error, ref) in
            if let error = error {
                self.mostrarAlerta(mensaje: "Error al guardar: \(error.localizedDescription)")
            } else {
                self.mostrarAlerta(mensaje: "Categoría guardada exitosamente") { _ in
                    // Limpiar campos después de guardar
                    self.NombreCat.text = ""
                    self.ColorCat.selectedSegmentIndex = 0
                    self.cambiarColor()
                    
                    // Volver al ViewController anterior
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func mostrarAlerta(mensaje: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alerta = UIAlertController(title: "Aviso", message: mensaje, preferredStyle: .alert)
        let accionOK = UIAlertAction(title: "OK", style: .default, handler: completion)
        alerta.addAction(accionOK)
        present(alerta, animated: true)
    }

    @IBAction func SalirCCat(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
