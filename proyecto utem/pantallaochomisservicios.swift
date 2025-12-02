import UIKit
import FirebaseAuth
import FirebaseFirestore

class Pantalla8MisServicios: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var servicios: [[String: Any]] = []
    private let tableView = UITableView()
    private let mensajeVacioLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "No tienes servicios agendados. ¡Agenda uno!"
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = .systemGray
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let imagenVacia: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "calendar.badge.exclamationmark")
        img.tintColor = .systemGray
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    private let botonAgregar: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Agregar servicio", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(nil, action: #selector(agregarServicio), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mis Servicios"
        view.backgroundColor = .systemBackground
        setupBotonAgregar() // Agregar primero el botón
        setupTableView()    // Luego la tabla
        fetchServicios()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ServicioCell")
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: botonAgregar.topAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupBotonAgregar() {
        view.addSubview(botonAgregar)
        NSLayoutConstraint.activate([
            botonAgregar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            botonAgregar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            botonAgregar.widthAnchor.constraint(equalToConstant: 200),
            botonAgregar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func mostrarMensajeVacio() {
        view.addSubview(imagenVacia)
        view.addSubview(mensajeVacioLabel)
        NSLayoutConstraint.activate([
            imagenVacia.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagenVacia.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imagenVacia.widthAnchor.constraint(equalToConstant: 80),
            imagenVacia.heightAnchor.constraint(equalToConstant: 80),
            mensajeVacioLabel.topAnchor.constraint(equalTo: imagenVacia.bottomAnchor, constant: 16),
            mensajeVacioLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mensajeVacioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mensajeVacioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }

    private func ocultarMensajeVacio() {
        imagenVacia.removeFromSuperview()
        mensajeVacioLabel.removeFromSuperview()
    }

    private func fetchServicios() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        db.collection("usuarios").document(user.uid).collection("servicios").order(by: "fecha", descending: false).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let docs = snapshot?.documents {
                self.servicios = docs.map { var dict = $0.data(); dict["id"] = $0.documentID; return dict }
                self.tableView.reloadData()
                if self.servicios.isEmpty {
                    self.mostrarMensajeVacio()
                } else {
                    self.ocultarMensajeVacio()
                }
            }
        }
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicioCell", for: indexPath)
        let servicio = servicios[indexPath.row]
        let tipo = servicio["tipoServicio"] as? String ?? "-"
        let costo = servicio["costo"] as? String ?? "-"
        let fecha = servicio["fechaStr"] as? String ?? "-"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "Tipo: \(tipo)\nCosto: \(costo)\nFecha: \(fecha)"
        return cell
    }

    // MARK: - TableView Delegate (Eliminar servicio)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let eliminar = UIContextualAction(style: .destructive, title: "Cancelar") { [weak self] _, _, completion in
            self?.eliminarServicio(at: indexPath)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [eliminar])
    }

    private func eliminarServicio(at indexPath: IndexPath) {
        guard let user = Auth.auth().currentUser else { return }
        let servicio = servicios[indexPath.row]
        guard let id = servicio["id"] as? String else { return }
        let db = Firestore.firestore()
        db.collection("usuarios").document(user.uid).collection("servicios").document(id).delete { [weak self] error in
            if error == nil {
                self?.servicios.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                if self?.servicios.isEmpty == true {
                    self?.mostrarMensajeVacio()
                }
            }
        }
    }

    @objc private func agregarServicio() {
        let pantalla4 = Pantalla4Servicios()
        navigationController?.pushViewController(pantalla4, animated: true)
    }
}
