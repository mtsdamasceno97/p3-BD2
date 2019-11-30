package br.edu.ifpb.p3bd2.controladores;

import br.edu.ifpb.p3bd2.repositorio.MultaRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/multa")
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

        //@PostMapping
        //public String inserirVeiculo(@ModelAttribute Veiculo veiculo) {
          //  veiculo.setRenavam(this.veiculoRepositorio.gerarRenavam());
            //this.veiculoRepositorio.save(veiculo);
            //return "redirect:veiculos";
        //}

        //@GetMapping("/inserir-veiculo")
        //public String inserirVeiculoView(Model model) {
          //  model.addAttribute("veiculo", new Veiculo());
            //return "inserir-veiculo";
        //}
}
