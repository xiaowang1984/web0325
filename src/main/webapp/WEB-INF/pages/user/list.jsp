<%--
  Created by IntelliJ IDEA.
  User: wangyu
  Date: 2019/3/25
  Time: 15:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/common/head.jsp"%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title></title>
    <link rel="stylesheet" href="${basepath}/css/pintuer.css">
    <link rel="stylesheet" href="${basepath}/css/admin.css">
    <script src="${basepath}/js/jquery.js"></script>
    <script src="${basepath}/js/pintuer.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
</head>
<body>
    <div id="app" class="panel admin-panel">
        <div class="padding border-bottom">
            <ul class="search" style="padding-left:10px;">
              <li>
                    <select v-model="whereparams.sex" name="s_istop" class="input" style="width:60px; line-height:17px;display:inline-block">
                        <option value="">性别</option>
                        <option value="1">男</option>
                        <option value="0">女</option>
                    </select>
                </li>
                <li>
                    <input v-model="whereparams.loginId" type="text" placeholder="请输入登录ID"   class="input" style="width:150px; line-height:17px;display:inline-block" />
                    <input v-model="whereparams.name" type="text" placeholder="请输入用户名称"   class="input" style="width:150px; line-height:17px;display:inline-block" />
                    <input v-model="whereparams.phone" type="text" placeholder="请输入电话号码"  class="input" style="width:150px; line-height:17px;display:inline-block" />
                    <a href="javascript:void(0)" class="button border-main icon-search" @click="search()"> 搜索</a></li>
            </ul>
        </div>
        <table class="table table-hover text-center">
            <thead>
            <tr>
                <th>登录名</th>
                <th>用户名</th>
                <th>电话</th>
                <th>性别</th>
                <th>email</th>
                <th>地址</th>
                <th>生日</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
                <tr v-for="user in list">
                    <td>{{user.loginId}}</td>
                    <td>{{user.name}}</td>
                    <td>{{user.phone}}</td>
                    <td>
                        <template v-if="user.sex==1">男</template>
                        <template v-else>女</template>
                    </td>
                    <td>{{user.email}}</td>
                    <td>{{user.address}}</td>
                    <td>{{user.birthday}}</td>
                    <td></td>
                </tr>
            </tbody>
        </table>
        <div class="pagelist">
            <a v-if="queryparams.pageNo==1"  href="javascript:void(0)" >首页</a>
            <a v-else href="javascript:void(0)" @click="changePageNo(1)" >首页</a>
            <a v-if="queryparams.pageNo==1" href="javascript:void(0)">上一页</a>
            <a v-else href="javascript:void(0)" @click="changePageNo(queryparams.pageNo-1)">上一页</a>
            <template v-if="max<=5">
                <template v-for="n in max">
                    <span v-if="n == queryparams.pageNo" class="current">{{n}}</span>
                    <a v-else href="javascript:void(0)" @click="changePageNo(n)">{{n}}</a>
                </template>
            </template>
            <template v-else>
                <template v-for="n in 5">
                    <span v-if="(n+size.start-1) == queryparams.pageNo" class="current">{{n+size.start-1}}</span>
                    <a v-else href="javascript:void(0)" @click="changePageNo(n+size.start-1)">{{n+size.start-1}}</a>
                </template>
            </template>
            <a href="javascript:void(0)" @click="changeInput($event)">
                <span v-if="flag == 0" @click="changeInput()">...</span>
               <input v-else  v-model="keyPage" style="width:35px" @keydown="changePage($event)" /></a>
            <a v-if="queryparams.pageNo==max" href="javascript:void(0)">下一页</a>
            <a v-else  href="javascript:void(0)" @click="changePageNo(pageNo+1)">下一页</a>
            <a v-if="queryparams.pageNo==max" href="javascript:void(0)">尾页</a>
            <a v-else href="javascript:void(0)" @click="changePageNo(max)">尾页</a>
        </div>
    </div>
    <script>
        new Vue({
            el:"#app",
            data(){
                return {
                    list:[],
                    max:0,
                    flag:0,
                    keyPage:1,
                    queryparams:{
                        name:"",
                        loginId:"",
                        phone:"",
                        sex:"",
                        pageNo:1,
                    },
                    whereparams:{
                        name:"",
                        loginId:"",
                        phone:"",
                        sex:"",
                        pageNo:1
                    }
                }
            },
            computed:{
                size(){
                    let start = this.queryparams.pageNo-2;
                    let end = this.queryparams.pageNo+2;
                    if(start<=0){
                        start=1;
                        end=5;
                    }
                    if(end>this.max){
                        end=this.max;
                        start=end-4;
                    }
                    return {
                        start:start,
                        end:end
                    }
                }
            },
            created(){
                this.getList();
            },
            methods:{
                changePageNo(n){
                   this.queryparams.pageNo=n;
                   this.getList();
                },
                changeInput(){
                    this.flag=1;
                },
                changePage(e){
                   if(e.keyCode==13){
                       this.flag=0;
                       this.queryparams.pageNo=parseInt(this.keyPage);
                       this.getList();
                   }
                },
                getList(){
                    let vue = this;
                    $.ajax({
                        url:"${basepath}/user/getList",
                        dataType:"json",
                        data:vue.queryparams,
                        success:function(result){
                            console.log(result);
                            vue.list=result.message.list;
                            vue.queryparams.pageNo=result.message.pageNo;
                            vue.max=result.message.maxSize;
                        }
                    });
                },
                search(){
                    this.queryparams=this.whereparams;
                    this.getList();
                }
            }
        });
    </script>
</body>
</html>
