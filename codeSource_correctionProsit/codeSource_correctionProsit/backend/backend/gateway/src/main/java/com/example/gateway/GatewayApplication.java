package com.example.gateway;

import com.example.gateway.config.CustomRandomLoadBalancerConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.loadbalancer.annotation.LoadBalancerClient;

@SpringBootApplication
@EnableDiscoveryClient
// Partie 3 - Question 3 : Application du Load Balancer RANDOM au service candidat
@LoadBalancerClient(name = "candidat", configuration = CustomRandomLoadBalancerConfig.class)
public class GatewayApplication {

    public static void main(String[] args) {
        SpringApplication.run(GatewayApplication.class, args);
    }
}
