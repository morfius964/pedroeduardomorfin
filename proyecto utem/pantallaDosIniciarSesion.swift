import UIKit

class PantallaDosIniciarSesion: UIViewController {

    private let tituloPantalla: UILabel = {
        let lbl = UILabel()
        lbl.text = "Iniciar Sesión"
        lbl.font = UIFont.boldSystemFont(ofSize: 32)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        return lbl
    }()

    private let correoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Correo electrónico"
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        return lbl
    }()

    private let correoInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "ejemplo@correo.com"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let passLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Contraseña"
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        return lbl
    }()

    private let passInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Ingresa tu contraseña"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let botonIniciar: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Iniciar sesión", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private var codigoTemporal: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarFondo()
        configurarUI()
        configurarBotonGradient()
        botonIniciar.addTarget(self, action: #selector(iniciarSesion), for: .touchUpInside)
    }

    private func configurarFondo() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }

    private func configurarBotonGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemTeal.cgColor, UIColor.systemBlue.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 12
        gradient.frame = CGRect(x: 0, y: 0, width: 220, height: 50)
        botonIniciar.layer.insertSublayer(gradient, at: 0)
    }

    private func configurarUI() {
        let elementos = [tituloPantalla, correoLabel, correoInput, passLabel, passInput, botonIniciar]
        elementos.forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            tituloPantalla.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            tituloPantalla.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            correoLabel.topAnchor.constraint(equalTo: tituloPantalla.bottomAnchor, constant: 40),
            correoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),

            correoInput.topAnchor.constraint(equalTo: correoLabel.bottomAnchor, constant: 8),
            correoInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            correoInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            correoInput.heightAnchor.constraint(equalToConstant: 45),

            passLabel.topAnchor.constraint(equalTo: correoInput.bottomAnchor, constant: 20),
            passLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),

            passInput.topAnchor.constraint(equalTo: passLabel.bottomAnchor, constant: 8),
            passInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passInput.heightAnchor.constraint(equalToConstant: 45),

            botonIniciar.topAnchor.constraint(equalTo: passInput.bottomAnchor, constant: 40),
            botonIniciar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            botonIniciar.widthAnchor.constraint(equalToConstant: 220),
            botonIniciar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func iniciarSesion() {
        let correoCorrecto = "prueba@serviclimas.com"
        let contrasenaCorrecta = "12345"

        guard let correoIngresado = correoInput.text,
              let contrasenaIngresada = passInput.text else { return }

        if correoIngresado == correoCorrecto && contrasenaIngresada == contrasenaCorrecta {
            codigoTemporal = "123456"
            let pantalla3 = PantallaTresVerificacion()
            pantalla3.codigoEsperado = codigoTemporal
            navigationController?.pushViewController(pantalla3, animated: true)
        } else {
            let alerta = UIAlertController(title: "Error", message: "Correo o contraseña incorrectos", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
        }
    }
}
