package org.glory.jetty.web.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class BlockController {

    @RequestMapping("/")
    public ModelAndView h1(HttpServletRequest request) {
        System.out.println("!!!!");
        return new ModelAndView("blockList");
    }
}
