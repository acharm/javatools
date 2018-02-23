package org.acharm.jetty.web.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.acharm.jetty.web.bean.Block;
import org.acharm.jetty.web.bean.Item;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class BlockController {

    @RequestMapping("/")
    public ModelAndView h1(HttpServletRequest request) {
        System.out.println("!!!!");
        return new ModelAndView("blockList");
    }
    
    @RequestMapping("/getAllBlock")
    @ResponseBody
    public String getAllBlock() {
        List<Block> blockList = new ArrayList<Block>();
        Item it11 = new Item();
        it11.setBlock("block11");
        it11.setName("name11");
        it11.setOffset("offset11");
        it11.setPoint("point11");
        it11.setPrecision("precision11");
        it11.setType("type11");
        it11.setValue("value11");
        List<Item> itLst = new ArrayList<Item>();
        itLst.add(it11);
        Block blk1 = new Block();
        blk1.setAction("action1");
        blk1.setArea("area1");
        blk1.setItemList(itLst);
        blk1.setName("name1");
        blk1.setPoints("points");
        blk1.setStartAddress("startAddress");
        blockList.add(blk1);
        System.out.println(11);
        Map<String, String> model = new HashMap<String, String>();
        String blockListStr = "";
        try {
            blockListStr = new ObjectMapper().writeValueAsString(blockList);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        model.put("blockListStr", blockListStr);
        return blockListStr;
    }
}
