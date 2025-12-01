import UIKit

class PantallaTresVerificacion: UIViewController {

    var codigoEsperado: String?

    private let titulo: UILabel = {
        let lbl = UILabel()
        lbl.text = "Verificación en Dos Pasos"
        lbl.font = UIFont.boldSystemFont(ofSize: 28)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        return lbl
    }()

    private let descripcion: UILabel = {
        let lbl = UILabel()
        lbl.text = "Ingresa el código enviado a tu teléfono para continuar."
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let codigoInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Código de verificación"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let botonConfirmar: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Confirmar", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarFondo()
        configurarUI()
        configurarBotonGradient()
        botonConfirmar.addTarget(self, action: #selector(validarCodigo), for: .touchUpInside)
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
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 12
        gradient.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        botonConfirmar.layer.insertSublayer(gradient, at: 0)
    }

    private func configurarUI() {
        [titulo, descripcion, codigoInput, botonConfirmar].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            titulo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titulo.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            descripcion.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 12),
            descripcion.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            descripcion.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),

            codigoInput.topAnchor.constraint(equalTo: descripcion.bottomAnchor, constant: 40),
            codigoInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            codigoInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            codigoInput.heightAnchor.constraint(equalToConstant: 45),

            botonConfirmar.topAnchor.constraint(equalTo: codigoInput.bottomAnchor, constant: 40),
            botonConfirmar.widthAnchor.constraint(equalToConstant: 200),
            botonConfirmar.heightAnchor.constraint(equalToConstant: 50),
            botonConfirmar.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func validarCodigo() {
        guard let codigoIngresado = codigoInput.text, !codigoIngresado.isEmpty else {
            mostrarAlerta(titulo: "Error", mensaje: "Por favor ingresa el código.")
            return
        }

        if codigoIngresado == codigoEsperado {
            let alerta = UIAlertController(title: "Éxito", message: "Código verificado correctamente.", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                let pantalla4 = Pantalla4Servicios()
                self.navigationController?.pushViewController(pantalla4, animated: true)
            }))
            present(alerta, animated: true)
        } else {
            mostrarAlerta(titulo: "Código incorrecto", mensaje: "El código ingresado no es válido.")
        }
    }

    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }
}


