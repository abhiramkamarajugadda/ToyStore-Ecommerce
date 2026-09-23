package com.project;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@ComponentScan(basePackages = {"com.codegnan.cgecom", "com.project"})
@EnableJpaRepositories(basePackages = "com.codegnan.cgecom.repositories")
@EntityScan(basePackages = "com.codegnan.cgecom.model")
public class ToyStoreApplication {

	public static void main(String[] args) {
		SpringApplication.run(ToyStoreApplication.class, args);
	}

}
