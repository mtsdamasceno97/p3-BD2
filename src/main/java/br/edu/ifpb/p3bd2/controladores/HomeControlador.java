package br.edu.ifpb.p3bd2.controladores;

import br.edu.ifpb.p3bd2.modelo.Veiculo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class HomeControlador {

    @GetMapping("/home")
    public String exibirHome() {
        return "home";
    }
}
