package es.microservices.spring.netflix.eureka;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

import es.microservices.spring.netflix.eureka.EurekaStarter;

@EnableEurekaServer
@SpringBootApplication
public class EurekaStarter {
	
	public boolean testMethod() {
		System.out.println("TEST");
		return true;
	}

	public static void main(String[] args) {
		SpringApplication.run(EurekaStarter.class, args);
	}
}
