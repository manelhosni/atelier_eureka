package com.example.gateway;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration complète de l'API Gateway pour TOUS les microservices :
 * - Candidat       (Port 8081 | Eureka: candidat)
 * - Canditature    (Port 8085 | Eureka: canditature)
 * - Job            (Port 8082 | Eureka: job)
 * - Meeting        (Port 8083 | Eureka: MEETING)
 * - Notification   (Port 8084 | Eureka: NOTIFICATION)
 *
 * Fonctionnalités :
 * 1. Mode Direct (configuré par gateway.routing.mode : "dynamic" par défaut, ou "static") :
 *    - http://localhost:9090/candidat/...     ou /candidates/...
 *    - http://localhost:9090/canditature/...  ou /candidature/...
 *    - http://localhost:9090/job/...         ou /jobs/...
 *    - http://localhost:9090/meeting/...     ou /meetings/...
 *    - http://localhost:9090/notification/...ou /notifications/...
 *
 * 2. Mode Dédié Statique (toujours actif pour tests simultanés) :
 *    - http://localhost:9090/static/candidat/...
 *    - http://localhost:9090/static/candidature/...
 *    - http://localhost:9090/static/job/...
 *    - http://localhost:9090/static/meeting/...
 *    - http://localhost:9090/static/notification/...
 */
@Configuration
public class GatewayConfig {

    @Value("${gateway.routing.mode:dynamic}")
    private String routingMode;

    @Bean
    public RouteLocator allGatewayRoutes(RouteLocatorBuilder builder) {
        boolean isDynamic = !"static".equalsIgnoreCase(routingMode);

        String candidatTarget     = isDynamic ? "lb://candidat"     : "http://localhost:8081";
        String canditatureTarget  = isDynamic ? "lb://canditature"  : "http://localhost:8085";
        String jobTarget          = isDynamic ? "lb://job"          : "http://localhost:8082";
        String meetingTarget      = isDynamic ? "lb://MEETING"      : "http://localhost:8083";
        String notificationTarget = isDynamic ? "lb://NOTIFICATION" : "http://localhost:8084";

        return builder.routes()

                // =====================================================================
                // ROUTES DIRECTES (DYNAMIQUE lb:// ou STATIQUE selon routingMode)
                // =====================================================================

                // 1. Candidat
                .route("route-candidat", r -> r
                        .path("/candidat/**", "/candidats/**", "/candidates/**", "/mic1/**")
                        .uri(candidatTarget))

                // 2. Canditature
                .route("route-canditature", r -> r
                        .path("/canditature/**", "/candidature/**", "/candidatures/**", "/cantitature/**", "/mic3/**")
                        .uri(canditatureTarget))

                // 3. Job
                .route("route-job", r -> r
                        .path("/job/**", "/jobs/**", "/api/jobs/**", "/api/categories/**", "/categories/**")
                        .uri(jobTarget))

                // 4. Meeting
                .route("route-meeting", r -> r
                        .path("/meeting/**", "/meetings/**", "/api/meetings/**")
                        .uri(meetingTarget))

                // 5. Notification
                .route("route-notification", r -> r
                        .path("/notification/**", "/notifications/**", "/api/notifications/**")
                        .uri(notificationTarget))

                // =====================================================================
                // ROUTES STATIQUES DÉDIÉES (Préfixe /static/ - toujours en port fixe)
                // Permet de tester la méthode statique SANS Eureka
                // =====================================================================

                .route("static-candidat-explicit", r -> r
                        .path("/static/candidat/**", "/static/candidates/**")
                        .filters(f -> f.rewritePath("/static/(?:candidat|candidates)/(?<segment>.*)", "/${segment}"))
                        .uri("http://localhost:8081"))

                .route("static-canditature-explicit", r -> r
                        .path("/static/canditature/**", "/static/candidature/**", "/static/cantitature/**")
                        .filters(f -> f.rewritePath("/static/(?:canditature|candidature|cantitature)/(?<segment>.*)", "/${segment}"))
                        .uri("http://localhost:8085"))

                .route("static-job-explicit", r -> r
                        .path("/static/job/**", "/static/jobs/**")
                        .filters(f -> f.rewritePath("/static/(?:job|jobs)/(?<segment>.*)", "/${segment}"))
                        .uri("http://localhost:8082"))

                .route("static-meeting-explicit", r -> r
                        .path("/static/meeting/**", "/static/meetings/**")
                        .filters(f -> f.rewritePath("/static/(?:meeting|meetings)/(?<segment>.*)", "/${segment}"))
                        .uri("http://localhost:8083"))

                .route("static-notification-explicit", r -> r
                        .path("/static/notification/**", "/static/notifications/**")
                        .filters(f -> f.rewritePath("/static/(?:notification|notifications)/(?<segment>.*)", "/${segment}"))
                        .uri("http://localhost:8084"))

                .build();
    }
}
