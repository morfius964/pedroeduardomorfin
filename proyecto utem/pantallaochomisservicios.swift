//import UIKit
//
//class Pantalla8MisServicios: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    private let titulo: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "Mis Servicios Agendados"
//        lbl.font = UIFont.boldSystemFont(ofSize: 28)
//        lbl.textAlignment = .center
//        lbl.textColor = .white
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//
//    private let mensajeConfirmadoLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "¡Servicio Confirmado! ServiClimas Manzanillo le agradece su preferencia"
//        lbl.font = UIFont.boldSystemFont(ofSize: 20)
//        lbl.textColor = .white
//        lbl.textAlignment = .center
//        lbl.numberOfLines = 0
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.isHidden = true
//        return lbl
//    }()
//
//    private let tablaServicios: UITableView = {
//        let tv = UITableView()
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
//        tv.separatorStyle = .singleLine
//        tv.layer.cornerRadius = 12
//        tv.clipsToBounds = true
//        return tv
//    }()
//
//    private let stackBotonesInferior: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.alignment = .fill
//        stack.spacing = 15
//        stack.distribution = .fillEqually
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        return stack
//    }()
//
//    private lazy var botonCompartir: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("Compartir app", for: .normal)
//        btn.setTitleColor(.white, for: .normal)
//        btn.backgroundColor = UIColor.systemGreen
//        btn.layer.cornerRadius = 12
//        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        btn.addTarget(self, action: #selector(compartirApp), for: .touchUpInside)
//        return btn
//    }()
//
//    private lazy var botonVolverInicio: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("Volver al inicio", for: .normal)
//        btn.setTitleColor(.white, for: .normal)
//        btn.backgroundColor = UIColor.systemBlue
//        btn.layer.cornerRadius = 12
//        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        btn.addTarget(self, action: #selector(volverAlInicio), for: .touchUpInside)
//        return btn
//    }()
//
//    private lazy var botonSalir: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("Salir de la app", for: .normal)
//        btn.setTitleColor(.white, for: .normal)
//        btn.backgroundColor = UIColor.systemRed
//        btn.layer.cornerRadius = 12
//        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        btn.addTarget(self, action: #selector(salirApp), for: .touchUpInside)
//        return btn
//    }()
//
//    private var servicios: [ServicioAgendado] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.systemBlue
//        configurarUI()
//        tablaServicios.delegate = self
//        tablaServicios.dataSource = self
//        tablaServicios.register(UITableViewCell.self, forCellReuseIdentifier: "celdaServicio")
//        servicios = GestorServicios.shared.servicios
//        mensajeConfirmadoLabel.isHidden = !servicios.contains { $0.estado == "Confirmado" }
//    }
//
//    private func configurarUI() {
//        view.addSubview(titulo)
//        view.addSubview(mensajeConfirmadoLabel)
//        view.addSubview(tablaServicios)
//        view.addSubview(stackBotonesInferior)
//
//        stackBotonesInferior.addArrangedSubview(botonCompartir)
//        stackBotonesInferior.addArrangedSubview(botonVolverInicio)
//        stackBotonesInferior.addArrangedSubview(botonSalir)
//
//        NSLayoutConstraint.activate([
//            titulo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            titulo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            mensajeConfirmadoLabel.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 20),
//            mensajeConfirmadoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            mensajeConfirmadoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//
//            tablaServicios.topAnchor.constraint(equalTo: mensajeConfirmadoLabel.bottomAnchor, constant: 20),
//            tablaServicios.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            tablaServicios.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            tablaServicios.bottomAnchor.constraint(equalTo: stackBotonesInferior.topAnchor, constant: -20),
//
//            stackBotonesInferior.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            stackBotonesInferior.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            stackBotonesInferior.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            stackBotonesInferior.heightAnchor.constraint(equalToConstant: 180)
//        ])
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return servicios.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let servicio = servicios[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaServicio", for: indexPath)
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "es_ES")
//        dateFormatter.dateFormat = "EEEE, dd MMM yyyy"
//        let fechaConDia = dateFormatter.string(from: servicio.fecha).capitalized
//
//        cell.textLabel?.numberOfLines = 0
//        cell.textLabel?.text = """
//        Servicio: \(servicio.nombre)
//        Fecha: \(fechaConDia) Hora: \(servicio.hora)
//        Estado: \(servicio.estado)
//        """
//
//        switch servicio.estado {
//        case "Confirmado": cell.textLabel?.textColor = .white
//        case "Pendiente": cell.textLabel?.textColor = .systemYellow
//        case "Cancelado": cell.textLabel?.textColor = .systemGray
//        default: cell.textLabel?.textColor = .white
//        }
//
//        cell.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.6)
//        cell.layer.cornerRadius = 12
//        cell.selectionStyle = .none
//        return cell
//    }
//
//    @objc private func compartirApp() {
//        let texto = "Descarga la app de ServiClimas Manzanillo: [enlace a la app]"
//        let activityVC = UIActivityViewController(activityItems: [texto], applicationActivities: nil)
//        present(activityVC, animated: true)
//    }
//
//    @objc private func volverAlInicio() {
//        navigationController?.popToRootViewController(animated: true)
//    }
//
//    @objc private func salirApp() {
//        exit(0)
//    }
//}
//
