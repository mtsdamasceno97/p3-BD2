package br.edu.ifpb.p3bd2.modelo;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Size;
import java.io.Serializable;

@Entity
@Data
@Table(name = "especie")
public class Especie {

    @Id
    @Column(name = "idespecie")
    private Integer idEspecie;

    @Size(min = 30, max = 30)
    @Column(length = 30, nullable = false, name = "descricao")
    private String descricao;
}

