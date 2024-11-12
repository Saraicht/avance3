import UIKit
import FirebaseDatabase

class ViewControllerAgregarProductos: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var imageProducto: UIImageView!
    @IBOutlet weak var nombreProducto: UITextField!
    @IBOutlet weak var precioProducto: UITextField!
    @IBOutlet weak var cantidadProducto: UITextField!
    
    var categoriaActual: String = ""
    let ref = Database.database().reference()
    
    // Array con algunos SF Symbols comunes para productos
    let symbolNames = [
        // Electrónicos
            "iphone", "laptopcomputer", "tv.fill", "headphones", "camera.fill",
            // Ropa
            "tshirt.fill", "case.fill", "bag.fill",
            // Alimentos
            "leaf.fill", "carrot.fill", "flour", "cup.and.saucer.fill",
            // Hogar
            "bed.double.fill", "lamp.desk.fill", "chair.lounge.fill",
            // Deportes
            "sportscourt.fill", "figure.run", "dumbbell.fill",
            // Belleza
            "comb.fill", "drop.fill",
            // Libros y entretenimiento
            "book.fill", "gamecontroller.fill", "music.note",
            // Otros
            "gift.fill", "tag.fill", "star.fill"
    ]
    
    var selectedSymbol: String = "cart.fill"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray
        
        nombreProducto.delegate = self
        precioProducto.delegate = self
        cantidadProducto.delegate = self
        
        categoriaActual = CategoriaManager.shared.categoriaNombre
        
        title = "Agregar a \(categoriaActual)"
        
        configurarImagenInicial()
        configurarGestureImageView()
    }
    
    func configurarImagenInicial() {
        actualizarImagen(symbolName: selectedSymbol)
    }
    
    func actualizarImagen(symbolName: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 100, weight: .regular)
        let imagen = UIImage(systemName: symbolName, withConfiguration: config)?
            .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        imageProducto.image = imagen
        imageProducto.contentMode = .scaleAspectFit
    }
    
    func configurarGestureImageView() {
        // Hacer la imagen clickeable
        imageProducto.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mostrarSelectorIconos))
        imageProducto.addGestureRecognizer(tapGesture)
    }
    
    @objc func mostrarSelectorIconos() {
        let alertController = UIAlertController(title: "Seleccionar Ícono", message: nil, preferredStyle: .actionSheet)
        
        // Agregar opciones para cada símbolo
        for symbolName in symbolNames {
            let action = UIAlertAction(title: symbolName, style: .default) { [weak self] _ in
                self?.selectedSymbol = symbolName
                self?.actualizarImagen(symbolName: symbolName)
            }
            alertController.addAction(action)
        }
        
        // Agregar botón de cancelar
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alertController.addAction(cancelAction)
        
        // Para iPad
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = imageProducto
            popoverController.sourceRect = imageProducto.bounds
        }
        
        present(alertController, animated: true)
    }
    
    // El resto de las funciones de validación permanecen igual
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        switch textField {
        case nombreProducto:
            return updatedText.count <= 30
        case precioProducto:
            let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet) && updatedText.count <= 10
        case cantidadProducto:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet) && updatedText.count <= 5
        default:
            return true
        }
    }
    
    @IBAction func btnGuardar(_ sender: Any) {
        guard let nombre = nombreProducto.text, !nombre.isEmpty,
              let precioText = precioProducto.text, !precioText.isEmpty,
              let cantidadText = cantidadProducto.text, !cantidadText.isEmpty,
              let precio = Double(precioText),
              let cantidad = Int(cantidadText) else {
            mostrarAlerta(mensaje: "Por favor, complete todos los campos correctamente")
            return
        }
        
        guard !categoriaActual.isEmpty else {
            mostrarAlerta(mensaje: "Error: No hay categoría seleccionada")
            return
        }
        
        // Agregar el symbolName al diccionario de datos
        let datosProducto = [
            "nombre": nombre,
            "precio": precio,
            "cantidad": cantidad,
            "imagen": selectedSymbol, // Guardamos el nombre del SF Symbol
            "fechaCreacion": ServerValue.timestamp()
        ] as [String : Any]
        
        let productoRef = ref.child("CATEGORIAS").child(categoriaActual).child("productos").child(nombre)
        
        productoRef.setValue(datosProducto) { (error, ref) in
            if let error = error {
                self.mostrarAlerta(mensaje: "Error al guardar: \(error.localizedDescription)")
            } else {
                self.mostrarAlerta(mensaje: "Producto guardado exitosamente") { _ in
                    self.nombreProducto.text = ""
                    self.precioProducto.text = ""
                    self.cantidadProducto.text = ""
                    self.selectedSymbol = "cart.fill"
                    self.configurarImagenInicial()
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
    
    @IBAction func btnAtras(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
