package br.edu.ifpb.p3bd2.modelo;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Data
@Table(name = "infracao_multa")
public class InfracaoMulta {

    @Id
    @Column(name = "quantidade_infracoes")
    private Integer quantidadeInfracoes;

    @Column(name = "valor_multas")
    private Double valorMultas;

    @Column(name = "mes")
    private Integer mes;

    @Column(name = "ano")
    private Integer ano;

}
