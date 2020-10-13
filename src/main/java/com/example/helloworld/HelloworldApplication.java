
package com.example.helloworld;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class HelloworldApplication {

  @Value("${NAME:World}")
  String name;

  @RestController
  class HelloworldController {
    @GetMapping("/")
    String hello() {
      return "Hello " + name + "!";
    }
  }

  public static void main(String[] args) {
    SpringApplication.run(HelloworldApplication.class, args);
  }
  
  private static final Tracer tracer = Tracing.getTracer();

  public static void doWork() {
    // Create a child Span of the current Span.
    try (Scope ss = tracer.spanBuilder("MyChildWorkSpan").startScopedSpan()) {
      doInitialWork();
      tracer.getCurrentSpan().addAnnotation("Finished initial work");
      doFinalWork();
    }
  }

  private static void doInitialWork() {
    // ...
    tracer.getCurrentSpan().addAnnotation("Doing initial work");
    // ...
  }

  private static void doFinalWork() {
    // ...
    tracer.getCurrentSpan().addAnnotation("Hello world!");
    // ...
  }

}