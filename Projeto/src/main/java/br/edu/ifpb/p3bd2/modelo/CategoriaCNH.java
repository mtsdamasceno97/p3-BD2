package br.edu.ifpb.p3bd2.modelo;


import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Size;

@Entity
@Data
@Table(name = "categoria_cnh")
public class CategoriaCNH {

    @Id
    @Size(max = 3)
    @Column(name = "idcategoriacnh")
    private String idCategoriaCNH;


    @Column(name = "descricao")
    private String descricao;



}
