package com.neuedu.service.user;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.neuedu.dao.UserMapper;

import com.neuedu.pojo.User;
import com.neuedu.pojo.UserExample;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class UserServieImpl implements UserService {
    @Resource
    UserMapper userMapper;
    @Override
    public User login(User user) {
        UserExample userExample = new UserExample();
        UserExample.Criteria criteria = userExample.createCriteria();
        criteria.andLoginIdEqualTo(user.getLoginId());
        List<User> users = userMapper.selectByExample(userExample);
        if(users.size()>0)
            return users.get(0);
        return null;
    }

    @Override
    public List<User> list(User user) {
        PageHelper.startPage(user.getPageNo(),user.getPageSize() );
        UserExample userExample = new UserExample();
        UserExample.Criteria criteria = userExample.createCriteria();
        if(StringUtils.isNotBlank(user.getLoginId()))
            criteria.andLoginIdEqualTo(user.getLoginId());
        if(StringUtils.isNotBlank(user.getName()))
            criteria.andNameLike("%"+user.getName()+"%");
        if(StringUtils.isNotBlank(user.getPhone()))
            criteria.andPhoneEqualTo(user.getPhone());
        if(user.getSex()!=null)
            criteria.andSexEqualTo(user.getSex());
        List<User> users = userMapper.selectByExample(userExample);
        return users;
    }
}
