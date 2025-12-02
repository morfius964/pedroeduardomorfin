import UIKit
import MapKit

class Pantalla4Servicios: UIViewController {

    // MARK: - Título
    private let titulo: UILabel = {
        let lbl = UILabel()
        lbl.text = "Servicios"
        lbl.font = UIFont.boldSystemFont(ofSize: 32)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    // MARK: - Enum para tipos de servicio
    enum TipoServicio: Int {
        case instalacion = 1
        case mantenimiento = 2
        case reparacion = 3
    }

    // MARK: - Función para crear botones con gradiente y tipo de servicio
    private func crearBoton(titulo: String, colores: [UIColor], tipoServicio: TipoServicio) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(titulo, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = tipoServicio.rawValue // Asocia el tipo de servicio con el botón
        
        // Gradiente
        let gradient = CAGradientLayer()
        gradient.colors = colores.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 12
        gradient.frame = CGRect(x: 0, y: 0, width: 250, height: 50)
        btn.layer.insertSublayer(gradient, at: 0)
        return btn
    }

    // MARK: - Botones de servicios
    private lazy var botonInstalacion = crearBoton(titulo: "Instalación", colores: [UIColor.systemGreen, UIColor.systemTeal], tipoServicio: .instalacion)
    private lazy var botonMantenimiento = crearBoton(titulo: "Mantenimiento", colores: [UIColor.systemOrange, UIColor.systemYellow], tipoServicio: .mantenimiento)
    private lazy var botonReparacion = crearBoton(titulo: "Reparación", colores: [UIColor.systemRed, UIColor.systemPink], tipoServicio: .reparacion)
    private lazy var botonMisServicios = crearBoton(titulo: "Mis Servicios", colores: [UIColor.systemBlue, UIColor.systemTeal], tipoServicio: .reparacion)

    // MARK: - Etiquetas de precio
    private let instalacionPrecioLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Precio: $1800"
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let mantenimientoPrecioLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Precio: $700"
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let reparacionPrecioLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Precio: $1000"
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    // MARK: - Botón de ubicación
    private let ubicacionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Ubicación: Manzanillo Centro", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.7)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Botón volver
    private lazy var botonVolver: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Volver", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.systemYellow
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(volverPantallaAnterior), for: .touchUpInside)
        return btn
    }()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarFondo()
        configurarUI()
        
        // Acciones de botones
        botonInstalacion.addTarget(self, action: #selector(irADetalleServicios(_:)), for: .touchUpInside)
        botonMantenimiento.addTarget(self, action: #selector(irADetalleServicios(_:)), for: .touchUpInside)
        botonReparacion.addTarget(self, action: #selector(irADetalleServicios(_:)), for: .touchUpInside)
        botonMisServicios.addTarget(self, action: #selector(irAMisServicios), for: .touchUpInside)
        ubicacionButton.addTarget(self, action: #selector(abrirMapaManzanillo), for: .touchUpInside)
    }

    // MARK: - Configuración de fondo
    private func configurarFondo() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }

    // MARK: - Configuración de UI
    private func configurarUI() {
        [titulo, botonInstalacion, instalacionPrecioLabel,
         botonMantenimiento, mantenimientoPrecioLabel,
         botonReparacion, reparacionPrecioLabel,
         botonMisServicios, ubicacionButton, botonVolver].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            titulo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titulo.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            botonInstalacion.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 60),
            botonInstalacion.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            botonInstalacion.widthAnchor.constraint(equalToConstant: 250),
            botonInstalacion.heightAnchor.constraint(equalToConstant: 50),
            
            instalacionPrecioLabel.topAnchor.constraint(equalTo: botonInstalacion.bottomAnchor, constant: 5),
            instalacionPrecioLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            botonMantenimiento.topAnchor.constraint(equalTo: instalacionPrecioLabel.bottomAnchor, constant: 20),
            botonMantenimiento.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            botonMantenimiento.widthAnchor.constraint(equalToConstant: 250),
            botonMantenimiento.heightAnchor.constraint(equalToConstant: 50),
            
            mantenimientoPrecioLabel.topAnchor.constraint(equalTo: botonMantenimiento.bottomAnchor, constant: 5),
            mantenimientoPrecioLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            botonReparacion.topAnchor.constraint(equalTo: mantenimientoPrecioLabel.bottomAnchor, constant: 20),
            botonReparacion.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            botonReparacion.widthAnchor.constraint(equalToConstant: 250),
            botonReparacion.heightAnchor.constraint(equalToConstant: 50),
            
            reparacionPrecioLabel.topAnchor.constraint(equalTo: botonReparacion.bottomAnchor, constant: 5),
            reparacionPrecioLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            botonMisServicios.topAnchor.constraint(equalTo: reparacionPrecioLabel.bottomAnchor, constant: 30),
            botonMisServicios.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            botonMisServicios.widthAnchor.constraint(equalToConstant: 250),
            botonMisServicios.heightAnchor.constraint(equalToConstant: 50),

            ubicacionButton.topAnchor.constraint(equalTo: botonMisServicios.bottomAnchor, constant: 20),
            ubicacionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ubicacionButton.widthAnchor.constraint(equalToConstant: 250),
            ubicacionButton.heightAnchor.constraint(equalToConstant: 40),

            botonVolver.topAnchor.constraint(equalTo: ubicacionButton.bottomAnchor, constant: 20),
            botonVolver.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            botonVolver.widthAnchor.constraint(equalToConstant: 120),
            botonVolver.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // MARK: - Navegación
    @objc private func irADetalleServicios(_ sender: UIButton) {
        guard let tipoServicio = TipoServicio(rawValue: sender.tag) else { return }
        let nombreServicio = sender.titleLabel?.text ?? "Servicio"
        var costo = "-"
        switch tipoServicio {
        case .instalacion:
            costo = instalacionPrecioLabel.text?.replacingOccurrences(of: "Precio: ", with: "") ?? "-"
        case .mantenimiento:
            costo = mantenimientoPrecioLabel.text?.replacingOccurrences(of: "Precio: ", with: "") ?? "-"
        case .reparacion:
            costo = reparacionPrecioLabel.text?.replacingOccurrences(of: "Precio: ", with: "") ?? "-"
        }
        let pantalla5 = Pantalla5DetalleServicioCliente()
        pantalla5.tipoServicio = tipoServicio
        pantalla5.costoServicio = costo
        navigationController?.pushViewController(pantalla5, animated: true)
    }

    @objc private func irAMisServicios() {
        //let pantalla8 = Pantalla8MisServicios()
        let pantalla8 = UIViewController()
        navigationController?.pushViewController(pantalla8, animated: true)
    }

    @objc private func volverPantallaAnterior() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func abrirMapaManzanillo() {
        let latitude: CLLocationDegrees = 19.0522
        let longitude: CLLocationDegrees = -104.3236
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let regionDistance: CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegion(center: coordinates,
                                            latitudinalMeters: regionDistance,
                                            longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Manzanillo Centro"
        mapItem.openInMaps(launchOptions: options)
    }
}
