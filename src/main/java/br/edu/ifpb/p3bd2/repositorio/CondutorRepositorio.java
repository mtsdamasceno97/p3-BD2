package br.edu.ifpb.p3bd2.repositorio;

import br.edu.ifpb.p3bd2.modelo.Condutor;
import br.edu.ifpb.p3bd2.modelo.Veiculo;
import org.springframework.data.repository.CrudRepository;

public interface CondutorRepositorio extends CrudRepository<Condutor, String> {  }
