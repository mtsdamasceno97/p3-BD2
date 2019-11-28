package br.edu.ifpb.p3bd2.repositorio;

import br.edu.ifpb.p3bd2.modelo.Veiculo;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface VeiculoRepositorio extends CrudRepository<Veiculo, String> {

    @Transactional
    @Procedure(procedureName = "renavam")
    String gerarRenavam();

}
