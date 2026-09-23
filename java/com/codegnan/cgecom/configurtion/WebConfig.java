package com.codegnan.cgecom.configurtion;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Serve images from the 'uploads/images' folder in the root of the project
        registry.addResourceHandler("/uploads/images/**")  // URL path to access images
                .addResourceLocations("file:uploads/images/");  // Physical path to the folder
    }
}