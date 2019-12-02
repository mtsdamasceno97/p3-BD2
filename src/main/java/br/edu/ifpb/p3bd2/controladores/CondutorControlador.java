package br.edu.ifpb.p3bd2.controladores;

import br.edu.ifpb.p3bd2.modelo.Condutor;
import br.edu.ifpb.p3bd2.repositorio.CondutorRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/condutores")
public class CondutorControlador {


    private CondutorRepositorio condutorRepositorio;

    @Autowired
    public CondutorControlador(CondutorRepositorio condutorRepositorio) {
        this.condutorRepositorio = condutorRepositorio;
    }

    @GetMapping
    public String listarCondutores(Model model) {
        model.addAttribute("condutores", this.condutorRepositorio.findAll());
        return "condutores";
    }

    @PostMapping
    public String inserirCondutor(@ModelAttribute Condutor condutor) {

        this.condutorRepositorio.save(condutor);
        return "redirect:condutores";
    }

    @GetMapping("/inserir-condutor")
    public String inserirCondutorView(Model model) {
        model.addAttribute("condutor", new Condutor());
        return "inserir-condutor";
    }



}
