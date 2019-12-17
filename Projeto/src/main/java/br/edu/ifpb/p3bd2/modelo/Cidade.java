package br.edu.ifpb.p3bd2.modelo;


import lombok.Data;

import javax.persistence.*;
import javax.validation.constraints.Size;

@Entity
@Data
public class Cidade {

    @Id
    @Column(name = "idcidade")
    private Integer idCidade;

    @Size(min = 50, max = 50)
    @Column(length = 50, name = "nome")
    private String nome;

    @ManyToOne
    @JoinColumn(name = "uf")
    @Size(min = 2, max = 2)
    private Estado uf;



}
