package br.edu.ifpb.p3bd2.repositorio;

import br.edu.ifpb.p3bd2.modelo.Multa;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.CrudRepository;
import org.springframework.transaction.annotation.Transactional;

public interface MultaRepositorio extends CrudRepository <Multa, String> {

    @Transactional
    @Procedure(procedureName = "dataVencimento")
    String gerarDataVencimento();

}
