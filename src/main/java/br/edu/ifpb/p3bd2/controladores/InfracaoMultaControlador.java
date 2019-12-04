package br.edu.ifpb.p3bd2.controladores;

import br.edu.ifpb.p3bd2.repositorio.InfracaoMultaRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/infracaoMultas")
public class InfracaoMultaControlador {

    private InfracaoMultaRepositorio InfracaoMultaRepositorio;

    @Autowired
    public InfracaoMultaControlador(InfracaoMultaRepositorio InfracaoMultaRepositorio) {
        this.InfracaoMultaRepositorio = InfracaoMultaRepositorio;
    }

    @GetMapping
    public String listarVeiculoCondutor(Model model) {
        model.addAttribute("infracaoMultas", this.InfracaoMultaRepositorio.findAll());
        return "infracao-multa";
    }



}
