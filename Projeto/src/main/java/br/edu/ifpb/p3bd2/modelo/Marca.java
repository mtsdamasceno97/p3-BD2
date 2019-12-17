package br.edu.ifpb.p3bd2.modelo;


import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Size;

@Entity
@Data
public class Marca {

    @Id
    @Column(nullable = false, name = "idmarca")
    private Integer idMarca;

    @Size(min=40, max = 40)
    @Column(length = 40, nullable = false, name = "nome")
    private String nome;

    @Size(min=40, max = 40)
    @Column(length = 40, nullable = false, name = "origem")
    private String origem;



}
