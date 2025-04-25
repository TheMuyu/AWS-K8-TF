package com.muyurtd.sumapi.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {
    @GetMapping("/healthz")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("Backend is healthy");
    }
}
