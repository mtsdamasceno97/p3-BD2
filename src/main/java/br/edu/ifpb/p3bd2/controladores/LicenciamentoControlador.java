package br.edu.ifpb.p3bd2.controladores;

import br.edu.ifpb.p3bd2.repositorio.LicenciamentoRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/licenciamentos")
public class LicenciamentoControlador {

    private LicenciamentoRepositorio licenciamentoRepositorio;

    @Autowired
    public LicenciamentoControlador(LicenciamentoRepositorio licenciamentoRepositorio) {
        this.licenciamentoRepositorio = licenciamentoRepositorio;
    }

    @GetMapping
    public String listarLicenciamentos(Model model) {
        model.addAttribute("licenciamentos", this.licenciamentoRepositorio.findAll());
        return "licenciamentos";
    }


}
