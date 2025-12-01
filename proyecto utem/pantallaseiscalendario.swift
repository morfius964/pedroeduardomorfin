import UIKit

class Pantalla6Calendario: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var servicioSeleccionado: String?
    private let titulo: UILabel = {
        let lbl = UILabel()
        lbl.text = "Seleccione fecha y hora"
        lbl.font = UIFont.boldSystemFont(ofSize: 28)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let calendar: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.minimumDate = Date()
        dp.preferredDatePickerStyle = .inline
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()

    private let tablaHorarios: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 12
        tv.clipsToBounds = true
        tv.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        return tv
    }()

    private let botonSiguiente: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Siguiente", for: .normal)
        btn.backgroundColor = UIColor.systemGreen
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let botonVolver: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Volver", for: .normal)
        btn.backgroundColor = UIColor.systemYellow
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let horarios: [String] = ["09:00 AM", "11:00 AM", "01:00 PM", "03:00 PM", "05:00 PM"]
    private var horarioSeleccionado: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarFondo()
        configurarUI()
        tablaHorarios.delegate = self
        tablaHorarios.dataSource = self
 tablaHorarios.register(UITableViewCell.self, forCellReuseIdentifier: "celdaHorario")
        botonSiguiente.addTarget(self, action: #selector(irAConfirmacion), for: .touchUpInside)
        botonVolver.addTarget(self, action: #selector(volverPantallaAnterior), for: .touchUpInside)
    }

    private func configurarFondo() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }

    private func configurarUI() {
        [titulo, calendar, tablaHorarios, botonSiguiente, botonVolver].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            titulo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titulo.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            calendar.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 20),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tablaHorarios.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20),
            tablaHorarios.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tablaHorarios.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tablaHorarios.heightAnchor.constraint(equalToConstant: 250),

            botonSiguiente.topAnchor.constraint(equalTo: tablaHorarios.bottomAnchor, constant: 20),
            botonSiguiente.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            botonSiguiente.widthAnchor.constraint(equalToConstant: 220),
            botonSiguiente.heightAnchor.constraint(equalToConstant: 50),

            botonVolver.topAnchor.constraint(equalTo: botonSiguiente.bottomAnchor, constant: 15),
            botonVolver.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            botonVolver.widthAnchor.constraint(equalToConstant: 120),
            botonVolver.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return horarios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaHorario", for: indexPath)
        let hora = horarios[indexPath.row]
        cell.textLabel?.text = hora
        cell.textLabel?.textColor = .white
        cell.backgroundColor = horarioSeleccionado == hora ? UIColor.systemGreen : UIColor.systemBlue.withAlphaComponent(0.6)
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        horarioSeleccionado = horarios[indexPath.row]
        tableView.reloadData()
    }

    @objc private func irAConfirmacion() {
        guard let horario = horarioSeleccionado else { return }
        let pantalla = Pantalla7Confirmacion()
        pantalla.servicioSeleccionado = servicioSeleccionado
        pantalla.fechaSeleccionada = calendar.date
        pantalla.horarioSeleccionado = horario
        navigationController?.pushViewController(pantalla, animated: true)
    }

    @objc private func volverPantallaAnterior() {
        navigationController?.popViewController(animated: true)
    }
}

