package com.codegnan.cgecom;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class JspwithbootApplication {
	public static void main(String[] args) {
		SpringApplication.run(JspwithbootApplication.class, args);
	}
}
