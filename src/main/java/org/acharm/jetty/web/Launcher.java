package org.acharm.jetty.web;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;

public class Launcher {

    public static void main(String[] args) {
        String filePath = System.getProperty("user.dir") + "/src/main/resources";
System.out.println(filePath);
        try {
            Server server = new Server(80);
            WebAppContext context = new WebAppContext();
            context.setDescriptor(filePath + "/conf/web.xml");
            context.setResourceBase(filePath + "/conf/");
            context.setParentLoaderPriority(true);

            server.setHandler(context);
            server.start();
            System.out.println("^^^^^^^");
            server.join();
            System.out.println("&&&&&&&");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
