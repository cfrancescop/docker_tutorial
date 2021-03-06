package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.ZonedDateTime;

@RestController
public class DemoController {

    @GetMapping("/now")
    public String now(){
        return ZonedDateTime.now().toString();
    }
    @GetMapping("/greetings")
    public String greetings(){
        return "Hello from "+System.getenv("APP_NAME");
    }
}
