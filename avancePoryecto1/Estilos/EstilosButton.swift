
import UIKit

// Constantes de diseño
struct DesignConstants {
    static let primaryColor = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0) // Fondo morado muy claro
    static let accentColor = UIColor(red: 0.4, green: 0.4, blue: 0.9, alpha: 1.0) // Azul/morado para acentos
    static let textColor = UIColor.darkGray
}

// Botón personalizado
class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        backgroundColor = .clear
        layer.cornerRadius = 12
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.white.cgColor
        setTitleColor(DesignConstants.textColor, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        // Sombra suave
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        // Estilo para botón flotante
        if tag == 100 {
            backgroundColor = DesignConstants.accentColor
            setImage(UIImage(systemName: "plus"), for: .normal)
            tintColor = .white
            layer.cornerRadius = 22
        }
    }
}

//Botones normales
class CustomButton2: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        backgroundColor = .white
        layer.cornerRadius = 12
        setTitleColor(DesignConstants.textColor, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        
        // Sombra suave
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        // Estilo para botón flotante
        if tag == 100 {
            backgroundColor = .gray
            setImage(UIImage(systemName: "plus"), for: .normal)
            tintColor = .white
            layer.cornerRadius = 22
        }
    }
}

// ImageView personalizada
class CustomImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        contentMode = .scaleAspectFit
        tintColor = DesignConstants.accentColor
        backgroundColor = .clear
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}

// SegmentedControl personalizado
class CustomSegmentedControl: UISegmentedControl {
    override init(items: [Any]?) {
        super.init(items: items)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        backgroundColor = .white
        selectedSegmentTintColor = .gray
        
        setTitleTextAttributes([
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ], for: .normal)
        
        setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ], for: .selected)
        
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}

// Etiqueta de título
class TitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        font = .systemFont(ofSize: 19, weight: .semibold)
        textColor = .white
        textAlignment = .left
    }
}

// Etiqueta de detalle
class DetailLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        font = .systemFont(ofSize: 11, weight: .regular)
        textColor = .white
        textAlignment = .left
    }
}

// TextField personalizado
class CustomTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        font = .systemFont(ofSize: 12)
        textColor = DesignConstants.textColor
        
        // Padding interno
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}

// TableView personalizado
class CustomTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        backgroundColor = .clear // Fondo transparente
        layer.borderWidth = 1.5 // Borde gris de la TableView
        layer.borderColor = UIColor.white.cgColor // Color gris para el borde
        separatorStyle = .none // Quitar el separador predeterminado
        showsVerticalScrollIndicator = false
        contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        // Establecer separación entre las celdas usando separatorInset
        self.separatorInset = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0) // Ajusta el espaciado horizontal
    }
}


// Celda de TableView personalizada
class CustomTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        backgroundColor = .clear // Fondo transparente
        layer.cornerRadius = 12
        layer.borderWidth = 1// Borde gris para la celda
        layer.borderColor = UIColor.white.cgColor // Color gris para el borde
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        selectionStyle = .none
        
        // Estilo del contentView
        contentView.backgroundColor = .clear // Fondo transparente
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        // Cambiar el color del texto a blanco
        textLabel?.textColor = .white
        
        // Agregar un pequeño margen (separación) entre las celdas
        layoutMargins = UIEdgeInsets(top: 1, left: 0, bottom: 5, right: 0) // Ajusta los márgenes
        preservesSuperviewLayoutMargins = true // Importante para que los márgenes se respeten
    }
}

