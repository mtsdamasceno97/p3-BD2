package br.edu.ifpb.p3bd2.modelo;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import javax.validation.constraints.Size;
import java.time.LocalDate;

@Entity
@Data
public class Multa {

    private enum Pago {

        S,N

    }

    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(nullable = false, name = "idmulta")
    private Integer idMulta;


    @Size(min = 11, max = 11)
    @Column(nullable = false, length = 11, name = "renavam")
    private String renavam;

    @ManyToOne
    @JoinColumn(nullable = false,name = "idinfracao")
    private Infracao idInfracao;

    @ManyToOne
    @JoinColumn(name = "idcondutor")
    private Condutor idCondutor;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Column(nullable = false, name = "datainfracao")
    private LocalDate dataInfracao;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Column(nullable = false, name = "datavencimento")
    private LocalDate dataVencimento;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Column(name = "datapagamento")
    private LocalDate dataPagamento;

    @Column(name = "valor")
    private  Double valor;

    @Column(name = "juros")
    private Double juros;

    @Column(name = "valorfinal")
    private Double valorFinal;

    @Enumerated(EnumType.STRING)
    @Column(length = 1, name = "pago")
    private Pago pago;


}
