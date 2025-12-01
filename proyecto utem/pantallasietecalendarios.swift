import UIKit
import UserNotifications

class Pantalla7Confirmacion: UIViewController {

    var servicioSeleccionado: String?
    var fechaSeleccionada: Date?
    var horarioSeleccionado: String?

    private let titulo: UILabel = {
        let lbl = UILabel()
        lbl.text = "Confirmación de Cita"
        lbl.font = UIFont.boldSystemFont(ofSize: 26)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let mensaje: UILabel = {
        let lbl = UILabel()
        lbl.text = "Tu cita fue registrada correctamente."
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let detallesLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var botonFinalizar: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Finalizar", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(enviarNotificaciones), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        configurarUI()
        mostrarDetalles()
        pedirPermisoNotificaciones()
    }

    private func configurarUI() {
        view.addSubview(titulo)
        view.addSubview(mensaje)
        view.addSubview(detallesLabel)
        view.addSubview(botonFinalizar)

        NSLayoutConstraint.activate([
            titulo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titulo.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            mensaje.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 20),
            mensaje.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mensaje.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            detallesLabel.topAnchor.constraint(equalTo: mensaje.bottomAnchor, constant: 16),
            detallesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detallesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            botonFinalizar.topAnchor.constraint(equalTo: detallesLabel.bottomAnchor, constant: 40),
            botonFinalizar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            botonFinalizar.widthAnchor.constraint(equalToConstant: 200),
            botonFinalizar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func mostrarDetalles() {
        var partes: [String] = []
        if let servicio = servicioSeleccionado {
            partes.append("Servicio: \(servicio)")
        }
        if let fecha = fechaSeleccionada {
            let df = DateFormatter()
            df.locale = Locale(identifier: "es_ES")
            df.dateFormat = "EEEE, dd MMM yyyy"
            let fechaStr = df.string(from: fecha).capitalized
            partes.append("Fecha: \(fechaStr)")
        }
        if let hora = horarioSeleccionado {
            partes.append("Hora: \(hora)")
        }
        detallesLabel.text = partes.joined(separator: "\n")
    }

    private func pedirPermisoNotificaciones() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        UNUserNotificationCenter.current().delegate = self
    }

    @objc private func enviarNotificaciones() {
        enviarNotificacionCliente()
        enviarNotificacionProveedor()

        let alert = UIAlertController(title: "Listo", message: "Se enviaron las notificaciones.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }

    private func enviarNotificacionCliente() {
        let content = UNMutableNotificationContent()
        content.title = "Cita Confirmada"
        content.body = "Su cita fue registrada correctamente."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "cliente_notificacion", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    private func enviarNotificacionProveedor() {
        let content = UNMutableNotificationContent()
        content.title = "Nueva Cita Registrada"
        content.body = "Un cliente agendó una cita."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "proveedor_notificacion", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

extension Pantalla7Confirmacion: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

