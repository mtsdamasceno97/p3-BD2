package br.edu.ifpb.p3bd2.modelo;


import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.validation.constraints.Size;

@Entity
@Data
public class Estado {


    @Id
    @Size(min = 2, max = 2)
    @Column(length = 2, name = "uf")
    private String uf;

    @Size(min = 40, max = 40)
    @Column(length = 40, name = "nome")
    private String nome;
}
