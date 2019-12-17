package br.edu.ifpb.p3bd2.repositorio;

import br.edu.ifpb.p3bd2.modelo.condutorCarteira;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.awt.*;

public interface condutorCarteiraRepositorio extends CrudRepository <condutorCarteira, String> {


    //@Query(nativeQuery = true, value = "SELECT * FROM condutor_carteira")
    //List<condutorCarteira> gerarSQL();

}
