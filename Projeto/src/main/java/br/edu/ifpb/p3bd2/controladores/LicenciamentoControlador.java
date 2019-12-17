package br.edu.ifpb.p3bd2.controladores;

import br.edu.ifpb.p3bd2.modelo.Licenciamento;
import br.edu.ifpb.p3bd2.modelo.Veiculo;
import br.edu.ifpb.p3bd2.repositorio.LicenciamentoRepositorio;
import br.edu.ifpb.p3bd2.repositorio.VeiculoRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Controller
@RequestMapping("/licenciamentos")
public class LicenciamentoControlador {

    private LicenciamentoRepositorio licenciamentoRepositorio;
    private VeiculoRepositorio veiculoRepositorio;

    @Autowired
    public LicenciamentoControlador(LicenciamentoRepositorio licenciamentoRepositorio,VeiculoRepositorio veiculoRepositorio) {
        this.licenciamentoRepositorio = licenciamentoRepositorio;
        this.veiculoRepositorio = veiculoRepositorio;
    }

    @GetMapping
    public String listarLicenciamentos() {
        return "exibir-licenciamento";
    }

    @GetMapping("/calculo-licenciamento")
    public String calculoLicenciamento(Model model) {
        model.addAttribute("veiculo", new Veiculo());
        return "calculo-licenciamento";
    }

    @PostMapping("/calculo-licenciamento")
    public String calcLicenciamento(@RequestParam("renavam") String renavam, Model model) {
        model.addAttribute("licenciamentos", this.licenciamentoRepositorio.gerarSQL(renavam));
        return "exibir-licenciamento";
    }

}
