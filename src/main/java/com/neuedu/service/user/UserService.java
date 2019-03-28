package com.neuedu.service.user;

import com.neuedu.pojo.User;

import java.util.List;

public interface UserService {
    User login(User user);
    List<User> list(User user);
}
