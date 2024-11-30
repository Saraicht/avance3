//
//  ViewControllerInforme.swift
//  avancePoryecto1
//
//  Created by sarai choqquepata tapia on 30/11/24.
//
import UIKit
import FirebaseDatabase

struct ProductoModelo {
    let nombre: String
    let precio: Double
    let cantidad: Int
    let fecha: Date
}

class ViewControllerInforme: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exportarButton: UIButton! // Botón de exportar

    var productos: [ProductoModelo] = []
    var productosFiltrados: [ProductoModelo] = []
    let ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductoCell")
        cargarProductosDeTodasLasCategorias()
        
        configurarBotonExportar()
    }

    // Cargar productos desde todas las categorías
    func cargarProductosDeTodasLasCategorias() {
        ref.child("CATEGORIAS").observeSingleEvent(of: .value) { snapshot in
            guard let categorias = snapshot.children.allObjects as? [DataSnapshot] else {
                print("No se encontraron categorías")
                return
            }

            self.productos.removeAll()

            for categoriaSnapshot in categorias {
                if let productosSnapshot = categoriaSnapshot.childSnapshot(forPath: "productos").children.allObjects as? [DataSnapshot] {
                    for productoSnapshot in productosSnapshot {
                        if let productoData = productoSnapshot.value as? [String: Any],
                           let nombre = productoData["nombre"] as? String,
                           let precio = productoData["precio"] as? Double,
                           let cantidad = productoData["cantidad"] as? Int,
                           let timestamp = productoData["fechaCreacion"] as? Double {
                            let fecha = Date(timeIntervalSince1970: timestamp / 1000)

                            let producto = ProductoModelo(nombre: nombre, precio: precio, cantidad: cantidad, fecha: fecha)
                            self.productos.append(producto)
                        }
                    }
                }
            }

            self.productosFiltrados = self.productos
            self.tableView.reloadData()
        }
    }

    // Filtrar productos según la búsqueda
    func filtrarProductos() {
        let textoBusqueda = searchBar.text?.lowercased() ?? ""
        productosFiltrados = productos.filter { producto in
            return textoBusqueda.isEmpty || producto.nombre.lowercased().contains(textoBusqueda)
        }
        tableView.reloadData()
    }

    // Configurar el botón de exportar
    func configurarBotonExportar() {
        exportarButton.setTitle("", for: .normal) // Eliminar texto
        let icono = UIImage(systemName: "square.and.arrow.down")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        exportarButton.setImage(icono, for: .normal)
        exportarButton.layer.cornerRadius = 10
        exportarButton.backgroundColor = .systemBlue
    }

    // Exportar datos como PDF
    @IBAction func exportarComoPDF() {
        let pdfMetaData: [String: Any] = [
            kCGPDFContextCreator as String: "Tu App",
            kCGPDFContextAuthor as String: "Tu Nombre"
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData

        let pageWidth = 612.0 // 8.5 * 72.0 (tamaño carta)
        let pageHeight = 792.0 // 11 * 72.0
        let pageSize = CGSize(width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize), format: format)
        let data = renderer.pdfData { context in
            context.beginPage()

            let attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
            ]
            
            var yPosition: CGFloat = 50
            let xPosition: CGFloat = 20

            for producto in productos {
                let text = "\(producto.nombre) - \(producto.cantidad) unidades - $\(producto.precio)"
                text.draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                yPosition += 25 // Espaciado entre líneas
            }
        }

        // Guardar el PDF en un archivo
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Exportado.pdf")
        do {
            try data.write(to: url)
            print("PDF guardado en: \(url)")
            mostrarAlertaConOpcionAbrirArchivo(url: url)
        } catch {
            print("Error al guardar el PDF: \(error)")
        }
    }

    // Mostrar alerta para abrir el archivo PDF
    func mostrarAlertaConOpcionAbrirArchivo(url: URL) {
        let alert = UIAlertController(title: "PDF Generado", message: "El archivo PDF se generó correctamente. ¿Deseas abrirlo?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Abrir", style: .default, handler: { _ in
            UIApplication.shared.open(url)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Extensiones para la tabla y el buscador
extension ViewControllerInforme: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productosFiltrados.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCell", for: indexPath)
        let producto = productosFiltrados[indexPath.row]
        celda.textLabel?.text = "\(producto.nombre) - \(producto.cantidad) unidades - $\(producto.precio)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        celda.detailTextLabel?.text = dateFormatter.string(from: producto.fecha)
        return celda
    }
}

extension ViewControllerInforme: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtrarProductos()
    }
}

