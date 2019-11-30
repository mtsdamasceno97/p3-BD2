package br.edu.ifpb.p3bd2.modelo;

import lombok.Data;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.validation.constraints.Size;

@Entity
@Data
public class Infracao {

    @Id
    @Column(name="idinfracao")
    private Integer idInfracao;

    @Size(min=50, max=50)
    @Column(nullable = false,length = 50,name = "descricao")
    private String descricao;

    @Column(nullable = false,name = "valor")
    private Double valor;

    @Column(nullable = false, name = "pontos")
    private Integer pontos;

}
