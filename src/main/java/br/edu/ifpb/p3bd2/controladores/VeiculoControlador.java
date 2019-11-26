package br.edu.ifpb.p3bd2.controladores;

import br.edu.ifpb.p3bd2.repositorio.VeiculoRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/veiculos")
public class VeiculoControlador {

	private VeiculoRepositorio veiculoRepositorio;

	@Autowired
	public VeiculoControlador(VeiculoRepositorio veiculoRepositorio) {
		this.veiculoRepositorio = veiculoRepositorio;
	}

	@GetMapping
	public String listarVeiculos(Model model) {
		model.addAttribute("veiculos", this.veiculoRepositorio.findAll());
		return "veiculos";
	}

	@GetMapping("/inserir-veiculo")
	public String inserirVeiculo() {
		return "inserir-veiculo";
	}

}
