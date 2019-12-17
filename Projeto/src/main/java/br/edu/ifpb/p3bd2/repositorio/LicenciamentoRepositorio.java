package br.edu.ifpb.p3bd2.repositorio;

import br.edu.ifpb.p3bd2.modelo.Licenciamento;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface LicenciamentoRepositorio extends CrudRepository <Licenciamento, String> {

    @Query(nativeQuery = true, value = "SELECT * FROM Licenciamento l WHERE l.renavam = :renavam")
    List<Licenciamento> gerarSQL(@Param("renavam") String renavam);

}
