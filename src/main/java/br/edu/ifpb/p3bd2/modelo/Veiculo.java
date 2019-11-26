package br.edu.ifpb.p3bd2.modelo;

import lombok.Data;
import javax.persistence.*;
import javax.validation.constraints.Size;
import java.time.LocalDateTime;

@Entity
@Data
public class Veiculo {

	private enum Situacao {
		R, I, B
	}

	@Id
	@Size(min = 13, max = 13)
	@Column(length = 13, name = "renavam")
	private String renavam;

	@Size(min = 7, max = 7)
	@Column(length = 7, nullable = false, name = "placa")
	private String placa;

	@Column(nullable = false, name = "ano")
	private Integer ano;

	@Column(nullable = false, name = "datacompra")
	private LocalDateTime dataCompra;

	@Column(nullable = false, name = "dataaquisicao")
	private LocalDateTime dataAquisicao;

	@Column(nullable = false, name = "valor")
	private Float valor;

	@Enumerated(EnumType.STRING)
	@Column(length = 1, name = "situacao")
	private Situacao situacao;

}
