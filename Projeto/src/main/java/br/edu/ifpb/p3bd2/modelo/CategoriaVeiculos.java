package br.edu.ifpb.p3bd2.modelo;


import lombok.Data;

import javax.persistence.*;
import javax.validation.constraints.Size;
import java.io.Serializable;

@Entity
@Data
@Table(name = "categoria_veiculos")
public class CategoriaVeiculos implements Serializable{

        @Id
        @Column(nullable = false, name = "idcategoria")
        private Integer idCategoria;

        @Size(min = 30, max = 30)
        @Column(length = 30, nullable = false, name = "descricao")
        private String descricao;

        @ManyToOne
        @JoinColumn(name = "idespecie")
        private Especie idEspecie;

}
