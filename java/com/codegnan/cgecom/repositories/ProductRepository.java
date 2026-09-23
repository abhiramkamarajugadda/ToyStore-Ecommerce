package com.codegnan.cgecom.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.codegnan.cgecom.model.Product;

public interface ProductRepository extends JpaRepository<Product, Integer> {}