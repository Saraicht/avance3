import Foundation
class CategoriaManager {
    static let shared = CategoriaManager()
    
    var categoriaNombre: String = "" {
        didSet {
            // Notificar cuando cambie la categoría
            NotificationCenter.default.post(
                name: NSNotification.Name("CategoriaActualizada"),
                object: nil,
                userInfo: ["categoria": categoriaNombre]
            )
        }
    }
    
    private init() {}
    
    func updateCategoria(nombre: String) {
        categoriaNombre = nombre
    }
}
