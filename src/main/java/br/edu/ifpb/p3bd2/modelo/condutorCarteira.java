package br.edu.ifpb.p3bd2.modelo;


import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Size;

@Entity
@Data
@Table(name = "condutor_carteira")
public class condutorCarteira {

    @Id
    @Column(nullable = false,name = "condutor")
    private Integer condutor;

    @Size(max = 50)
    @Column(length = 50,nullable = false,name = "nome_condutor")
    private String nomeCondutor;

    @Size(max = 3)
    @Column(length = 3, nullable = false,name = "categoria_cnh")
    private String categoriaCNH;

    @Column(name = "pontos_infracoes")
    private Integer pontosInfracoes;

    @Column(name = "ano_infracao")
    private Integer anoInfracao;
}
