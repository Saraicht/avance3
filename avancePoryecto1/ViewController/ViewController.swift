import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let ref = Database.database().reference()
    var categorias: [Categoria] = []
    let colores: [UIColor] = [.red, .blue, .green, .brown]
    var categoriaSeleccionada: Categoria?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemPurple
        
        tableView.delegate = self
        tableView.dataSource = self
        cargarCategorias()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarCategorias()
    }
    
    func cargarCategorias() {
        ref.child("CATEGORIAS").observe(.value) { (snapshot) in
            self.categorias.removeAll()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let datos = snapshot.value as? [String: Any],
                   let nombre = datos["nombre"] as? String,
                   let color = datos["color"] as? Int {
                    let categoria = Categoria(nombre: nombre, color: color)
                    self.categorias.append(categoria)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoriaSeleccionada = categorias[indexPath.row]
        CategoriaManager.shared.updateCategoria(nombre: categoriaSeleccionada?.nombre ?? "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.performSegue(withIdentifier: "verProductos", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "CeldaPersonalizada", for: indexPath)
        let categoria = categorias[indexPath.row]
        
        if let labelTitulo = celda.viewWithTag(1) as? UILabel {
            labelTitulo.text = categoria.nombre
        }
        
        if let imageView = celda.viewWithTag(2) as? UIImageView {
            let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
            let colorIndex = min(categoria.color, colores.count - 1)
            let imagen = UIImage(systemName: "airport.express", withConfiguration: config)?
                .withTintColor(colores[colorIndex], renderingMode: .alwaysOriginal)
            imageView.image = imagen
            imageView.contentMode = .scaleAspectFit
        }
        
        return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let categoria = categorias[indexPath.row]
            ref.child("CATEGORIAS").child(categoria.nombre).removeValue { error, _ in
                if let error = error {
                    print("Error al eliminar categoría: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func btnAgregar(_ sender: Any) {
        performSegue(withIdentifier: "agregarCAT", sender: self)
    }
}
