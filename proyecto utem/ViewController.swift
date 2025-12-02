import UIKit
import FirebaseAuth
class PantallaLogin: UIViewController {
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logoServiClimas")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titulo: UILabel = {
        let lbl = UILabel()
        lbl.text = "Bienvenido"
        lbl.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let subtitulo: UILabel = {
        let lbl = UILabel()
        lbl.text = "SERVICLIMAS Manzanillo"
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        lbl.textColor = UIColor(white: 1.0, alpha: 0.8)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let calificaLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "¡Califica mi servicio! Tu opinión nos interesa"
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let estrellasStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let estrellasLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0 estrellas seleccionadas"
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let telefonoInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Teléfono"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .phonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView(image: UIImage(systemName: "phone.fill"))
        imageView.tintColor = .systemGray
        tf.leftView = imageView
        tf.leftViewMode = .always
        return tf
    }()
    
    private let passInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Contraseña"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView(image: UIImage(systemName: "lock.fill"))
        imageView.tintColor = .systemGray
        tf.leftView = imageView
        tf.leftViewMode = .always
        return tf
    }()
    
    private let botonLogin: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Iniciar sesión", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 12
        gradient.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        btn.layer.insertSublayer(gradient, at: 0)
        return btn
    }()
    
    private var calificacion: Int = 0 {
        didSet {
            actualizarEstrellasLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarFondo()
        configurarUI()
        botonLogin.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        crearEstrellasInteractivas()
    }
    
    private func configurarFondo() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        view.backgroundColor = .white
    }
    
    private func configurarUI() {
        [logoImageView, titulo, subtitulo, telefonoInput, botonLogin].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            titulo.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titulo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitulo.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 10),
            subtitulo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            telefonoInput.topAnchor.constraint(equalTo: subtitulo.bottomAnchor, constant: 20),
            telefonoInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            telefonoInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            telefonoInput.heightAnchor.constraint(equalToConstant: 50),
            
            botonLogin.topAnchor.constraint(equalTo: telefonoInput.bottomAnchor, constant: 40),
            botonLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            botonLogin.widthAnchor.constraint(equalToConstant: 200),
            botonLogin.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func crearEstrellasInteractivas() {
        for i in 1...5 {
            let estrella = UIButton()
            estrella.tag = i
            estrella.setImage(UIImage(systemName: "star"), for: .normal)
            estrella.tintColor = .white
            estrella.addTarget(self, action: #selector(seleccionarEstrella(_:)), for: .touchUpInside)
            estrellasStack.addArrangedSubview(estrella)
        }
    }
    
    @objc private func seleccionarEstrella(_ sender: UIButton) {
        calificacion = sender.tag
        actualizarEstrellas()
    }
    
    private func actualizarEstrellas() {
        for case let estrella as UIButton in estrellasStack.arrangedSubviews {
            if estrella.tag <= calificacion {
                estrella.setImage(UIImage(systemName: "star.fill"), for: .normal)
                estrella.tintColor = .systemYellow
            } else {
                estrella.setImage(UIImage(systemName: "star"), for: .normal)
                estrella.tintColor = .white
            }
        }
    }
    
    private func actualizarEstrellasLabel() {
        estrellasLabel.text = "\(calificacion) estrella\(calificacion == 1 ? "" : "s") seleccionada\(calificacion == 1 ? "" : "s")"
    }
    
    @objc private func loginAction() {
        if let tel = self.telefonoInput.text {
            let numtel = "+52\(tel)"
            UserDefaults.standard.set(numtel, forKey: "authVerificationIDNumber")
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(numtel, uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        //self.showMessagePrompt(error.localizedDescription)
                        return
                    }
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    print(UserDefaults.standard.string(forKey: "authVerificationIDNumber") ?? "")
                    let pantalla3 = PantallaTresVerificacion()
                    self.navigationController?.pushViewController(pantalla3, animated: true)
                    
                }
        }
        //        guard let telefono = telefonoInput.text, !telefono.isEmpty,
        //              let contraseña = passInput.text, !contraseña.isEmpty else {
        //            let alert = UIAlertController(title: "Error", message: "Por favor ingresa teléfono y contraseña.", preferredStyle: .alert)
        //            alert.addAction(UIAlertAction(title: "OK", style: .default))
        //            present(alert, animated: true)
        //            return
        //        }
        //
        //        UIView.animate(withDuration: 0.2,
        //                       animations: { self.botonLogin.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) },
        //                       completion: { _ in
        //                           UIView.animate(withDuration: 0.2) { self.botonLogin.transform = CGAffineTransform.identity }
        //                       })
        //
        //        print("Usuario calificado con \(calificacion) ⭐️")
        //
        //        let usuarioRegistrado = false
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //            if usuarioRegistrado {
        //                let pantalla3 = PantallaTresVerificacion()
        //                self.navigationController?.pushViewController(pantalla3, animated: true)
        //            } else {
        //                let pantalla2 = PantallaDosIniciarSesion()
        //                self.navigationController?.pushViewController(pantalla2, animated: true)
        //            }
        //        }
        
        
    }
}


