import UIKit
import UserNotifications
import FirebaseAuth
import FirebaseFirestore

class Pantalla5DetalleServicioCliente: UIViewController, UNUserNotificationCenterDelegate {
    var tipoServicio: Pantalla4Servicios.TipoServicio?
    var costoServicio: String?

    private let tipoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let costoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        dp.preferredDatePickerStyle = .inline
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()

    private let confirmarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Confirmar cita", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupNotificationDelegate()
        confirmarButton.addTarget(self, action: #selector(confirmarCita), for: .touchUpInside)
        mostrarDatosServicio()
    }

    private func setupUI() {
        view.addSubview(tipoLabel)
        view.addSubview(costoLabel)
        view.addSubview(datePicker)
        view.addSubview(confirmarButton)

        NSLayoutConstraint.activate([
            tipoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            tipoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            costoLabel.topAnchor.constraint(equalTo: tipoLabel.bottomAnchor, constant: 20),
            costoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            datePicker.topAnchor.constraint(equalTo: costoLabel.bottomAnchor, constant: 30),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            confirmarButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 40),
            confirmarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmarButton.widthAnchor.constraint(equalToConstant: 200),
            confirmarButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func mostrarDatosServicio() {
        if let tipo = tipoServicio {
            switch tipo {
            case .instalacion:
                tipoLabel.text = "Tipo de servicio: Instalación"
            case .mantenimiento:
                tipoLabel.text = "Tipo de servicio: Mantenimiento"
            case .reparacion:
                tipoLabel.text = "Tipo de servicio: Reparación"
            }
        }
        costoLabel.text = "Costo: \(costoServicio ?? "-")"
    }

    private func setupNotificationDelegate() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            // Permiso solicitado
        }
    }

    @objc private func confirmarCita() {
        let fecha = datePicker.date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let fechaStr = formatter.string(from: fecha)
        // Guardar en Firestore
        guardarCitaEnFirestore(fecha: fecha, fechaStr: fechaStr)
    }

    private func guardarCitaEnFirestore(fecha: Date, fechaStr: String) {
        guard let user = Auth.auth().currentUser else {
            mostrarAlerta(titulo: "Error", mensaje: "No se encontró usuario autenticado.")
            return
        }
        let db = Firestore.firestore()
        let tipo: String
        switch tipoServicio {
        case .instalacion: tipo = "Instalación"
        case .mantenimiento: tipo = "Mantenimiento"
        case .reparacion: tipo = "Reparación"
        case .none: tipo = "-"
        }
        let data: [String: Any] = [
            "tipoServicio": tipo,
            "costo": costoServicio ?? "-",
            "fecha": Timestamp(date: fecha),
            "fechaStr": fechaStr
        ]
        db.collection("usuarios").document(user.uid).collection("servicios").addDocument(data: data) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo guardar la cita: \(error.localizedDescription)")
            } else {
                self.enviarNotificacionCita(fecha: fechaStr)
                self.irAMisServicios()
            }
        }
    }

    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }

    private func irAMisServicios() {
        let pantalla8 = Pantalla8MisServicios()
        self.navigationController?.setViewControllers([pantalla8], animated: true)
    }

    private func enviarNotificacionCita(fecha: String) {
        let content = UNMutableNotificationContent()
        content.title = "Cita programada"
        content.body = "Tu cita de servicio ha sido agendada para el \(fecha)"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "citaServicio", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    // Delegate para mostrar notificación en primer plano
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
