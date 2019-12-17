package br.edu.ifpb.p3bd2.modelo;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.validation.constraints.Size;

@Entity
@Data
public class Tipo {

    @Id
    @Column(name = "idtipo")
    private Integer idTipo;

    @Size(min = 30, max = 30)
    @Column(length = 30, nullable = false, name = "descricao")
    private String descricao;
}
