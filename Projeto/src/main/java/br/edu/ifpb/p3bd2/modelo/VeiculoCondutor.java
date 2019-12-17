package br.edu.ifpb.p3bd2.modelo;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Size;

@Entity
@Data
@Table(name = "veiculo_condutor")
public class VeiculoCondutor {

    @Id
    @Size(max = 11)
    @Column(length = 11,nullable = false,name = "renavam")
    private String renavam;

    @Size(max = 7)
    @Column(length = 7,nullable = false,name = "placa")
    private String placa;

    @Size(max=50)
    @Column(length = 50, nullable = false,name = "condutor")
    private String condutor;

    @Size(max=40)
    @Column(length = 40,nullable = false,name = "modelo")
    private String modelo;

    @Size(max = 40)
    @Column(length = 40,nullable = false,name = "marca")
    private String marca;

    @Size(max=40)
    @Column(length = 40,nullable = false, name = "tipo")
    private String tipo;

    @Size(max =50)
    @Column(length = 50,nullable = false,name = "cidade")
    private String cidade;

    @Size(min = 2, max = 2)
    @Column(length = 2,nullable = false, name = "estado")
    private String estado;
}
