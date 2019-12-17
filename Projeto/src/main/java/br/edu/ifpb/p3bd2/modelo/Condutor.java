package br.edu.ifpb.p3bd2.modelo;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import javax.validation.constraints.Size;
import java.time.LocalDate;

@Entity
@Data
@Table(name = "condutor")
public class Condutor {

    private enum SituacaoCNH {
        R, S
    }

    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(nullable = false,name = "idcadastro")
    private Integer idCadastro;

    @Size(min = 11, max = 11)
    @Column(length = 11, nullable = false, name = "cpf")
    private String cpf;

    @Size(max = 50)
    @Column(length = 50, nullable = false, name = "nome")
    private String nome;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Column(nullable = false, name = "datanasc")
    private LocalDate dataNasc;

    @ManyToOne
    @JoinColumn(name = "idcategoriacnh")
    private CategoriaCNH categoriaCNH;


    @Size(max = 100)
    @Column(length = 100, nullable = false, name = "endereco")
    private String endereco;


    @Size(max = 50)
    @Column(length = 50, nullable = false, name = "bairro")
    private String bairro;

    @ManyToOne
    @JoinColumn(name = "idcidade")
    private Cidade cidade;

    @Enumerated(EnumType.STRING)
    @Column(length = 1, name = "situacaocnh")
    private SituacaoCNH situacaoCNH;
}

