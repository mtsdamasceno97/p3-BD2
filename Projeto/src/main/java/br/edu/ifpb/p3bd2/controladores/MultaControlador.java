package br.edu.ifpb.p3bd2.controladores;

import br.edu.ifpb.p3bd2.modelo.Multa;
import br.edu.ifpb.p3bd2.repositorio.MultaRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/multas")
public class MultaControlador {


        private MultaRepositorio multaRepositorio;

        @Autowired
        public MultaControlador(MultaRepositorio multaRepositorio) {
            this.multaRepositorio = multaRepositorio;
        }

        @GetMapping
        public String listarMultas(Model model) {
            model.addAttribute("multas", this.multaRepositorio.findAll());
            return "multas";
        }

        @PostMapping
        public String inserirVeiculo(@ModelAttribute Multa multa) {
            this.multaRepositorio.save(multa);
            return "redirect:multas";
        }

        @GetMapping("/inserir-multa")
        public String inserirMultaView(Model model) {
            model.addAttribute("multa", new Multa());
            return "inserir-multa";
        }
}
