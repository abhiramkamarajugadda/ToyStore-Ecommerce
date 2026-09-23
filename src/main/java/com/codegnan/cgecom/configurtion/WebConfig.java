package com.codegnan.cgecom.configurtion;

import java.nio.file.Path;
import java.nio.file.Paths;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        Path uploadDir = Paths.get("uploads/images").toAbsolutePath().normalize();
        String uploadUri = uploadDir.toUri().toString();
        
        // Serve images from the 'uploads/images' folder with absolute and relative paths
        registry.addResourceHandler("/uploads/images/**")
                .addResourceLocations(uploadUri, "file:uploads/images/", "file:./uploads/images/");
    }
}