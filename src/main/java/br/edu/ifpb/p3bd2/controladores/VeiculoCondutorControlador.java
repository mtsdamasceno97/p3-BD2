package br.edu.ifpb.p3bd2.controladores;

import br.edu.ifpb.p3bd2.repositorio.VeiculoCondutorRepositorio;
import br.edu.ifpb.p3bd2.repositorio.condutorCarteiraRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/veiculoCondutor")
public class VeiculoCondutorControlador {

    private VeiculoCondutorRepositorio VeiculoCondutorRepositorio;

    @Autowired
    public VeiculoCondutorControlador(VeiculoCondutorRepositorio VeiculoCondutorRepositorio) {
        this.VeiculoCondutorRepositorio = VeiculoCondutorRepositorio;
    }

    @GetMapping
    public String listarVeiculoCondutor(Model model) {
        model.addAttribute("veiculosCondutores", this.VeiculoCondutorRepositorio.findAll());
        return "veiculo-condutor";
    }

}