package br.edu.ifpb.p3bd2.modelo;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;

import javax.persistence.*;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.time.LocalDate;

@Entity
@Data
public class Licenciamento implements Serializable {

    private enum Pago {
       S,N
    }


    @Column(nullable = false, name = "ano")
    private Integer ano;

    @Id
    @Size(min = 11, max = 11)
    @Column(length = 11, nullable = false, name = "renavam")
    private String renavam;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Column(nullable = false, name = "datavenc")
    private LocalDate dataVenc;

    @Enumerated(EnumType.STRING)
    @Column(length = 1, name = "pago")
    private Licenciamento.Pago pago;
}
