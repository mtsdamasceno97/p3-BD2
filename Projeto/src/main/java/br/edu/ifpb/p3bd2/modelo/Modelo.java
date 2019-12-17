package br.edu.ifpb.p3bd2.modelo;


import lombok.Data;

import javax.persistence.*;
import javax.validation.constraints.Size;

@Entity
@Data
public class Modelo {

    @Id
    @Column(nullable = false, name = "idmodelo")
    private Integer idModelo;

    @Size(min = 40, max = 40)
    @Column(length = 40,nullable = false, name = "denominacao")
    private String denominacao;

    @ManyToOne
    @JoinColumn(name = "idmarca")
    private Marca idMarca;

    @ManyToOne
    @JoinColumn(name = "idtipo")
    private Tipo idTipo;

}
