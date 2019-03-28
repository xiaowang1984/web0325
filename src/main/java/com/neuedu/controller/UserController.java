package com.neuedu.controller;

import com.github.pagehelper.Page;
import com.neuedu.pojo.User;
import com.neuedu.service.user.UserService;
import com.neuedu.util.Message;
import com.neuedu.util.MyUtil;
import com.neuedu.util.Result;
import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
import java.util.Random;
import java.util.Set;


@Controller
@RequestMapping("/user")
public class UserController {
    @Resource
    UserService userService;
    @GetMapping("/login")
    public String goLogin(){
        return "login";
    }
    @PostMapping("/login")
    @ResponseBody
    public Message doLogin(User user, String code, HttpServletResponse response, HttpSession session) throws IOException {
        // 判断用户登录信息
        Message message = null;
        User login = userService.login(user);
        if(login == null)
            message = new Message(0, "用户名不存在");
        else{
            if(!login.getPassword().equals(user.getPassword())){
                message = new Message(0, "密码输入错误");
            }else{
                if(session.getAttribute("img")==null){
                    message = new Message(0, "登录超时");
                }else{
                    String img = session.getAttribute("img").toString();
                    if(!img.equalsIgnoreCase(code))
                        message = new Message(0, "验证码输入错误");
                    else
                        message = new Message(1, "登录成功");
                }
            }
        }
        return message;
    }

    @GetMapping("/img")
    public void getImg(HttpServletResponse response, HttpSession session) throws IOException {
        char[] arrray = MyUtil.getStr();
        BufferedImage image = new BufferedImage(100, 43, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = image.createGraphics();
        graphics.setColor(Color.BLACK);
        graphics.fillRect(0, 0, 100, 43);
        graphics.setColor(Color.WHITE);
        graphics.setFont(new Font("微软雅黑", Font.BOLD, 32));
        graphics.drawString(new String(arrray), 5, 30);
        session.setAttribute("img", new String(arrray));
        ImageIO.write(image, "JPG", response.getOutputStream());
    }
    @GetMapping("/list")
    public String list(){
        return "user/list";
    }
    @GetMapping("/getList")
    @ResponseBody
    public Message getList(User user){
         Page<User> users = (Page<User>)userService.list(user);
        return  new Message(1, new Result(users, users.getPageNum() , (int) users.getTotal(),users.getPageSize() ));
    }
    @GetMapping("/add")
    public String goAdd(){
        return "user/add";
    }
    @PostMapping("/add")
    public void doAdd(MultipartFile img, HttpServletRequest request){
        DateFormat df = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        StringBuilder builder = new StringBuilder(df.format(new Date()));
        Random random = new Random();
        for(int i=0;i<4;i++)
            builder.append(random.nextInt(10));


        File file = new File(request.getServletContext().getRealPath("/resource/images/")+builder.toString()+"."+FilenameUtils.getExtension( img.getOriginalFilename()));
        try {
            img.transferTo(file);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
