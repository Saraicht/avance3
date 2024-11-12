import UIKit
import FirebaseDatabase

class ViewControllerProductos: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var productos: [Producto] = []
    let ref = Database.database().reference()
    private var initialLoadCompleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemPurple
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Asegurarse de que la tabla esté vacía inicialmente
        productos = []
        tableView.reloadData()
        
        // Marcar que la vista está cargada
        initialLoadCompleted = true
        
        // Suscribirse a la notificación de cambio de categoría
        NotificationCenter.default.addObserver(self, selector: #selector(actualizarCategoriaYCargarProductos), name: NSNotification.Name("CategoriaActualizada"), object: nil)
    }
    
    deinit {
        // Eliminar el observador cuando se destruye el ViewController
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func actualizarCategoriaYCargarProductos(notification: Notification) {
        // Obtener el nombre de la categoría actualizada
        if let categoriaActualizada = notification.userInfo?["categoria"] as? String {
            // Remover observadores anteriores si existen
            let productosRef = ref.child("CATEGORIAS").child(categoriaActualizada).child("productos")
            productosRef.removeAllObservers()
            
            // Cargar productos para la nueva categoría
            cargarProductos(paraCategoria: categoriaActualizada)
        }
    }
    
    func cargarProductos(paraCategoria nombreCategoria: String) {
        
        let productosRef = ref.child("CATEGORIAS").child(nombreCategoria).child("productos")
        
        // Usar .value con singleEventType para la primera carga
        productosRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            self?.procesarDatosProductos(snapshot: snapshot)
            
            // Después de la primera carga, establecer el observer continuo
            productosRef.observe(.value) { [weak self] snapshot in
                self?.procesarDatosProductos(snapshot: snapshot)
            }
        }
    }
    
    private func procesarDatosProductos(snapshot: DataSnapshot) {
        productos.removeAll()
        
        for child in snapshot.children {
            guard let snapshot = child as? DataSnapshot,
                  let productoData = snapshot.value as? [String: Any],
                  let nombre = productoData["nombre"] as? String,
                  let precio = productoData["precio"] as? Double,
                  let cantidad = productoData["cantidad"] as? Int,
                  let imagen = productoData["imagen"] as? String,
                  let timestamp = productoData["fechaCreacion"] as? Double else {
                continue
            }
            
            let fecha = Date(timeIntervalSince1970: timestamp/1000)
            
            let producto = Producto(
                titulo: nombre,
                cantidad: cantidad,
                precio: precio,
                fechaRegistro: fecha,
                imagenNombre: imagen
            )
            
            productos.append(producto)
        }
        
        // Ordenar productos por fecha más reciente
        productos.sort { $0.fechaRegistro > $1.fechaRegistro }
        
        // Asegurarse de que la actualización de UI ocurra en el hilo principal
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "CeldaPersonalizada2", for: indexPath)
                
                let producto = productos[indexPath.row]
                
                // Configurar imageView (tag 1)
                if let imageView = celda.viewWithTag(1) as? UIImageView {
                    let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
                    let imagen = UIImage(systemName: producto.imagenNombre, withConfiguration: config)?
                        .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
                    imageView.image = imagen
                    imageView.contentMode = .scaleAspectFit
                }
                
                // Configurar título (tag 2)
                if let labelTitulo = celda.viewWithTag(2) as? UILabel {
                    labelTitulo.text = producto.titulo
                }
                
                // Configurar cantidad (tag 3)
                if let labelCantidad = celda.viewWithTag(3) as? UILabel {
                    labelCantidad.text = "Cantidad: \(producto.cantidad)"
                }
                
                // Configurar precio (tag 4)
                if let labelPrecio = celda.viewWithTag(4) as? UILabel {
                    labelPrecio.text = String(format: "Precio: %.2f", producto.precio)
                }
                
                // Configurar fecha (tag 5)
                if let labelFecha = celda.viewWithTag(5) as? UILabel {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .short
                    labelFecha.text = dateFormatter.string(from: producto.fechaRegistro)
                }
                
                return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Obtener el producto a eliminar
            let producto = productos[indexPath.row]
            
            // Eliminar de Firebase
            let categoriaActual = CategoriaManager.shared.categoriaNombre
            let productoRef = ref.child("CATEGORIAS").child(categoriaActual).child("productos").child(producto.titulo)
            
            productoRef.removeValue { error, _ in
                if let error = error {
                    print("Error al eliminar producto: \(error.localizedDescription)")
                }
            }
            // La vista se actualizará automáticamente por el observer
        }
    }
    
    @IBAction func btnAgregarProducto(_ sender: Any) {
        performSegue(withIdentifier: "agregarProducto", sender: self)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Obtener el producto seleccionado
        let producto = productos[indexPath.row]

        // Mostrar un AlertController para editar el producto
        showEditProductAlert(for: producto)

        // Deseleccionar la celda
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func showEditProductAlert(for producto: Producto) {
        let alert = UIAlertController(title: "Editar Producto", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Nombre"
            textField.text = producto.titulo
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Precio"
            textField.text = String(format: "%.2f", producto.precio)
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Cantidad"
            textField.text = String(producto.cantidad)
        }

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] (_) in
            guard let nombre = alert.textFields?.first?.text,
                  let precioText = alert.textFields?[1].text,
                  let cantidadText = alert.textFields?[2].text,
                  let precio = Double(precioText),
                  let cantidad = Int(cantidadText) else {
                return
            }

            // Actualizar el producto en Firebase
            self?.updateProduct(producto, with: nombre, precio: precio, quantity: cantidad)
        }

        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }

    private func updateProduct(_ producto: Producto, with name: String, precio: Double, quantity: Int) {
        let categoriaActual = CategoriaManager.shared.categoriaNombre
        let productoRef = ref.child("CATEGORIAS").child(categoriaActual).child("productos").child(producto.titulo)

        let updatedData: [String: Any] = [
            "nombre": name,
            "precio": precio,
            "cantidad": quantity
        ]

        productoRef.updateChildValues(updatedData) { (error, _) in
            if let error = error {
                print("Error al actualizar producto: \(error.localizedDescription)")
            } else {
                print("Producto actualizado exitosamente")
            }
        }
    }
    
    @IBAction func btnAtras(_ sender: Any) {
        // Remover todos los observadores antes de salir
        let productosRef = ref.child("CATEGORIAS").child(CategoriaManager.shared.categoriaNombre).child("productos")
        productosRef.removeAllObservers()
        
        dismiss(animated: true, completion: nil)
    }
}
