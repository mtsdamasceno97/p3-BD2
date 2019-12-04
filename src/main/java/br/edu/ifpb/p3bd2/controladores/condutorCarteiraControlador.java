package br.edu.ifpb.p3bd2.controladores;

import br.edu.ifpb.p3bd2.repositorio.CondutorRepositorio;
import br.edu.ifpb.p3bd2.repositorio.condutorCarteiraRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/condutorCarteira")
public class condutorCarteiraControlador {

    private condutorCarteiraRepositorio condutorCarteiraRepositorio;

    @Autowired
    public condutorCarteiraControlador(condutorCarteiraRepositorio condutorCarteiraRepositorio) {
        this.condutorCarteiraRepositorio = condutorCarteiraRepositorio;
    }

    @GetMapping
    public String listarCondutorCarteira(Model model) {
        model.addAttribute("condutoresCarteira", this.condutorCarteiraRepositorio.findAll());
        return "condutor-carteira";
    }

}
